import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import "package:dio/dio.dart" as dio;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/cart/components/cart_order_view.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_ui/services/apis/inventory/inventory_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class CartController extends GetxController {
  RxBool isCartProductsLoading = true.obs;
  RxBool isInventoryCreating = false.obs;
  var orders = <OrderModel>[].obs;
  RxMap<String, SubsidiaryInventoryModel> inventoryMap =
      <String, SubsidiaryInventoryModel>{}.obs;
  // Add this function to your controller
  void pollOrderStatusAndUpdateCart() {
         isCartProductsLoading.value = true;

    // Create a timer that checks every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      AllOrderController allOrderController = Get.find<AllOrderController>();

      // Check if the order is no longer being placed
      if (!allOrderController.isOrdersLoading.value) {
        // Cancel the timer once the condition is met
        timer.cancel();

        // Call the getCartProducts function
        getCartProducts();

        log("Order creation completed, cart products updated");
      } else {
        log("Order still being placed, checking again in 2 seconds...");
      }
    });
  }

  void getCartProducts() async {
    try {
      AllOrderController allOrderController = Get.find<AllOrderController>();
      if (allOrderController.isOrdersLoading.value) {
      } else {
        List<OrderModel> orderPlacedOrders = [];
        for (var order in allOrderController.orders) {
          if (order.orderStatus == OrderStatus.orderPlaced) {
            orderPlacedOrders.add(order);
          }
        }
        if (orderPlacedOrders.isEmpty) {
          inventoryMap.clear();
        } else {
          orders.assignAll(orderPlacedOrders);
          await Future.wait(
              orderPlacedOrders.map((order) async => getOrderData(order.eid!)));
          await Future.wait(orderPlacedOrders
              .map((order) async => getOrderImages(order.eid!)));
        }
      }
    } catch (e) {
      log("error in getCartProducts $e");
    } finally {
      isCartProductsLoading.value = false;
    }
  }

  Future<void> getOrderData(String orderId) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final metadataFile = File('${appDocDir.path}/$orderId/metadata.json');

      if (await metadataFile.exists()) {
        final jsonString = await metadataFile.readAsString();
        inventoryMap[orderId] =
            SubsidiaryInventoryModel.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      log("Error retrieving order data: $e");
    }
  }

  // Helper method to get all saved images for an order
  Future<void> getOrderImages(String orderId) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final orderDir = Directory('${appDocDir.path}/$orderId');

      if (await orderDir.exists()) {
        final List<FileSystemEntity> entities = await orderDir.list().toList();
        List<File> temp = entities
            .where((entity) => entity is File && _isImageFile(entity.path))
            .map((entity) => File(entity.path))
            .toList();
        for (int i = 0; i < temp.length; i++) {
          if (i == 0) {
            inventoryMap[orderId]!.imgPath1 = temp[i];
          }
          if (i == 1) {
            inventoryMap[orderId]!.imgPath2 = temp[i];
          }
          if (i == 2) {
            inventoryMap[orderId]!.imgPath3 = temp[i];
          }
          if (i == 3) {
            inventoryMap[orderId]!.imgPath4 = temp[i];
          }
          if (i == 4) {
            inventoryMap[orderId]!.imgPath5 = temp[i];
          }
        }
      }
    } catch (e) {
      log("Error retrieving order images: $e");
    }
  }

// Helper method to check if a file is an image based on common extensions
  static bool _isImageFile(String path) {
    final lowerPath = path.toLowerCase();
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.heic',
      '.heif'
    ];
    return imageExtensions.any((ext) => lowerPath.endsWith(ext));
  }

  Future<void> submitItem(String orderId, int orderIndex, context) async {
    try {
      showCartRestrictedLoadingDialog(context);
      bool response = await createInventory(orderId);
      if (!response) {
        isInventoryCreating.value = true;

        Get.back();
        print("createInventory failed");

        AppSnackBars.showErrorSnackBar("Error", "Failed to create inventory");
      } else {
        await Future.wait([
          updateOrderStatus(orderId: orderId, order: orders[orderIndex]),
          productImageUpload(orderId),
        ]);
        Get.back();
        Get.back();
        AppSnackBars.showSuccessSnackBar("Success",
            "Product listed for auction!\nYou can view your product for auction from orders screen.");
        AllOrderController controller = Get.find<AllOrderController>();
        try {
          controller.isInventoryLoading.value = true;
          Map<String, dynamic> response =
              await getInventoryByIdApi(orderId: orderId);
          if (response['status']) {
            controller.inventoryMap[orderId] =
                InventoryModel.fromJson(response['data']);
          }
          // update orders[orderIndex] status to bidding started
          orders[orderIndex] = OrderModel(
            eid: orders[orderIndex].eid,
            orderStatus: OrderStatus.biddingStarted,
            address: orders[orderIndex].address,
            assignee: orders[orderIndex].assignee,
            firstName: orders[orderIndex].firstName,
            lastName: orders[orderIndex].lastName,
            orderDate: orders[orderIndex].orderDate,
            orderDetails: orders[orderIndex].orderDetails,
            productImagePath: orders[orderIndex].productImagePath,
            userId: orders[orderIndex].userId,
          );
          update();
        } catch (e) {
          Get.back();
          log("error in getInventoryByIdApi $e");
        } finally {
          controller.isInventoryLoading.value = false;
        }
        await deleteOrderData(orderId);
      }
    } catch (e) {
      Get.back();
      log("Error in submitItem $e");
    } finally {
      isInventoryCreating.value = false;
    }
  }

  Future<void> productImageUpload(String orderId) async {
    try {
      // Filter non-null images
      List<File> validImages = [];
      if (inventoryMap[orderId]!.imgPath1 != null) {
        validImages.add(inventoryMap[orderId]!.imgPath1!);
      }
      if (inventoryMap[orderId]!.imgPath2 != null) {
        validImages.add(inventoryMap[orderId]!.imgPath2!);
      }
      if (inventoryMap[orderId]!.imgPath3 != null) {
        validImages.add(inventoryMap[orderId]!.imgPath3!);
      }
      if (inventoryMap[orderId]!.imgPath4 != null) {
        validImages.add(inventoryMap[orderId]!.imgPath4!);
      }
      if (inventoryMap[orderId]!.imgPath5 != null) {
        validImages.add(inventoryMap[orderId]!.imgPath5!);
      }
      // Create a list of upload tasks
      List<Future<Map<String, dynamic>>> uploadTasks = [];

      for (int i = 0; i < validImages.length; i++) {
        File imageFile = validImages[i];

        uploadTasks.add(uploadInventoryImageApi(
          imageForm: dio.FormData.fromMap({
            "file": await dio.MultipartFile.fromFile(imageFile.path,
                filename: imageFile.path.split('/').last),
          }),
          index: i + 1, // Assuming index starts from 1
          orderId: orderId,
        ));
      }

      // Run all uploads in parallel
      List<Map<String, dynamic>> responses = await Future.wait(uploadTasks);

      // Log all responses
      for (var response in responses) {
        log("Image upload response: $response");
      }
    } catch (e) {
      log("Error in productImageUpload: $e");
    }
  }

  Future<String?> updateOrderStatus(
      {required String orderId, required OrderModel order}) async {
    try {
      DateTime now = DateTime.now();
      OrderModel orderModel = OrderModel(
        eid: orderId,
        firstName: order.firstName,
        lastName: order.lastName,
        address: order.address,
        assignee: order.assignee,
        userId: order.userId,
        orderStatus: OrderStatus.biddingStarted,
        orderDate: now,
        orderDetails:
            "${now.toIso8601String()} || Minimum base price ${inventoryMap[orderId]!.mbp.toString()}",
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

        return response['data']['eid'];
      }
    } catch (e) {
      log("error in createOrder $e");
    }
    return null;
  }

  Future<bool> createInventory(String orderId) async {
    try {
      InventoryModel inventoryModel = InventoryModel(
        orderId: orderId,
        category: inventoryMap[orderId]!.category,
        materialType: inventoryMap[orderId]!.materialType,
        productName: inventoryMap[orderId]!.productName,
        units: inventoryMap[orderId]!.units,
        volume: inventoryMap[orderId]!.volume,
        dateAndTime: DateTime.now().toIso8601String(),
        mbp: inventoryMap[orderId]!.mbp,
        productId: inventoryMap[orderId]!.productId,
      );
      Map<String, dynamic> response =
          await createInventoryApi(data: inventoryModel);
      if (response['status']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("error in createInventory $e");
      return false;
    }
  }
  // Add this function to the SubmitItemController class

  Future<bool> deleteOrderData(String orderId) async {
    try {
      // Get the application documents directory
      final appDocDir = await getApplicationDocumentsDirectory();

      // Get the order directory
      final orderDir = Directory('${appDocDir.path}/$orderId');

      // Delete the directory if it exists
      if (await orderDir.exists()) {
        await orderDir.delete(recursive: true);
        log("Order directory deleted: $orderId");
      }

      // Remove order reference from shared preferences
      final prefs = await SharedPreferences.getInstance();
      List<String> savedOrders = prefs.getStringList('saved_orders') ?? [];
      if (savedOrders.contains(orderId)) {
        savedOrders.remove(orderId);
        await prefs.setStringList('saved_orders', savedOrders);
        log("Order removed from saved_orders list: $orderId");
      }

      return true;
    } catch (e) {
      log("Error deleting order data: $e");
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<AllOrderController>()) {
      getCartProducts();
    }
  }
}
