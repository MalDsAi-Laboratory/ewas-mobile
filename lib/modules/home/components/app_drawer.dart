import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/contact_us/contact_us_page.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
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
                  // Get.to(() => ContactUsPage());
                },
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  width: size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: AppColors.primaryColor,
                        size: 30.r,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      BricolageText(
                        text: 'Edit Profile',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                onTap: () {
                  // Get.to(() => ContactUsPage());
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  width: size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.password,
                        color: AppColors.primaryColor,
                        size: 30.r,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      BricolageText(
                        text: 'Change Password',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                onTap: () {
                  Get.to(() => ContactUsPage());
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  width: size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.contact_phone_sharp,
                        color: AppColors.primaryColor,
                        size: 30.r,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      BricolageText(
                        text: 'Contact Us',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              LogOutButton(),
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
