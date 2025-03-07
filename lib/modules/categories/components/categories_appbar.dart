import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CategoriesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isAccessFromBottomTab;
  const CategoriesAppBar({super.key, this.isAccessFromBottomTab = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                !isAccessFromBottomTab!
                    ? Row(
                        children: [
                          AppBarButton(),
                          SizedBox(
                            width: 12.w,
                          )
                        ],
                      )
                    : SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BricolageText(
                      text: 'Category',
                      style: TextStyle(fontSize: 20.sp, color: Colors.black87),
                    ),
                    BricolageText(
                      text: 'Select category of your interest',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color.fromARGB(221, 101, 101, 101)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            // Search Bar
            GetBuilder<CategoriesController>(builder: (controller) {
              return TextFormField(
                controller: controller.searchController,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    size: 23.r,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.r)),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 232, 232, 232), width: 0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.r)),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 232, 232, 232), width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.r)),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(0, 255, 255, 255), width: 0)),
                  hintText: "eg. Battery",
                  hintStyle: GoogleFonts.bricolageGrotesque(
                      textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromARGB(255, 111, 111, 111),
                    fontWeight: FontWeight.w400,
                  )),
                  // contentPadding: EdgeInsets.only(bottom: 13.h, left: 19.w),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 19.w, vertical: 16.h),
                  filled: true,
                  fillColor: Color.fromRGBO(244, 244, 244, 1.0),
                ),
              );
            }),

            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 113.h);
}
