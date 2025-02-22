import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/auth/register_page.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/app_start_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  appStartServices();
  runApp(MyApp());
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844), // Set the design size parameters
        builder: (context, child) {
          return GetMaterialApp(
            title: 'ScrapIt',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        });
  }
}
