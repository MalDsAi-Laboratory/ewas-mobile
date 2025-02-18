import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/home/components/hero_carousal.dart';
import 'package:simple_ui/modules/home/components/home_appbar.dart';

class SellerHomePage extends StatelessWidget {
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
                BannerCarousal(
                  autoPlay: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      HeroCarousal(
                        title: 'Sell your E-waste',
                        autoPlay: true,
                        onTap: () {
                          Get.to(() => CategoriesPage());
                        },
                        imgList: [
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbcqMJdCtRjtPSsWh2b3NX-3DuwuDntyh0Gw&s',
                          'https://content.jdmagicbox.com/v2/comp/delhi/v6/011pxx11.xx11.121011103308.k8v6/catalogue/e-waste-recyclers-india-okhla-industrial-area-phase-1-delhi-e-waste-management-services-os297dh1bk.jpg',
                        ],
                      ),
                      // SizedBox(
                      //   height: 16.h,
                      // ),
                      // HeroCarousal(
                      //   title: 'Locate Recycler',
                      //   imgList: [
                      //     'https://lh5.googleusercontent.com/p/AF1QipPrZuvnjVugY-po3T-CkYFVthnWo2fpGcFS-JB4=w408-h544-k-no',
                      //     'https://lh5.googleusercontent.com/p/AF1QipN62C_mq6FZxPGN93ObZDb44TTe9Zo0bARxd18C=w519-h240-k-no',
                      //   ],
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
