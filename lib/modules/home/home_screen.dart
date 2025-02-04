import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/home/components/hero_carousal.dart';
import 'package:simple_ui/modules/home/components/home_appbar.dart';
import 'package:simple_ui/modules/home/components/home_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                HomeAppbar(),
                SizedBox(
                  height: 20.h,
                ),
                // Carousel Section
                BannerCarousal(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HeroCarousal(),
                ),
                FeatureCards()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
