import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_ui/models/inventory_model.dart';

class CachedCartList {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _key = 'cart_products';

  // Save product list
  Future<void> saveProducts(List<InventoryModel> products) async {
    try {
      String jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
      await _storage.write(key: _key, value: jsonString);
    } catch (e) {
      log("error in saveProducts $e");
    }
  }

  // Fetch product list
  Future<List<InventoryModel>> getProducts() async {
    String? jsonString = await _storage.read(key: _key);
    if (jsonString == null) return [];
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => InventoryModel.fromJson(json)).toList();
  }

  // Add a product to the list
  Future<void> addProduct({InventoryModel? product}) async {
    List<InventoryModel> products = await getProducts();
    products.add(product!);
    await saveProducts(products);
  }

  // Update a product in the list
  Future<void> updateProduct(InventoryModel updatedProduct) async {
    List<InventoryModel> products = await getProducts();
    int index =
        products.indexWhere((p) => p.productId == updatedProduct.productId);
    if (index != -1) {
      products[index] = updatedProduct;
      await saveProducts(products);
    }
  }

  // Remove a product from the list
  Future<void> removeProduct(int productId) async {
    List<InventoryModel> products = await getProducts();
    products.removeWhere((p) => p.productId == productId);
    await saveProducts(products);
  }

  // Clear all products
  Future<void> clearCart() async {
    await _storage.delete(key: _key);
  }
}
