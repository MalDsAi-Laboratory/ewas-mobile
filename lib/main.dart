import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/auth/register_page.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/app_start_services.dart';
import 'package:simple_ui/services/apis/base_dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await appStartServices();

  // On any 401 response, clear storage, clean up stale controllers, and
  // redirect to login. The dedup guard in base_dio ensures this fires once.
  setUnauthorizedCallback(() {
    log('401 unauthorized — clearing session and returning to login');
    // Delete GetX controllers so onInit() fires fresh on next login.
    if (Get.isRegistered<AllOrderController>()) {
      Get.delete<AllOrderController>(force: true);
    }
    if (Get.isRegistered<CategoriesController>()) {
      Get.delete<CategoriesController>(force: true);
    }
    if (Get.isRegistered<MainScreenController>()) {
      Get.delete<MainScreenController>(force: true);
    }
    Get.snackbar(
      'Session expired',
      'Please log in again.',
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.offAll(() => AuthScreen());
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          return GetMaterialApp(
            title: 'ScrapIt',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        });
  }
}
