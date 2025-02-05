import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/auth/login_page.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/home/admin_home_screen.dart';
import 'package:simple_ui/modules/home/delivery_home_screen.dart';
import 'package:simple_ui/modules/home/recycler_home_screen.dart';
import 'package:simple_ui/modules/home/seller_screen.dart';
import 'package:simple_ui/modules/orders/admin_order_page.dart';
import 'package:simple_ui/modules/orders/all_order_page.dart';

class MainScreenController extends GetxController {
  int currentIndex = 2;
  UserModel? user;
  MainScreenController({required this.user});

  /// isSettingUpApp: Processing the role based setup of app
  bool isSettingUpApp = true;

  final List<Widget> pages = [
    CategoriesPage(
      isAccessFromBottomTab: true,
    ),
    // OrderScreen(),
    AdminOrderScreen(),
    SellerHomePage(),
    SellerHomePage(),
  ];

  void changePage(int index) {
    currentIndex = index;
    update();
  }

  getRoleBasedScreen(UserModel user) {
    switch (user.role) {
      case UserRole.admin:
        return AdminHomePage();
      case UserRole.deliveryAgent:
        return DeliveryHomePage();
      case UserRole.seller:
        return SellerHomePage();
      case UserRole.recycler:
        return RecyclerHomePage();
      default:
        return LoginPage();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pages[2] = getRoleBasedScreen(user!);
    isSettingUpApp = false;
    update();
  }
}
