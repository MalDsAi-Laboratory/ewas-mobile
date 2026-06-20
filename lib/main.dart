import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/auth/register_page.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/app_start_services.dart';
import 'package:simple_ui/services/apis/base_dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await appStartServices();

  // On any 401 response, clear storage and redirect to login.
  setUnauthorizedCallback(() {
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
