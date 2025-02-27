import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';

List<InventoryModel> products = [
  InventoryModel(
    productId: "201",
    productName: "Broken Smartphone",
    category: "E-Waste",
    materialType: "Plastic, Lithium Battery, Glass",
    imgPath1:
        "https://images.unsplash.com/photo-1607976973585-a6c285b90ef5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ),
  InventoryModel(
    productId: "202",
    productName: "Non-functional Laptop",
    category: "E-Waste",
    materialType: "Aluminum, Lithium Battery, Copper",
    imgPath1:
        "https://plus.unsplash.com/premium_photo-1725309316018-e616a4cbe9ac?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ),
  InventoryModel(
    productId: "203",
    productName: "Old Inkjet Printer",
    category: "E-Waste",
    materialType: "Plastic, Circuit Board, Ink Residue",
    imgPath1:
        "https://5.imimg.com/data5/SELLER/Default/2021/11/MN/TZ/DV/13064877/old-used-hp-1010-printer-500x500.jpg",
  ),
  InventoryModel(
    productId: "204",
    productName: "Dead Power Bank",
    category: "E-Waste",
    materialType: "Lithium-Ion Battery, Plastic, Metal",
    imgPath1:
        "https://content.instructables.com/FJU/Z45O/J0487OOW/FJUZ45OJ0487OOW.png?auto=webp&frame=1&crop=3:2&width=320&md=MjAxNy0wMy0xMSAwNzozMDo1MC4w",
  )
];

class AllProductController extends GetxController {
  var allProducts = <InventoryModel>[];
  var filteredProducts = <InventoryModel>[];
  var searchController = TextEditingController();
  InventoryModel? selectedProduct;

  setSelectedProduct(selectedProduct) {
    this.selectedProduct = selectedProduct;
    update();
  }

  clearState() {
    selectedProduct = null;
    searchController.clear();
    filteredProducts.assignAll(allProducts);
    update();
  }

  void _fetchProducts() {
    // Simulating API call (replace with real backend call)
    allProducts.assignAll(products);

    filteredProducts.assignAll(allProducts);
    update();
  }

  void _filterProduct() {
    final query = searchController.text.toLowerCase();
    filteredProducts.assignAll(
      allProducts
          .where(
              (product) => product.productName!.toLowerCase().contains(query))
          .toList(),
    );
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchProducts();
    searchController.addListener(_filterProduct);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
