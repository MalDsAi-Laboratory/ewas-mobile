import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/services/apis/inventory/inventory_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';

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
  RxBool isInventoryLoading = true.obs;
  RxMap<String, InventoryModel> inventoryMap = <String, InventoryModel>{}.obs;

  void fetchOrders() async {
    if (orders.isEmpty) {
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
    filteredOrders.assignAll(orders);
    filterOrderUnderAuctionOnly();
    _fetchInventory();
  }

  void filterOrderUnderAuctionOnly() {
    filteredOrdersUnderAuction.assignAll(orders.where((order) =>
        (order.orderStatus == OrderStatus.biddingStarted ||
            order.orderStatus == OrderStatus.biddingInProgress ||
            order.orderStatus == OrderStatus.biddingCompleted)));
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

  void clearFilters({bool? useAllOrders = true}) {
    searchId.value = '';
    searchAssignee.value = '';
    selectedStatus.value = '';
    filterCount.value = 0;
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
