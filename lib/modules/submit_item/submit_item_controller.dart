import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/services/apis/order/order_apis.dart';
import 'dart:io';

class SubmitItemController extends GetxController {
  var volumeController = TextEditingController();
  bool isBtnActive = false;
  final ImagePicker _picker = ImagePicker();
  var images = <File>[];

  Future<void> submitProduct() async {
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
      print("orderId $orderId");
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

      Get.snackbar("Success",
          "Product added to cart successfully!\nYou can place your product for auction from cart.");
    } catch (e) {
      log("error in submitProduct $e");
      Get.snackbar("Error", "Failed to add product to cart: $e");
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
