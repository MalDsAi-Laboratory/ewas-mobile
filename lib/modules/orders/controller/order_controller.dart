import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';

class OrderController extends GetxController {
  /// boolean to get time to load the data and update the controller values
  bool isLoadingCurrentOrder = true;

  /// manage the selected order
  OrderModel? currentOrder;

  /// admin rights to edit order summary
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();
  final TextEditingController orderDetailsController = TextEditingController();
  String? orderStatus;
  DateTime? orderDate;

  initializeEditOrderData() {
    nameController.text =
        "${currentOrder?.firstName} ${currentOrder?.lastName}";
    addressController.text = currentOrder?.address ?? "";
    emailController.text = currentOrder?.emailId ?? "";
    assigneeController.text = currentOrder?.assignee ?? "";
    orderDetailsController.text = currentOrder?.orderDetails ?? "";
    orderStatus = currentOrder?.orderStatus ?? 'Order Placed';
    orderDate = currentOrder?.orderDate ?? DateTime.now();
    isLoadingCurrentOrder = false;
    update();
  }

  updateCurrentOrderSummary(int index) {
    if (true) {
      currentOrder = OrderModel(
        eid: currentOrder?.eid,
        firstName: nameController.text.split(' ')[0],
        lastName: nameController.text.split(' ')[1],
        address: addressController.text,
        assignee: assigneeController.text,
        emailId: emailController.text,
        orderStatus: orderStatus,
        orderDate: orderDate,
        orderDetails: orderDetailsController.text,
      );
      update();
      Get.find<AllOrderController>().orders[index] = currentOrder!;
      Get.find<AllOrderController>().filteredOrders[index] = currentOrder!;
      Get.find<AllOrderController>().update();
    }
  }

  resetCurrentOrderSummary() {
    currentOrder = null;
    nameController.clear();
    addressController.clear();
    emailController.clear();
    assigneeController.clear();
    orderDetailsController.clear();
    orderStatus = 'Order Placed';
    orderDate = DateTime.now();
    isLoadingCurrentOrder = true;
    update();
  }
}
