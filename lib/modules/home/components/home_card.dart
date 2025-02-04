import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/locate_recyclers/locate_recylers.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class FeatureCards extends StatelessWidget {
  const FeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h),
        BricolageText(
          text: 'Quick Actions',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FeatureCardItem(
              text: "Sell your E-waste",
              child: Image.asset(
                'assets/images/sell_ewaste.jpg',
                width: 46.w,
                height: 72.h,
              ),
              onTap: () {
                Get.to(() => CategoriesPage());
              },
            ),
            SizedBox(
              width: 10.w,
            ),
            FeatureCardItem(
              text: "Locate Recyclers ",
              child: Image.asset(
                'assets/images/recycler_for_seller.png',
                width: 84.w,
                height: 72.h,
              ),
              onTap: () {
                Get.to(() => OpenStreetMapPage());
              },
            )
          ],
        ),
      ],
    );
  }
}

class FeatureCardItem extends StatelessWidget {
  final String text;
  final Widget child;
  final void Function()? onTap;
  const FeatureCardItem(
      {super.key, required this.text, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 171.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
              color: const Color.fromRGBO(201, 201, 201, 1.0), width: 0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            child,
            SizedBox(
              height: 10.h,
            ),
            BricolageText(
              text: text,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
