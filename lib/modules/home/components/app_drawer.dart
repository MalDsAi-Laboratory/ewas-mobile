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
