import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/main_module/components/bottom_navbar.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/services/notifications/notifications_service.dart';

class AppScreen extends StatefulWidget {
  final UserModel user;
  const AppScreen({super.key, required this.user});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    super.initState();
    setupNotifications();
    Get.put(MainScreenController(user: widget.user));
    Get.put(AllOrderController());
    Get.put(CategoriesController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(builder: (mainScreenController) {
      return Scaffold(
        bottomNavigationBar: const NavBar(),
        body: mainScreenController.isSettingUpApp
            ? Center(
                child: CircularProgressIndicator(),
              )
            : mainScreenController.pages[mainScreenController.currentIndex],
      );
    });
  }
}
