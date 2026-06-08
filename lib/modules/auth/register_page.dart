import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/auth/auth_controller.dart';
import 'package:simple_ui/modules/auth/components/login_widget.dart';
import 'package:simple_ui/modules/auth/components/register_widget.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    AuthController controller = Get.put(AuthController());

    controller.tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    Get.find<AuthController>().tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          false, // Prevents UI shift when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Image.asset(
              'assets/images/scrapit_logo.png',
              height: 110.h,
            ),
            SizedBox(height: 8.h),
            InterText(
              text: "FOR SMARTER GREENER & SUSTAINABLE INDIA",
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 20.h),
            TabBar(
              controller: controller.tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: "Login"),
                Tab(text: "Register"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  LoginWidget(),
                  RegisterWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
