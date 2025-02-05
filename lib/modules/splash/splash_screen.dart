import 'package:flutter/material.dart';

import 'package:simple_ui/models/user_model.dart';
import 'dart:async';
import 'package:simple_ui/modules/main_module/app_screen.dart';

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

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    UserModel user = UserModel(
        id: '1',
        name: 'honey bansal',
        email: 'savage@gmail.com',
        role: UserRole.recycler);
    // Navigate to the home screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => AppScreen(
                  user: user,
                )),
      );
    });
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
