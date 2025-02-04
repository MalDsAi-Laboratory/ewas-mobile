import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/main_module/components/bottom_navbar.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(MainScreenController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(builder: (mainScreenController) {
      return Scaffold(
        bottomNavigationBar: const NavBar(),
        body: mainScreenController.pages[mainScreenController.currentIndex],
      );
    });
  }
}
