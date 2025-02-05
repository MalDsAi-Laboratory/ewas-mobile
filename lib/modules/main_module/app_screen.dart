import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/components/bottom_navbar.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';

class AppScreen extends StatelessWidget {
  final UserModel user;
  const AppScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(
        init: MainScreenController(user: user),
        builder: (mainScreenController) {
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
