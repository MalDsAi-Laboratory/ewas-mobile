import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late TabController _tabController;
  bool agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    Get.put(AuthController());

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          false, // Prevents UI shift when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/scrapit_logo.png", height: 60.h),
                SizedBox(width: 10.w),
                InterText(
                  text: "Scrap It",
                  style: TextStyle(
                      fontSize: 26.sp,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            InterText(
                text: "Welcome to Scrap It",
                style: TextStyle(
                    fontSize: 23.sp,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 5.h),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "For Smarter, Greener ",
                style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500)),
              ),
              TextSpan(
                text: "& ",
                style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                        color: const Color.fromARGB(255, 27, 27, 27),
                        fontSize: 13.sp)),
              ),
              TextSpan(
                text: "Sustainable India",
                style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500)),
              )
            ])),
            SizedBox(height: 20.h),
            TabBar(
              controller: _tabController,
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
                controller: _tabController,
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
