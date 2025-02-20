import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/modules/product/product_bidding_screen.dart';
import 'package:simple_ui/services/apis/inventory/inventory_apis.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';
import 'dart:io';
import "package:dio/dio.dart" as dio;
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class SubmitItemController extends GetxController {
  var volumeController = TextEditingController();
  bool isBtnActive = false;
  final ImagePicker _picker = ImagePicker();
  var images = <File>[];

  Future<void> submitProduct(context) async {
    if (volumeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter volume details");
      return;
    }
    if (images.isEmpty) {
      Get.snackbar("Error", "Please select at least one image.");
      return;
    }
    try {
      // Create order
      String? orderId = await createOrder();
      if (orderId == null) {
        AppSnackBars.showErrorSnackBar("Error", "Failed to create order");
      } else {
        bool response = await createInventory(orderId);
        if (!response) {
          AppSnackBars.showErrorSnackBar("Error", "Failed to create inventory");
        } else {
          await productImageUpload(orderId);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          AppSnackBars.showSuccessSnackBar("Success",
              "Product listed for auction!\nYou can view your product for auction from orders screen.");
        }
      }
      // Save Images
      // Create Inventory
      // final CachedCartList cachedCartList = CachedCartList();
      // List<ProductModel> cardProducts = await cachedCartList.getProducts();
      // log("cardProducts ${cardProducts}");
      // await cachedCartList.addProduct(
      //     product: ProductModel(
      //   productId: cardProducts.length + 1,
      //   imagePath:
      //       base64Encode(utf8.encode(images[0].readAsBytesSync().toString())),
      //   imagePath2: images.length > 1
      //       ? base64Encode(utf8.encode(images[1].readAsBytesSync().toString()))
      //       : null,
      //   imagePath3: images.length > 2
      //       ? base64Encode(utf8.encode(images[2].readAsBytesSync().toString()))
      //       : null,
      //   imagePath4: images.length > 3
      //       ? base64Encode(utf8.encode(images[3].readAsBytesSync().toString()))
      //       : null,
      //   imagePath5: images.length > 4
      //       ? base64Encode(utf8.encode(images[4].readAsBytesSync().toString()))
      //       : null,
      //   category:
      //       Get.find<CategoriesController>().selectedCategory!.category ?? "",
      //   materialDetails: volumeController.text,
      //   productName:
      //       Get.find<CategoriesController>().selectedSubCategory!.productName ??
      //           "",
      // ));
    } catch (e) {
      log("error in submitProduct $e");
      Get.snackbar("Error", "Failed to add product to cart: $e");
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

  Future<bool> createInventory(String orderId) async {
    try {
      InventoryModel inventoryModel = InventoryModel(
          orderId: orderId,
          category: Get.find<CategoriesController>().selectedCategory!.category,
          materialType:
              Get.find<CategoriesController>().selectedSubCategory!.category,
          productName:
              Get.find<CategoriesController>().selectedSubCategory!.productName,
          volume: volumeController.text,
          dateAndTime: DateTime.now().toUtc().toIso8601String(),
          productId: "123",
          imgPath1: "string",
          imgPath2: "string",
          imgPath3: "string",
          imgPath4: "string",
          imgPath5: "string");
      log('inventoryModel ${inventoryModel.toJson()}');
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

  Future<String?> createOrder() async {
    try {
      OrderModel orderModel = OrderModel(
        eid: "1",
        firstName: "John",
        lastName: "Doe",
        address: "123 Main St, Anytown, USA",
        assignee: null,
        emailId: "W0K5W@example.com",
        orderStatus: OrderStatus.orderPlaced,
        orderDate: DateTime.now(),
        orderDetails: "Order details",
      );
      Map<String, dynamic> response = await createOrderApi(data: orderModel);
      if (response['status']) {
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
