import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/category_model.dart';
import 'package:simple_ui/models/sub_category_model.dart';
import 'package:simple_ui/services/apis/product_catalogue_apis/product_catalogue_api.dart';

class CategoriesController extends GetxController {
  var allCategories = <CategoryModel>[].obs;
  var filteredCategories = <CategoryModel>[].obs;
  var searchController = TextEditingController();
  CategoryModel? selectedCategory;
  RxBool isCategoriesLoading = true.obs;
  RxInt pageNumber = 0.obs;
  RxMap<String, List<SubCategoryModel>> allSubCategories =
      <String, List<SubCategoryModel>>{}.obs;
  SubCategoryModel? selectedSubCategory;
  RxBool isSubCategoriesLoading = true.obs;

  setSelectedCategory(selectedCategory) {
    this.selectedCategory = selectedCategory;
    update();
  }

  clearState() {
    selectedCategory = null;
    searchController.clear();
    filteredCategories.assignAll(allCategories);
    update();
  }

  void _fetchCategories() async {
    if (allCategories.isEmpty) {
      try {
        Map<String, dynamic>? response = await getAllCategoriesApi(
            pageNumber: pageNumber.value, pageSize: 100);
        if (response['status']) {
          List<CategoryModel> categories = [];
          for (var i = 0; i < response['data'].length; i++) {
            categories.add(CategoryModel.fromJson(response['data'][i]));
          }
          allCategories.assignAll(categories);
          isCategoriesLoading.value = false;
        } else {
          isCategoriesLoading.value = false;
        }
      } catch (e) {
        isCategoriesLoading.value = false;
        if (kDebugMode) {
          log('Error occured in fetch categories: $e');
        }
      }
    }
    filteredCategories.assignAll(allCategories);
  }

  void _filterCategories() {
    final query = searchController.text.toLowerCase();
    filteredCategories.assignAll(
      allCategories
          .where((category) => category.category != null
              ? category.category!.toLowerCase().contains(query)
              : true)
          .toList(),
    );
  }

  fetchSubCategories() async {
    if (allSubCategories[selectedCategory!.category!] == null) {
      try {
        Map<String, dynamic>? response = await getProductsFromCategoryApi(
            category: selectedCategory!.category!);
        if (response['status']) {
          List<SubCategoryModel> categories = [];
          for (var i = 0; i < response['data'].length; i++) {
            categories.add(SubCategoryModel.fromJson(response['data'][i]));
          }
          allSubCategories[selectedCategory!.category!] = categories;
        }
      } catch (e) {
        if (kDebugMode) {
          log('Error occured in fetch categories: $e');
        }
      }
    }
    isSubCategoriesLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
    searchController.addListener(_filterCategories);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
