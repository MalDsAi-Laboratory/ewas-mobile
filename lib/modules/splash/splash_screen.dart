import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/auth/register_page.dart';
import 'dart:async';
import 'package:simple_ui/modules/main_module/app_screen.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _loginUser();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  _loginUser() async {
    try {
      // check if local cache has user data
      Map<String, dynamic>? userCacheData =
          await SecureStorageServices().getUserModel();
      if (userCacheData != null) {
        UserModel user = UserModel.fromJson(userCacheData);
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => AppScreen(user: user));
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => AuthScreen());
        });
      }
    } catch (e) {
      // Navigate to the home screen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() => AuthScreen());
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light theme background
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'ScrapIt',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
