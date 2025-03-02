import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/product_details_model.dart';
import 'package:simple_ui/models/sub_category_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/services/apis/product_details/product_details_api.dart';

class UpdatePriceController extends GetxController {
  /// {"Battery": [{"subCategory":SubCategoryModel, "price":123}]}
  RxMap<String, List<Map<String, dynamic>>> allSubCategories =
      <String, List<Map<String, dynamic>>>{}.obs;

  RxBool isProductsPricingLoading = true.obs;

  /// Stores a list of TextEditingControllers for each subcategory
  RxMap<String, List<TextEditingController>> textControllers =
      <String, List<TextEditingController>>{}.obs;

  /// Stores a list of TextEditingControllers for each subcategory
  /// {"Battery":[{"productId":TextEditingController}]}
  RxMap<String, List<Map<String, TextEditingController>>>
      actualTextControllers =
      <String, List<Map<String, TextEditingController>>>{}.obs;
  RxList<ProductDetailsModel> fetchedProductDetails =
      <ProductDetailsModel>[].obs;

  RxBool isUpdatingPrices = false.obs;

  /// Initialize controllers for each subcategory
  void initializeControllers() {
    textControllers.clear(); // Clear existing controllers before reinitializing

    for (var entry in allSubCategories.entries) {
      List<TextEditingController> controllers = [];

      for (var subcategory in entry.value) {
        controllers.add(TextEditingController(
          text: subcategory["price"]?.toString() ?? '',
        ));
      }

      textControllers[entry.key] = controllers;
    }
  }

  // getProductsPricing
  Future<void> getProductsPricing() async {
    try {
      Map<String, dynamic> response = await getAllProductPricingApi(
          userId: Get.find<MainScreenController>().user?.userId ?? "");
      if (response['status']) {
        List<ProductDetailsModel> temp = [];
        for (var i = 0; i < response['data'].length; i++) {
          temp.add(ProductDetailsModel.fromJson(response['data'][i]));
        }
        fetchedProductDetails.value = temp;
        await initializeAllSubCategories(productDetails: temp);
      }
    } catch (e) {}
  }

  Future<void> initializeAllSubCategories(
      {required List<ProductDetailsModel> productDetails}) async {
    RxMap<String, List<SubCategoryModel>> temp =
        Get.find<CategoriesController>().allSubCategories;
    for (var i = 0; i < temp.length; i++) {
      allSubCategories[temp.keys.toList()[i]] = temp.values
          .toList()[i]
          .map((e) => {"subCategory": e, "price": 0})
          .toList();
    }

    if (productDetails.isEmpty) {
    } else {
      for (var i = 0; i < productDetails.length; i++) {
        allSubCategories[productDetails[i].category]![0]['price'] =
            productDetails[i].price;
      }
    }
    isProductsPricingLoading.value = false;
    initializeControllers();
  }

  handleSubmit() async {
    try {
      isUpdatingPrices.value = true;

      await processProductDetails();
      await getProductsPricing();
      clearState();
      Get.back();
    } catch (e) {
      log("Error in handleSubmit $e");
    } finally {
      isUpdatingPrices.value = false;
    }
  }

  Future<void> processProductDetails() async {
    await Future.wait(
      actualTextControllers.keys.map((category) async {
        for (var controllerMap in actualTextControllers[category]!) {
          String productId = controllerMap.keys.first;
          TextEditingController controller = controllerMap.values.first;

          bool found = fetchedProductDetails.any((product) =>
              product.productId == productId && product.category == category);
          if (found) {
            var product = fetchedProductDetails.firstWhere(
                (p) => p.productId == productId && p.category == category);

            await updateProductDetails(
              subCategory: SubCategoryModel(
                category: product.category,
                materialDetails: product.materialDetails,
                productName: product.productName,
                productId: product.productId,
              ),
              price: double.parse(controller.text),
            );
          } else {
            SubCategoryModel model = SubCategoryModel();
            List<Map<String, dynamic>> map = allSubCategories[category]!;

            for (var entry in map) {
              if (entry['subCategory'].productId == int.parse(productId)) {
                model = entry['subCategory'];
                break;
              }
            }

            await createProductDetails(
              subCategory: SubCategoryModel(
                category: model.category,
                materialDetails: model.materialDetails,
                productName: model.productName,
                productId: model.productId,
              ),
              price: double.parse(controller.text),
            );
          }
        }
      }),
    );
  }

  Future<void> createProductDetails(
      {required SubCategoryModel subCategory, required double price}) async {
    try {
      ProductDetailsModel data = ProductDetailsModel(
          id: 0,
          userId: Get.find<MainScreenController>().user?.userId,
          productId: subCategory.productId,
          price: price,
          address: Get.find<MainScreenController>().user?.address,
          latitudeLongitude: "string",
          category: subCategory.category,
          materialDetails: subCategory.materialDetails,
          productName: subCategory.productName,
          unit: "string");
      await createProductDetailsApi(data: data);
    } catch (e) {
      if (kDebugMode) {
        log("Error in createProductDetails $e");
      }
    }
  }

  Future<void> updateProductDetails(
      {required SubCategoryModel subCategory, required double price}) async {
    try {
      await updateProductDetailsApi(
          data: ProductDetailsModel(
              userId: Get.find<MainScreenController>().user?.userId,
              productId: subCategory.productId,
              price: price,
              address: Get.find<MainScreenController>().user?.address,
              latitudeLongitude: null,
              category: subCategory.category,
              materialDetails: subCategory.materialDetails,
              productName: subCategory.productName,
              unit: null));
    } catch (e) {
      if (kDebugMode) {
        log("Error in createProductDetails $e");
      }
    }
  }

  clearState() {
    actualTextControllers.clear();
    isUpdatingPrices.value = false;
  }
}
