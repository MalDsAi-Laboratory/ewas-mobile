import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/contact_us/contact_us_page.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => ContactUsPage());
                },
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                child: Row(
                  // onTap: () {
                  //   Get.to(() => ContactUsPage());
                  // },
                  children: [
                    Icon(
                      Icons.contact_phone_sharp,
                      color: AppColors.primaryColor,
                      size: 30.r,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    BricolageText(text: 'Contact Us'),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              LoagOutButton(),
              SizedBox(
                height: 16.h,
              )
            ],
          )
        ],
      ),
    );
  }
}

class LoagOutButton extends StatelessWidget {
  const LoagOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        backgroundColor: const Color.fromARGB(
            255, 244, 244, 244), // Make the button itself transparent
        shadowColor: const Color.fromARGB(
            0, 238, 238, 238), // Remove default button shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      onPressed: () async {
        try {
          await SecureStorageServices().logOut();
          Get.off(() => SplashScreen());
        } catch (e) {
          log("error in logOut $e");
        }
      },
      child: Center(
        child: BricolageText(
          text: "Logout",
          style: TextStyle(
              fontSize: 16.sp,
              color: const Color.fromARGB(255, 237, 0, 0),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
