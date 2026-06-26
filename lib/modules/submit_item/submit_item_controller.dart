import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/locate_recyclers/locate_recyclers_controller.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/modules/submit_item/submit_item.dart';
import 'package:simple_ui/services/apis/inventory/inventory_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';
import 'dart:io';
import "package:dio/dio.dart" as dio;
import 'package:simple_ui/ui_utils/app_snackbars.dart';
import 'package:path_provider/path_provider.dart';

class SubmitItemController extends GetxController {
  var volumeController = TextEditingController();
  var basePriceController = TextEditingController();
  var descriptionController = TextEditingController();
  bool isBtnActive = false;
  final ImagePicker _picker = ImagePicker();
  var images = <File>[];
  bool isOrderCreated = true;

  Future<void> submitProduct(
      context, willGoUnderAuction, willGoUnderCart) async {
    if (volumeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter volume details");
      return;
    }
    if (willGoUnderAuction && basePriceController.text.isEmpty) {
      Get.snackbar("Error", "Please enter minimum base price");
      return;
    }
    if (images.isEmpty) {
      Get.snackbar("Error", "Please select at least one image.");
      return;
    }
    try {
      isOrderCreated = false;
      update();
      showOrderRestrictedLoadingDialog(context);
      // Create order
      String? orderId =
          await createOrder(willGoUnderAuction: willGoUnderAuction);
      if (orderId == null) {
        isOrderCreated = true;
        update();
        Get.back();
        print("createOrder failed");

        AppSnackBars.showErrorSnackBar("Error", "Failed to create order");
      } else {
        if (willGoUnderAuction) {
          if (willGoUnderCart) {
            // Save order data to local storage
            bool response = await saveOrderDataToLocalStorage(orderId);
            if (response) {
              Get.back();
              Get.back();
              Get.back();
              Get.back();
              AppSnackBars.showSuccessSnackBar(
                  "Success", "Product saved to cart.");
            } else {
              Get.back();
            }
          } else {
            bool response = await createInventory(orderId, willGoUnderAuction);
            if (!response) {
              isOrderCreated = true;
              update();
              Get.back();
              print("createInventory failed");

              AppSnackBars.showErrorSnackBar(
                  "Error", "Failed to create inventory");
            } else {
              await Future.wait([
                updateOrderStatus(orderId: orderId),
                productImageUpload(orderId),
              ]);
              Get.back();
              Get.back();
              Get.back();
              Get.back();
              AppSnackBars.showSuccessSnackBar("Success",
                  "Product listed for auction!\nYou can view your product for auction from orders screen.");
              AllOrderController controller = Get.find<AllOrderController>();
              try {
                controller.isInventoryLoading.value = false;
                Map<String, dynamic> response =
                    await getInventoryByIdApi(orderId: orderId);
                if (response['status']) {
                  controller.inventoryMap[orderId] =
                      InventoryModel.fromJson(response['data']);
                }
              } catch (e) {
                log("error in getInventoryByIdApi $e");
              } finally {
                controller.isInventoryLoading.value = false;
              }
            }
          }
        } else {
          bool response = await createInventory(orderId, willGoUnderAuction);
          if (!response) {
            isOrderCreated = true;
            update();
            Get.back();
            print("createInventory failed");

            AppSnackBars.showErrorSnackBar(
                "Error", "Failed to create inventory");
          } else {
            await productImageUpload(orderId);
            Get.back();
            Get.back();
            Get.back();
            Get.back();
            AppSnackBars.showSuccessSnackBar(
                "Success", "You can view your product from orders screen.");
            AllOrderController controller = Get.find<AllOrderController>();
            try {
              controller.isInventoryLoading.value = false;
              Map<String, dynamic> response =
                  await getInventoryByIdApi(orderId: orderId);
              if (response['status']) {
                controller.inventoryMap[orderId] =
                    InventoryModel.fromJson(response['data']);
              }
            } catch (e) {
              log("error in getInventoryByIdApi $e");
            } finally {
              controller.isInventoryLoading.value = false;
            }
          }
        }
      }
    } catch (e) {
      log("error in submitProduct $e");
      Get.snackbar("Error", "Failed to add product to cart: $e");
    } finally {
      print("finally");

      isOrderCreated = true;
      update();
    }
  }

  Future<bool> saveOrderDataToLocalStorage(String orderId) async {
    try {
      // Get the application documents directory
      final appDocDir = await getApplicationDocumentsDirectory();

      // Create a directory for this order
      final orderDir = Directory('${appDocDir.path}/$orderId');
      if (!await orderDir.exists()) {
        await orderDir.create(recursive: true);
      }

      // Get categories controller to access the category details
      CategoriesController categoriesController =
          Get.find<CategoriesController>();

      // Save order metadata with additional fields
      final metadataFile = File('${orderDir.path}/metadata.json');
      final metadata = {
        'productId': categoriesController.selectedSubCategory?.productId,
        'volume': volumeController.text,
        'minimum_base_price': basePriceController.text,
        'timestamp': DateTime.now().toIso8601String(),
        // Add the new fields
        'category': categoriesController.selectedCategory?.category,
        'materialType':
            categoriesController.selectedSubCategory?.materialDetails,
        'productName': categoriesController.selectedSubCategory?.productName,
        'units': categoriesController.selectedSubCategory
            ?.units, // Try to extract units from volume text if present
        'description': descriptionController.text.trim(),
      };
      await metadataFile.writeAsString(jsonEncode(metadata));

      // Save images
      for (int i = 0; i < images.length; i++) {
        final imageFile = images[i];
        final fileName = 'image_$i.jpg';
        final savedImagePath = '${orderDir.path}/$fileName';

        // Copy the image to the order directory
        await imageFile.copy(savedImagePath);
      }

      // Save order reference to shared preferences for easy access
      final prefs = await SharedPreferences.getInstance();
      List<String> savedOrders = prefs.getStringList('saved_orders') ?? [];
      if (!savedOrders.contains(orderId)) {
        savedOrders.add(orderId);
        await prefs.setStringList('saved_orders', savedOrders);
      }

      log("Order data saved to local storage: $orderId");
      return true;
    } catch (e) {
      log("Error saving order data to local storage: $e");
      return false;
    }
  }

  Future<void> productImageUpload(String orderId) async {
    try {
      // Filter non-null images
      List<File> validImages =
          images.where((image) => image.path.isNotEmpty).toList();

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

  Future<bool> createInventory(String orderId, willGoUnderAuction) async {
    try {
      InventoryModel inventoryModel = InventoryModel(
        orderId: orderId,
        category: Get.find<CategoriesController>().selectedCategory!.category,
        materialType: Get.find<CategoriesController>()
            .selectedSubCategory!
            .materialDetails,
        productName:
            Get.find<CategoriesController>().selectedSubCategory!.productName,
        volume: volumeController.text,
        dateAndTime: DateTime.now().toIso8601String(),
        mbp: willGoUnderAuction
            ? double.parse(basePriceController.text.trim())
            : null,
        productId: Get.find<CategoriesController>()
            .selectedSubCategory!
            .productId
            .toString(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
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

  Future<String?> createOrder({required bool willGoUnderAuction}) async {
    DateTime now = DateTime.now();
    try {
      MainScreenController mainScreenController =
          Get.find<MainScreenController>();
      OrderModel orderModel = OrderModel(
        firstName: mainScreenController.user!.firstName,
        lastName: mainScreenController.user!.lastName,
        address: mainScreenController.user!.address,
        assignee: null,
        userId: mainScreenController.user!.userId,
        orderStatus: willGoUnderAuction
            ? OrderStatus.orderPlaced
            : OrderStatus.awaitingForPick,
        orderDate: now,
        orderDetails:
            "${now.toIso8601String()} || ${willGoUnderAuction ? "Minimum base price ₹ ${basePriceController.text.trim()}" : "${Get.find<LocateRecyclersController>().selectedRecycler.value.userId ?? ""} is chosen with price ₹ ${Get.find<LocateRecyclersController>().selectedRecycler.value.price} \n${now.toIso8601String()} || Final price is ₹ ${Get.find<LocateRecyclersController>().selectedRecycler.value.price! * double.parse(volumeController.text.trim())}"}",
      );
      Map<String, dynamic> response = await createOrderApi(data: orderModel);
      if (response['status']) {
        AllOrderController allOrderController = Get.find<AllOrderController>();
        allOrderController.orders.add(OrderModel.fromJson(response['data']));
        allOrderController.filteredOrders.assignAll(allOrderController.orders);
        return response['data']['eid'];
      }
    } catch (e) {
      log("error in createOrder $e");
    }
    return null;
  }

  Future<String?> updateOrderStatus({required String orderId}) async {
    try {
      MainScreenController mainScreenController =
          Get.find<MainScreenController>();
      DateTime now = DateTime.now();
      OrderModel orderModel = OrderModel(
        eid: orderId,
        firstName: mainScreenController.user!.firstName,
        lastName: mainScreenController.user!.lastName,
        address: mainScreenController.user!.address,
        assignee: null,
        userId: mainScreenController.user!.userId,
        orderStatus: OrderStatus.biddingStarted,
        orderDate: now,
        orderDetails:
            "${now.toIso8601String()} || Minimum base price ${basePriceController.text.trim()}",
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

  Future<void> pickImage(ImageSource source) async {
    if (images.length >= 5) {
      Get.snackbar("Limit Reached", "You can only add up to 5 images.");
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      images.add(File(pickedFile.path));
      update();
    }
  }

  Future<void> pickMultipleImages() async {
    if (images.length >= 5) {
      Get.snackbar("Limit Reached", "You can only add up to 5 images.");
      return;
    }

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      if (images.length + pickedFiles.length > 5) {
        Get.snackbar("Limit Exceeded", "You can only select up to 5 images.");
      }
      int availableSlots = 5 - images.length;
      images.addAll(
          pickedFiles.take(availableSlots).map((file) => File(file.path)));
    }
    update();
  }

  void removeImage(int index) {
    images.removeAt(index);
    update();
  }
}
