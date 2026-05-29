import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/bidding_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/modules/product/find_ewaste_controller.dart';
import 'package:simple_ui/modules/product/product_bidding_screen.dart';
import 'package:simple_ui/services/apis/bidding/bidding_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class ProductController extends GetxController {
  List<BiddingModel> biddingList = [];
  RxBool isLoading = true.obs;

  Duration remainingDatetime = Duration();
  Rx<double> myPrice = 0.0.obs;
  Rx<double> highestPrice = 0.0.obs;
  TextEditingController biddingAmountController = TextEditingController();
  RxBool isBiddingPlacing = false.obs;
  bool isBiddingRejecting = false;
  // Replace your existing setRemainingDuration function with this improved version
  Future<void> setRemainingDuration(DateTime? inputDateTime) async {
    DateTime targetTime = inputDateTime!
        .add(DateTime.now().timeZoneOffset)
        .add(const Duration(hours: 4));
    if (targetTime.isBefore(DateTime.now())) {
      remainingDatetime = Duration.zero;
      update();
    } else {
      remainingDatetime = targetTime.difference(DateTime.now());
      update();
    }
  }

// Modify your getBiddingDetails function to ensure proper sequencing
  void getBiddingDetails(
      {OrderStatus? orderStatus, String? orderId, DateTime? dateTime}) async {
    isLoading.value = true;
    try {
      // Then set the remaining duration and wait for it to complete
      if (orderStatus == OrderStatus.biddingStarted ||
          orderStatus == OrderStatus.biddingInProgress) {
        await setRemainingDuration(dateTime);
      } else {
        remainingDatetime = Duration.zero;
        update();
      }
      Map<String, dynamic> response = await getAllBiddingApi(orderId: orderId);
      if (response['status']) {
        List<BiddingModel> temp = [];
        for (var i = 0; i < response['data'].length; i++) {
          temp.add(BiddingModel.fromJson(response['data'][i]));
        }
        biddingList.assignAll(temp);

        // First update my price
        checkAndUpdateMyPrice();

        // Then get highest bid price
        getHighestBidPrice();

        // Log to verify values after all updates
        log("Remaining time after updates: ${remainingDatetime.inSeconds} seconds");
        log("Highest price after updates: ${highestPrice.value}");
      }
    } catch (e) {
      log("Error in getBiddingDetails: $e", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  void checkAndUpdateMyPrice() {
    String currentUserId = Get.find<MainScreenController>().user?.userId ?? '';

    // Find the current user's bid in the bidding list
    BiddingModel? myBid = biddingList.firstWhereOrNull(
      (bid) => bid.bidder == currentUserId,
    );

    // If the user is found in the bidding list, update myPrice
    if (myBid != null) {
      myPrice.value = myBid.priceTag ?? 0.0;
    } else {
      // If the user is not found, reset myPrice to 0.0
      myPrice.value = 0.0;
    }
  }

  // Method to get the highest bid price
  void getHighestBidPrice() {
    if (biddingList.isEmpty) return null;
    highestPrice.value =
        biddingList.map((b) => b.priceTag ?? 0).reduce((a, b) => a > b ? a : b);
  }

  // handle place bid
  void handlePlaceBid(
      {required String orderId,
      required String productName,
      required double volume,
      required double mbp,
      OrderModel? order,
      required BuildContext context}) async {
    try {
      String amount = biddingAmountController.text.trim();
      if (amount.isEmpty || amount == "0") {
        AppSnackBars.showNormalSnackBar("Oops", "Please enter bid amount");
        return;
      }
      if (double.parse(amount) <= highestPrice.value) {
        AppSnackBars.showNormalSnackBar(
            "Oops", "Your bid should be higher than the current highest bid");
        return;
      }
      isBiddingPlacing.value = true;
      showRestrictedLoadingDialog(context);
      BiddingModel model = BiddingModel(
          bidder: Get.find<MainScreenController>().user?.userId,
          priceTag: double.parse(biddingAmountController.text),
          fullName:
              "${Get.find<MainScreenController>().user?.firstName} ${Get.find<MainScreenController>().user?.lastName}",
          orderId: orderId,
          productCatalog: productName,
          volume: volume);
      // check if userId is already in bidding list
      bool isUserAlreadyInBiddingList =
          biddingList.any((bid) => bid.bidder == model.bidder);
      log("isUserAlreadyInBiddingList $isUserAlreadyInBiddingList");
      Map<String, dynamic> response;
      if (isUserAlreadyInBiddingList) {
        response = await updateBiddingApi(data: model);
      } else {
        response = await createBiddingApi(data: model);
        if (response['status']) {
          if (order!.orderStatus == OrderStatus.biddingStarted)
            await updateOrderStatus(
                orderId: orderId, orderStatus: OrderStatus.biddingInProgress);
        }
      }

      if (response['status']) {
        if (myPrice == 0.0) {
          biddingList.insert(0, model);
        } else {
          // update the current user entry in bidding list and then sort the list based on price
          biddingList.removeWhere((bid) =>
              bid.bidder == Get.find<MainScreenController>().user?.userId);
          biddingList.insert(0, model);
          biddingList
              .sort((a, b) => (b.priceTag ?? 0).compareTo(a.priceTag ?? 0));
        }
        myPrice.value = double.parse(amount);
        if (myPrice.value > highestPrice.value) {
          highestPrice.value = myPrice.value;
        }
        biddingAmountController.clear();

        Get.back();
        AppSnackBars.showSuccessSnackBar("Success", "Bid placed successfully");
      } else {
        Get.back();

        AppSnackBars.showNormalSnackBar("Oops", "Failed to place bid");
      }
    } catch (e) {
      Get.back();

      log("Error in processing place bid $e");
      AppSnackBars.showNormalSnackBar("Oops", "Failed to place bid");
    } finally {
      isBiddingPlacing.value = false;
    }
  }

  Future<void> updateOrderStatus(
      {required String orderId, required OrderStatus orderStatus}) async {
    try {
      OrderModel order = OrderModel();
      if (orderStatus == OrderStatus.biddingInProgress) {
        order = Get.find<FindEwasteController>()
            .orders
            .firstWhere((element) => element.eid == orderId);
      } else {
        order = Get.find<AllOrderController>()
            .filteredOrdersUnderAuction
            .firstWhere((element) => element.eid == orderId);
      }
      OrderModel orderModel = OrderModel(
        eid: orderId,
        firstName: order.firstName,
        lastName: order.lastName,
        address: order.address,
        assignee: order.assignee,
        userId: order.userId,
        orderStatus: orderStatus,
        orderDate: order.orderDate,
        orderDetails: order.orderDetails,
      );
      Map<String, dynamic> response = await updateOrderApi(data: orderModel);
      if (response['status']) {
        AllOrderController allOrderController = Get.find<AllOrderController>();
        int index = allOrderController.orders
            .indexWhere((element) => element.eid == orderId);
        allOrderController.orders[index] =
            OrderModel.fromJson(response['data']);
        allOrderController.filteredOrders.assignAll(allOrderController.orders);
        allOrderController.filterOrderUnderAuctionOnly();
        if (orderStatus == OrderStatus.biddingInProgress) {
          index = Get.find<FindEwasteController>()
              .orders
              .indexWhere((element) => element.eid == orderId);
          Get.find<FindEwasteController>().orders[index] =
              OrderModel.fromJson(response['data']);
        }
      }
    } catch (e) {
      log("error in createOrder $e");
    } finally {
      isBiddingRejecting = false;
      update();
    }
  }
}
