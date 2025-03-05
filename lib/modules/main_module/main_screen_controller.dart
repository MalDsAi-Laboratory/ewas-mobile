import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/cart/cart_page.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/home/recycler_home_screen.dart';
import 'package:simple_ui/modules/home/seller_home_screen.dart';
import 'package:simple_ui/modules/main_module/components/bottom_navbar.dart';
import 'package:simple_ui/modules/orders/admin_order_page.dart';
import 'package:simple_ui/modules/orders/all_order_page.dart';
import 'package:simple_ui/modules/orders/recycler_order_page.dart';
import 'package:simple_ui/modules/settings/settings_screen.dart';
import 'package:simple_ui/modules/updatePrice/update_price_screen.dart';

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
  List<BottomNavBarItem> bottomNavBarItems = [];

  void changePage(int index) {
    currentIndex = index;
    update();
  }

  getRoleBasedScreen(UserModel user) {
    switch (user.roles![0]) {
      case UserRole.admin:
        return [
          CategoriesPage(
            isAccessFromBottomTab: true,
          ),
          AdminOrderScreen(),
          SettingsScreen(),
          CartPage()
        ];
      case UserRole.deliveryAgent:
        return [
          CategoriesPage(
            isAccessFromBottomTab: true,
          ),
          AdminOrderScreen(),
          SettingsScreen(),
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
          UpdatePriceScreen(
            isAccessFromBottomTab: true,
          ),
          RecyclerOrderPage(),
          RecyclerHomePage(),
          CartPage(),
        ];
      default:
        return CartPage();
    }
  }

  getRoleBasedBottomNavItems(UserModel user) {
    switch (user.roles![0]) {
      case UserRole.admin:
        return [
          const BottomNavBarItem(
            text: "Category",
            icon: Icons.category,
            index: 0,
          ),
          const BottomNavBarItem(
            text: "Orders",
            icon: Icons.list,
            index: 1,
          ),
          const BottomNavBarItem(
            text: "Settings",
            icon: Icons.list,
            index: 2,
          ),
        ];
      case UserRole.deliveryAgent:
        return [
          const BottomNavBarItem(
            text: "Category",
            icon: Icons.category,
            index: 0,
          ),
          const BottomNavBarItem(
            text: "Orders",
            icon: Icons.list,
            index: 1,
          ),
          const BottomNavBarItem(
            text: "Settings",
            icon: Icons.list,
            index: 2,
          ),
        ];
      case UserRole.seller:
        return [
          const BottomNavBarItem(
            text: "Category",
            icon: Icons.category,
            index: 0,
          ),
          const BottomNavBarItem(
            text: "Orders",
            icon: Icons.list,
            index: 1,
          ),
          const BottomNavBarItem(
            index: 2,
          ),
          const BottomNavBarItem(
            text: "Cart",
            index: 3,
            icon: CupertinoIcons.cart_fill,
          ),
        ];
      case UserRole.recycler:
        return [
          const BottomNavBarItem(
            text: "Category",
            icon: Icons.category,
            index: 0,
          ),
          const BottomNavBarItem(
            text: "Orders",
            icon: Icons.list,
            index: 1,
          ),
          const BottomNavBarItem(
            index: 2,
          ),
          const BottomNavBarItem(
            text: "Cart",
            index: 3,
            icon: CupertinoIcons.cart_fill,
          ),
        ];
      default:
        return CartPage();
    }
  }

  @override
  void onInit() {
    super.onInit();
    pages = getRoleBasedScreen(user!);
    bottomNavBarItems = getRoleBasedBottomNavItems(user!);
    if (user?.roles?[0] == UserRole.admin ||
        user?.roles?[0] == UserRole.deliveryAgent) {
      currentIndex = 1;
    }
    isSettingUpApp = false;
    update();
  }
}
