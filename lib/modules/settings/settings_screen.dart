import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BricolageText(text: "Settings"),
        ),
        body: SafeArea(
          child: Center(
              child: InkWell(
                  onTap: () async {
                    try {
                      await SecureStorageServices().logOut();
                      Get.off(() => SplashScreen());
                    } catch (e) {
                      log("error in logOut $e");
                    }
                  },
                  child: Text("Logout"))),
        ));
  }
}
