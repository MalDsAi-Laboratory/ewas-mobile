import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:simple_ui/models/user_model.dart';
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
        UserModel user = UserModel(
            userId: 'savageSystem@2025',
            firstName: 'savage',
            lastLogin: DateTime.now().toUtc().toIso8601String(),
            password: 'bitByte',
            phoneNumber: '010101011',
            email: 'savage@gmail.com',
            roles: [UserRole.seller],
            address: 'system bit 01',
            lastName: 'system');
        // Navigate to the home screen after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => AppScreen(user: user));
        });
      }
    } catch (e) {
      // Navigate to the home screen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() => SplashScreen());
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
