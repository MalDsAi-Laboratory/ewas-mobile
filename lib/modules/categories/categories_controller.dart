import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/category_model.dart';

List<Category> categories = [
  Category(
      title: 'Battery',
      imageUrl:
          'https://4.imimg.com/data4/DN/KH/MY-2743443/amaron-four-wheeler-batteries-1000x1000.png'),
  Category(
      title: 'Battery',
      imageUrl:
          'https://4.imimg.com/data4/DN/KH/MY-2743443/amaron-four-wheeler-batteries-1000x1000.png'),
  Category(
      title: 'Battery',
      imageUrl:
          'https://4.imimg.com/data4/DN/KH/MY-2743443/amaron-four-wheeler-batteries-1000x1000.png'),
  Category(
      title: 'Battery',
      imageUrl:
          'https://4.imimg.com/data4/DN/KH/MY-2743443/amaron-four-wheeler-batteries-1000x1000.png'),
  Category(
      title: 'Wires',
      imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
  Category(
      title: 'Wires',
      imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
  Category(
      title: 'Wires',
      imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
  Category(
      title: 'Wires',
      imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
];

class CategoriesController extends GetxController {
  var allCategories = <Category>[].obs;
  var filteredCategories = <Category>[].obs;
  var searchController = TextEditingController();
  Category? selectedCategory;

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

  void _fetchCategories() {
    // Simulating API call (replace with real backend call)
    allCategories.assignAll(categories);

    filteredCategories.assignAll(allCategories);
  }

  void _filterCategories() {
    final query = searchController.text.toLowerCase();
    filteredCategories.assignAll(
      allCategories
          .where((category) => category.title.toLowerCase().contains(query))
          .toList(),
    );
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
