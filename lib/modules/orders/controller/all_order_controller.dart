import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/controller/order_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/services/apis/inventory/inventory_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';
import 'package:simple_ui/services/apis/user/user_apis.dart';

class AllOrderController extends GetxController {
  var orders = <OrderModel>[].obs;

  var filteredOrders = <OrderModel>[].obs;
  var filteredOrdersUnderAuction = <OrderModel>[].obs;
  var searchId = ''.obs;
  var searchAssignee = ''.obs;
  var selectedStatus = ''.obs;

  RxInt filterCount = 0.obs;
  RxBool isOrdersLoading = true.obs;
  RxInt pageNumber = 0.obs;
  RxInt currentPage = 0.obs; // Current page for UI pagination
  RxInt itemsPerPage = 10.obs; // Items per page for UI pagination
  RxBool isInventoryLoading = true.obs;
  RxMap<String, InventoryModel> inventoryMap = <String, InventoryModel>{}.obs;
  List<UserModel> deliveryUsers = <UserModel>[]; // List of delivery users
  // Computed property for paginated orders
  List<OrderModel> get paginatedOrders {
    final startIndex = currentPage.value * itemsPerPage.value;
    final endIndex = startIndex + itemsPerPage.value;
    if (startIndex >= filteredOrders.length) {
      return [];
    }
    return filteredOrders.sublist(
      startIndex,
      endIndex > filteredOrders.length ? filteredOrders.length : endIndex,
    );
  }

  // Total number of pages
  int get totalPages {
    return (filteredOrders.length / itemsPerPage.value).ceil();
  }

  // Check if there's a next page
  bool get hasNextPage {
    return currentPage.value < totalPages - 1;
  }

  // Check if there's a previous page
  bool get hasPrevPage {
    return currentPage.value > 0;
  }

  // Go to next page
  void nextPage() {
    if (hasNextPage) {
      currentPage.value++;
      update();
    }
  }

  // Go to previous page
  void prevPage() {
    if (hasPrevPage) {
      currentPage.value--;
      update();
    }
  }

  Future<void> getOrders() async {
    try {
      String role = Get.find<MainScreenController>().user!.roles![0];
      Map<String, dynamic>? response = await getAllOrdersApi(
          role: role,
          userId: Get.find<MainScreenController>().user!.userId,
          pageNumber: pageNumber.value,
          pageSize: 10000);
      if (response['status']) {
        List<OrderModel> allOrders = [];
        for (var i = 0; i < response['data']['orders'].length; i++) {
          allOrders.add(OrderModel.fromJson(response['data']['orders'][i]));
        }
        orders.assignAll(allOrders);
        isOrdersLoading.value = false;
      } else {
        isOrdersLoading.value = false;
      }
    } catch (e) {
      isOrdersLoading.value = false;
      if (kDebugMode) {
        log('Error occured in fetch orders: $e');
      }
    }
  }

  void fetchOrders() async {
    if (orders.isEmpty) {
      await Future.wait([getOrders(), fetchDeliveryUsers()]);
    }
    log("delivery Users length ${deliveryUsers.length}");
    filteredOrders.assignAll(orders);
    filterOrderUnderAuctionOnly();
    _fetchInventory();
  }

  void filterOrderUnderAuctionOnly() {
    filteredOrdersUnderAuction.assignAll(orders.where((order) =>
        (order.orderStatus == OrderStatus.biddingStarted ||
            order.orderStatus == OrderStatus.biddingInProgress ||
            order.orderStatus == OrderStatus.biddingCompleted ||
            order.orderStatus == OrderStatus.biddingRejected)));
  }

  void _fetchInventory() async {
    try {
      List<Future<Map<String, dynamic>?>> futures = orders.map((order) {
        return getInventoryByIdApi(orderId: order.eid.toString());
      }).toList();

      List<Map<String, dynamic>?> responses = await Future.wait(futures);

      for (var i = 0; i < responses.length; i++) {
        if (responses[i]?['status'] == true) {
          inventoryMap[orders[i].eid.toString()] =
              InventoryModel.fromJson(responses[i]!['data']);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error occurred in fetch inventory: $e');
      }
    } finally {
      if (Get.isRegistered<OrderController>()) {
        OrderController orderController = Get.find<OrderController>();
        if (orderController.currentInventory == null) {
          orderController.currentInventory =
              inventoryMap[orderController.currentOrder!.eid ?? ""];
          orderController.update();
        }
      }
      isInventoryLoading.value = false;
    }
  }

  void filterOrders({bool? useAllOrders = true}) {
    if (searchId.value.isNotEmpty) {
      filterCount.value = 1;
    } else {
      if (searchAssignee.isNotEmpty) {
        filterCount.value = 1;
      } else {
        if (selectedStatus.isNotEmpty) {
          filterCount.value = 1;
        } else {
          filterCount.value =
              filterCount.value > 0 ? filterCount.value - 1 : filterCount.value;
        }
      }
    }
    currentPage.value = 0; // Reset to first page when filtering
    update();
    if (useAllOrders!) {
      filteredOrders.assignAll(orders.where((order) {
        return (searchId.isEmpty ||
                order.eid!
                    .toLowerCase()
                    .contains(searchId.value.toLowerCase())) &&
            (searchAssignee.isEmpty ||
                order.assignee!
                    .toLowerCase()
                    .contains(searchAssignee.value.toLowerCase())) &&
            (selectedStatus.isEmpty ||
                selectedStatus.value == "All" ||
                order.orderStatus == selectedStatus.value);
      }).toList());
    } else {
      filteredOrdersUnderAuction.assignAll(
        orders.where((order) {
          return (searchId.isEmpty ||
                  order.eid!
                      .toLowerCase()
                      .contains(searchId.value.toLowerCase())) &&
              (searchAssignee.isEmpty ||
                  order.assignee!
                      .toLowerCase()
                      .contains(searchAssignee.value.toLowerCase())) &&
              (selectedStatus.isEmpty ||
                  selectedStatus.value == "All" ||
                  order.orderStatus == selectedStatus.value);
        }).toList(),
      );
    }
    update();
  }

  Future<void> fetchDeliveryUsers() async {
    try {
      Map<String, dynamic> response = await getAllUserApi();
      if (response['status']) {
        List<UserModel> allUsers = [];
        for (var i = 0; i < response['data'].length; i++) {
          UserModel user = UserModel.fromJson(response['data'][i]);
          if (user.roles?[0] == UserRole.deliveryAgent) {
            allUsers.add(user);
          }
        }
        deliveryUsers.assignAll(allUsers);
      }
    } catch (e) {
      log("Error in fetching delivery users ${e}");
    }
  }

  void clearFilters({bool? useAllOrders = true}) {
    searchId.value = '';
    searchAssignee.value = '';
    selectedStatus.value = '';
    filterCount.value = 0;
    currentPage.value = 0; // Reset to first page when clearing filters
    update();
    if (useAllOrders!) {
      filterOrders();
    } else {
      filterOrderUnderAuctionOnly();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }
}
