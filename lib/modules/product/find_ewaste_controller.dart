import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/bidding_model.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/services/apis/bidding/bidding_apis.dart';
import 'package:simple_ui/services/apis/inventory/inventory_apis.dart';
import 'package:simple_ui/services/apis/location/location_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';

class FindEwasteController extends GetxController {
  var allProducts = <InventoryModel>[];
  var searchController = TextEditingController();
  InventoryModel? selectedProduct;
  RxBool isLoading = true.obs;
  var orders = <OrderModel>[].obs;
  var participatedOrders = <OrderModel>[].obs;
  RxMap<String, InventoryModel> inventoryMap = <String, InventoryModel>{}.obs;
  RxMap<String, InventoryModel> filteredInventoryProducts =
      <String, InventoryModel>{}.obs;
  RxMap<String, InventoryModel> participatedInventoryMap =
      <String, InventoryModel>{}.obs;
  RxMap<String, InventoryModel> participatedfilteredInventoryProducts =
      <String, InventoryModel>{}.obs;
  setSelectedProduct(selectedProduct) {
    this.selectedProduct = selectedProduct;
    update();
  }

  RxInt filterCount = 0.obs;
  var searchId = ''.obs;
  var productNameSearch = ''.obs;
  String recyclerId = Get.find<MainScreenController>().user!.userId!;
  RxBool isCategoryTab = false.obs;
  clearState() {
    selectedProduct = null;
    searchController.clear();
    filteredInventoryProducts.clear();
    participatedInventoryMap.clear();
    participatedOrders.clear();
    participatedfilteredInventoryProducts.clear();

    orders.clear();
    update();
  }

  void filterOrders() {
    if (searchId.value.isNotEmpty) {
      filterCount.value = 1;
    } else {
      if (productNameSearch.isNotEmpty) {
        filterCount.value = 1;
      } else {
        filterCount.value =
            filterCount.value > 0 ? filterCount.value - 1 : filterCount.value;
      }
    }
    update();
    participatedfilteredInventoryProducts.assignAll(
        Map.fromEntries(participatedInventoryMap.entries.where((entry) {
      final inventoryItem = entry.value;

      return (searchId.isEmpty ||
              inventoryItem.orderId!
                  .toLowerCase()
                  .contains(searchId.value.toLowerCase())) &&
          (productNameSearch.isEmpty ||
              inventoryItem.productName!
                  .toLowerCase()
                  .contains(productNameSearch.value.toLowerCase()));
    })));
    update();
  }

  void clearFilters() {
    searchId.value = '';
    productNameSearch.value = '';
    filterCount.value = 0;
    update();
    filterOrders();
  }

  void fetchProducts(
      {bool? isCategoryTabs = false, bool? isRefreshed = false}) async {
    isCategoryTab.value = isCategoryTabs!;

    if (!isRefreshed!) {
      clearState();
      isLoading.value = true;
    }
    // Simulating API call (replace with real backend call)
    List<String> sellerIds = await getSellerIds();
    try {
      // Create a list of futures for each seller ID
      List<Future<void>> orderFutures =
          sellerIds.map((sellerId) => fetchOrders(userId: sellerId)).toList();

      await Future.wait(orderFutures);
    } catch (e) {
      if (kDebugMode) {
        log('Error occurred when fetching orders for multiple sellers: $e');
      }
    }
    if (isCategoryTab.value) {
      await initializeParticipatedInfo();
    } else {
      await _fetchInventory();
    }
    update();
  }

  Future<void> initializeParticipatedInfo() async {
    try {
      await fetchAllBidding();
      await _fetchParticipatedOrdersInventory();
    } catch (e) {}
  }

  Future<void> fetchAllBidding() async {
    await Future.wait(orders.map((order) => getBiddingDetails(order: order)));
  }

  Future<void> getBiddingDetails({OrderModel? order}) async {
    try {
      Map<String, dynamic> response = await getAllBiddingApi(
        orderId: order?.eid,
      );
      if (response['status']) {
        for (var i = 0; i < response['data'].length; i++) {
          if (BiddingModel.fromJson(response['data'][i]).bidder == recyclerId) {
            participatedOrders.add(order!);
            update();
            log("participatedOrders ${participatedOrders}");
            break;
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _filterProduct() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      filteredInventoryProducts
          .assignAll(inventoryMap); // Reset to full inventory
    } else {
      filteredInventoryProducts.assignAll(
        Map.fromEntries(
          inventoryMap.entries.where((entry) => entry.value.productName!
              .toLowerCase()
              .contains(query.toLowerCase())),
        ),
      );
    }
    update();
  }

  Future<void> fetchOrders({required String userId}) async {
    try {
      Map<String, dynamic>? response =
          await getAllOrdersApi(userId: userId, pageNumber: 0, pageSize: 10000);
      if (response['status']) {
        List<OrderModel> allOrders = [];
        for (var i = 0; i < response['data']['orders'].length; i++) {
          OrderModel order = OrderModel.fromJson(response['data']['orders'][i]);
          if (isCategoryTab.value) {
            allOrders.add(order);
          } else {
            if (order.orderStatus == OrderStatus.biddingInProgress ||
                order.orderStatus == OrderStatus.biddingStarted) {
              allOrders.add(order);
            }
          }
        }
        print("allOrders ${allOrders}");
        if (allOrders.isNotEmpty) {
          orders.assignAll(allOrders);
        }
        print("orders ${orders}");
      } else {}
    } catch (e) {
      if (kDebugMode) {
        log('Error occured in fetch orders: $e');
      }
    }
  }

  Future<void> _fetchInventory() async {
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
      filteredInventoryProducts.assignAll(inventoryMap);
    } catch (e) {
      if (kDebugMode) {
        log('Error occurred in fetch inventory: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchParticipatedOrdersInventory() async {
    try {
      List<Future<Map<String, dynamic>?>> futures =
          participatedOrders.map((order) {
        return getInventoryByIdApi(orderId: order.eid.toString());
      }).toList();

      List<Map<String, dynamic>?> responses = await Future.wait(futures);

      for (var i = 0; i < responses.length; i++) {
        if (responses[i]?['status'] == true) {
          participatedInventoryMap[participatedOrders[i].eid.toString()] =
              InventoryModel.fromJson(responses[i]!['data']);
        }
      }
      participatedfilteredInventoryProducts.assignAll(participatedInventoryMap);
    } catch (e) {
      if (kDebugMode) {
        log('Error occurred in fetch inventory: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> getSellerIds() async {
    try {
      Map<String, dynamic> response = await getUserByUserIdApi2(
          userId: Get.find<MainScreenController>().user?.userId ?? "");
      if (response['status']) {
        List<String> sellerIds = [];
        CreateUserModel userModel = CreateUserModel.fromJson(response['data']);
        // split the userModel.crossuserId by ;
        sellerIds = userModel.crossuserId!.split(';');
        log("sellerIds ${sellerIds}");
        return sellerIds;
      } else {
        log("Error in fetching sellerIds ${response['data']}");
        return [];
      }
    } catch (e) {
      log("Error in fetching sellerIds ${e}");
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_filterProduct);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
