import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ui/modules/updatePrice/update_price_controller.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class UpdatePriceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isAccessFromBottomTab;
  const UpdatePriceAppBar({super.key, this.isAccessFromBottomTab = false});

  @override
  Widget build(BuildContext context) {
    UpdatePriceController controller = Get.find<UpdatePriceController>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    BricolageText(
                      text: 'Update Price',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                  ],
                ),
                Obx(
                  () => AppBarButton(
                    onTap: controller.isProductsPricingLoading.value
                        ? () {}
                        : () {
                            controller.handleSubmit(context);
                          },
                    iconData: Icons.check,
                    iconColor: AppColors.primaryColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            // Search Bar
            GetBuilder<UpdatePriceController>(builder: (controller) {
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
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(160.h);
}
