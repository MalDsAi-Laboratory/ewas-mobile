import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_screen.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class OrderController extends GetxController {
  /// boolean to get time to load the data and update the controller values
  bool isLoadingCurrentOrder = true;

  /// manage the selected order
  OrderModel? currentOrder;

  /// manage the current inventory
  InventoryModel? currentInventory;

  /// admin rights to edit order summary
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();
  final TextEditingController orderDetailsController = TextEditingController();
  String? orderStatus;
  DateTime? orderDate;

  bool isUpdatingOrder = false;

  initializeEditOrderData() {
    nameController.text =
        "${currentOrder?.firstName} ${currentOrder?.lastName}";
    addressController.text = currentOrder?.address ?? "";
    emailController.text = currentOrder?.userId ?? "";
    assigneeController.text = currentOrder?.assignee ?? "";
    orderDetailsController.text = currentOrder?.orderDetails ?? "";
    orderStatus = currentOrder?.orderStatus ?? 'Order Placed';
    orderDate = currentOrder?.orderDate ?? DateTime.now();
    isLoadingCurrentOrder = false;
    update();
  }

  updateCurrentOrderSummary(int index, context) async {
    try {
      showRestrictedLoadingDialog(context);
      currentOrder = OrderModel(
        eid: currentOrder?.eid,
        firstName: nameController.text.split(' ')[0],
        lastName: nameController.text.split(' ')[1],
        address: addressController.text,
        assignee: assigneeController.text,
        userId: emailController.text,
        orderStatus: orderStatus,
        orderDate: orderDate,
        orderDetails: orderDetailsController.text,
      );
      Map<String, dynamic> response = await updateOrderApi(data: currentOrder);
      if (response['status']) {
        update();
        Get.find<AllOrderController>().orders[index] = currentOrder!;
        Get.find<AllOrderController>().filteredOrders[index] = currentOrder!;
        Get.find<AllOrderController>().update();
        Get.back();
      } else {
        AppSnackBars.showErrorSnackBar("Error", response['data']);
        Get.back();
      }
    } catch (e) {
      AppSnackBars.showErrorSnackBar("Error", "Something went wrong");
      Get.back();
    } finally {
      isUpdatingOrder = false;
      update();
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
