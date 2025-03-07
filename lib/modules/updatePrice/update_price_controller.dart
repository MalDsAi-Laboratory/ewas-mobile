import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/product_details_model.dart';
import 'package:simple_ui/models/sub_category_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/updatePrice/update_price_screen.dart';
import 'package:simple_ui/services/apis/product_details/product_details_api.dart';

class UpdatePriceController extends GetxController {
  /// {"Battery": {"productId":price}}
  RxMap<String, Map<String, Map<SubCategoryModel, double>>> allSubCategories =
      <String, Map<String, Map<SubCategoryModel, double>>>{}.obs;
  RxMap<String, Map<String, Map<SubCategoryModel, double>>>
      filteredSubCategories =
      <String, Map<String, Map<SubCategoryModel, double>>>{}.obs;

  RxBool isProductsPricingLoading = true.obs;

  /// Stores a list of TextEditingControllers for each subcategory
  RxMap<String, Map<String, TextEditingController>> textControllers =
      <String, Map<String, TextEditingController>>{}.obs;

  /// Stores a list of TextEditingControllers for each subcategory
  /// {"Battery":[{"productId":TextEditingController}]}
  RxMap<String, Map<String, TextEditingController>> actualTextControllers =
      <String, Map<String, TextEditingController>>{}.obs;
  RxList<ProductDetailsModel> fetchedProductDetails =
      <ProductDetailsModel>[].obs;

  RxBool isUpdatingPrices = false.obs;
  var searchController = TextEditingController();

  /// Initialize controllers for each subcategory
  void initializeControllers() {
    textControllers.clear(); // Clear existing controllers before reinitializing

    for (var entry in allSubCategories.entries) {
      Map<String, TextEditingController> controllers = {};

      for (var subcategory in entry.value.entries) {
        controllers[subcategory.key] = TextEditingController(
            text: subcategory.value.entries.first.value.toString());
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
      allSubCategories[temp.keys.toList()[i]] = Map.fromEntries(temp.values
          .toList()[i]
          .map((e) => MapEntry(e.productId.toString(), {e: 0.0})));
    }

    if (productDetails.isEmpty) {
    } else {
      for (var i = 0; i < productDetails.length; i++) {
        allSubCategories[productDetails[i].category]![
            productDetails[i].productId.toString()] = {
          allSubCategories[productDetails[i].category]![
                  productDetails[i].productId.toString()]!
              .keys
              .first: productDetails[i].price ?? 0.0
        };
      }
    }
    isProductsPricingLoading.value = false;
    filteredSubCategories.assignAll(allSubCategories);
    initializeControllers();
  }

  handleSubmit(context) async {
    try {
      isUpdatingPrices.value = true;
      showUpdatePricingRestrictedLoadingDialog(context);
      await processProductDetails();
      await getProductsPricing();
      isUpdatingPrices.value = false;
      Get.back();
    } catch (e) {
      log("Error in handleSubmit $e");
      Get.back();
    } finally {
      isUpdatingPrices.value = false;
    }
  }

  Future<void> processProductDetails() async {
    await Future.wait(
      actualTextControllers.keys.map((category) async {
        for (var controllerMap in actualTextControllers[category]!.entries) {
          String productId = controllerMap.key;
          TextEditingController controller = controllerMap.value;

          bool found = fetchedProductDetails
              .any((product) => product.productId.toString() == productId);

          if (found) {
            var product = fetchedProductDetails
                .firstWhere((p) => p.productId.toString() == productId);
            await updateProductDetails(
              subCategory: SubCategoryModel(
                category: product.category,
                materialDetails: product.materialDetails,
                productName: product.productName,
                productId: product.productId,
                units: product.unit,
              ),
              id: product.id!,
              price: double.parse(controller.text),
            );
          } else {
            await createProductDetails(
              subCategory:
                  allSubCategories[category]![productId]!.entries.first.key,
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
          unit: subCategory.units);
      await createProductDetailsApi(data: data);
    } catch (e) {
      if (kDebugMode) {
        log("Error in createProductDetails $e");
      }
    }
  }

  Future<void> updateProductDetails(
      {required SubCategoryModel subCategory,
      required double price,
      required int id}) async {
    try {
      await updateProductDetailsApi(
          data: ProductDetailsModel(
              id: id,
              userId: Get.find<MainScreenController>().user?.userId,
              productId: subCategory.productId,
              price: price,
              address: Get.find<MainScreenController>().user?.address ?? "",
              latitudeLongitude: "",
              category: subCategory.category ?? "",
              materialDetails: subCategory.materialDetails ?? "",
              productName: subCategory.productName ?? "",
              unit: subCategory.units ?? ""));
    } catch (e) {
      if (kDebugMode) {
        log("Error in createProductDetails $e");
      }
    }
  }

  void _filterSubCategories() {
    // Create a new filtered map
    final query = searchController.text.toLowerCase();

    Map<String, Map<String, Map<SubCategoryModel, double>>> filteredData = {};

    allSubCategories.forEach((categoryKey, subcategoryMap) {
      Map<String, Map<SubCategoryModel, double>> filteredSubcategories = {};

      subcategoryMap.forEach((subcategoryKey, productMap) {
        // Filter products where productName contains the query
        var filteredProducts = productMap.entries.where((entry) =>
            entry.key.productName!.toLowerCase().contains(query.toLowerCase()));

        if (filteredProducts.isNotEmpty) {
          filteredSubcategories[subcategoryKey] =
              Map.fromEntries(filteredProducts);
        }
      });

      if (filteredSubcategories.isNotEmpty) {
        filteredData[categoryKey] = filteredSubcategories;
      }
    });

    filteredSubCategories.assignAll(filteredData);
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_filterSubCategories);
  }
}
