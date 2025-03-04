import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/services/apis/inventory/inventory_apis.dart';
import 'package:simple_ui/services/apis/location/location_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';

class FindEwasteController extends GetxController {
  var allProducts = <InventoryModel>[];
  var searchController = TextEditingController();
  InventoryModel? selectedProduct;
  RxBool isLoading = true.obs;
  var orders = <OrderModel>[].obs;
  RxMap<String, InventoryModel> inventoryMap = <String, InventoryModel>{}.obs;
  RxMap<String, InventoryModel> filteredInventoryProducts =
      <String, InventoryModel>{}.obs;

  setSelectedProduct(selectedProduct) {
    this.selectedProduct = selectedProduct;
    update();
  }

  clearState() {
    selectedProduct = null;
    searchController.clear();
    filteredInventoryProducts.assignAll(inventoryMap);
    update();
  }

  void fetchProducts() async {
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
    await _fetchInventory();
    update();
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
    if (orders.isEmpty) {
      try {
        Map<String, dynamic>? response = await getAllOrdersApi(
            userId: userId, pageNumber: 0, pageSize: 10000);
        if (response['status']) {
          List<OrderModel> allOrders = [];
          for (var i = 0; i < response['data']['orders'].length; i++) {
            OrderModel order =
                OrderModel.fromJson(response['data']['orders'][i]);
            if (order.orderStatus == OrderStatus.biddingInProgress ||
                order.orderStatus == OrderStatus.biddingStarted) {
              allOrders.add(order);
            }
          }
          if (allOrders.isNotEmpty) {
            orders.addAll(allOrders);
          }
        } else {}
      } catch (e) {
        if (kDebugMode) {
          log('Error occured in fetch orders: $e');
        }
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
    fetchProducts();
    searchController.addListener(_filterProduct);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
