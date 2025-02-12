import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/auth/login_page.dart';
import 'package:simple_ui/modules/cart/cart_page.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/home/admin_home_screen.dart';
import 'package:simple_ui/modules/home/delivery_home_screen.dart';
import 'package:simple_ui/modules/home/recycler_home_screen.dart';
import 'package:simple_ui/modules/home/seller_home_screen.dart';
import 'package:simple_ui/modules/orders/admin_order_page.dart';
import 'package:simple_ui/modules/orders/all_order_page.dart';

class MainScreenController extends GetxController {
  int currentIndex = 2;
  UserModel? user;
  MainScreenController({required this.user});

  /// isSettingUpApp: Processing the role based setup of app
  bool isSettingUpApp = true;

  List<Widget> pages = [
    // SellerHomePage(),
    CategoriesPage(
      isAccessFromBottomTab: true,
    ),
    // OrderScreen(),
    AdminOrderScreen(),
    SellerHomePage(),
    // SellerHomePage(),
    CartPage()
  ];

  void changePage(int index) {
    currentIndex = index;
    update();
  }

  getRoleBasedScreen(UserModel user) {
    switch (user.role) {
      case UserRole.admin:
        return [
          CategoriesPage(
            isAccessFromBottomTab: true,
          ),
          AdminOrderScreen(),
          AdminHomePage(),
          CartPage()
        ];
      case UserRole.deliveryAgent:
        return [
          CategoriesPage(
            isAccessFromBottomTab: true,
          ),
          AdminOrderScreen(),
          DeliveryHomePage(),
          CartPage()
        ];
      case UserRole.seller:
        return [
          CategoriesPage(
            isAccessFromBottomTab: true,
          ),
          AllOrderScreen(),
          SellerHomePage(),
          CartPage()
        ];
      case UserRole.recycler:
        return [
          CategoriesPage(
            isAccessFromBottomTab: true,
          ),
          AllOrderScreen(),
          RecyclerHomePage(),
          CartPage()
        ];
      default:
        return LoginPage();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pages = getRoleBasedScreen(user!);
    isSettingUpApp = false;
    update();
  }
}
