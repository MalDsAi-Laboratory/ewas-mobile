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
            // ── Logo placeholder — replace with Image.asset once final logo is ready ──
            _LogoPlaceholder(),
            SizedBox(height: 16.h),
            InterText(
              text: "ScrapIt",
              style: TextStyle(
                fontSize: 28.sp,
                letterSpacing: -0.8,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 6.h),
            InterText(
              text: "E-waste recycling, simplified.",
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
              ),
            ),
            SizedBox(height: 24.h),
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

/// Temporary logo placeholder.
/// Replace with: Image.asset('assets/images/scrapit_logo.png', height: 64.h)
/// once the final logo asset is ready.
class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.25), width: 1.5),
      ),
      child: Icon(
        Icons.recycling_rounded,
        size: 38,
        color: AppColors.primaryColor,
      ),
    );
  }
}
