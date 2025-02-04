import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/home/home_screen.dart';
import 'package:simple_ui/modules/orders/all_order_page.dart';

class MainScreenController extends GetxController {
  int currentIndex = 2;

  final List<Widget> pages = [
    CategoriesPage(
      isAccessFromBottomTab: true,
    ),
    OrderScreen(),
    HomePage(),
    HomePage(),
  ];

  void changePage(int index) {
    currentIndex = index;
    update();
  }
}
