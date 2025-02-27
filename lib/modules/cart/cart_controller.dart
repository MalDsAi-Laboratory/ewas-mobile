import 'dart:developer';

import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/product_model.dart';
import 'package:simple_ui/services/secure_storage/cached_cart_list.dart';

class CartController extends GetxController {
  RxBool isCartProductsLoading = true.obs;
  RxList<InventoryModel> cartProducts = <InventoryModel>[].obs;
  void getCartProducts() async {
    try {
      final CachedCartList cachedCartList = CachedCartList();

      cartProducts.value = await cachedCartList.getProducts();
      log('cartProducts ${cartProducts}');
      isCartProductsLoading.value = false;
    } catch (e) {
      log("error in getCartProducts $e");
      isCartProductsLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCartProducts();
  }
}
