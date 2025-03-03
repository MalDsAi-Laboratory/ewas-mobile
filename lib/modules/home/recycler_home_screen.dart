import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/home/components/hero_carousal.dart';
import 'package:simple_ui/modules/home/components/home_appbar.dart';
import 'package:simple_ui/modules/product/find_ewaste_screen.dart';
import 'package:simple_ui/modules/updatePrice/all_products_screen.dart';
import 'package:simple_ui/modules/updatePrice/update_price_controller.dart';

class RecyclerHomePage extends StatefulWidget {
  @override
  _RecyclerHomePageState createState() => _RecyclerHomePageState();
}

class _RecyclerHomePageState extends State<RecyclerHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isBannerAutoPlay = true;
  bool _isHero1AutoPlay = false;
  bool _isHero2AutoPlay = false;

  @override
  void initState() {
    super.initState();
    Get.put(UpdatePriceController());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    setState(() {
      if (currentScroll < maxScroll * 0.50) {
        _isBannerAutoPlay = true;
        _isHero1AutoPlay = false;
        _isHero2AutoPlay = false;
      } else if (currentScroll < maxScroll * 0.90) {
        _isBannerAutoPlay = false;
        _isHero1AutoPlay = true;
        _isHero2AutoPlay = false;
      } else {
        _isBannerAutoPlay = false;
        _isHero1AutoPlay = false;
        _isHero2AutoPlay = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                HomeAppbar(),
                SizedBox(height: 20.h),

                // Banner Carousel
                BannerCarousal(autoPlay: _isBannerAutoPlay),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      // Second Hero Carousel
                      HeroCarousal(
                        title: 'Find E-waste',
                        imgList: [
                          'https://lh5.googleusercontent.com/p/AF1QipPrZuvnjVugY-po3T-CkYFVthnWo2fpGcFS-JB4=w408-h544-k-no',
                          'https://lh5.googleusercontent.com/p/AF1QipN62C_mq6FZxPGN93ObZDb44TTe9Zo0bARxd18C=w519-h240-k-no',
                        ],
                        autoPlay: _isHero1AutoPlay,
                        onTap: () {
                          Get.to(() => FindEwasteScreen());
                        },
                      ),
                      SizedBox(height: 16.h),
                      // First Hero Carousel
                      HeroCarousal(
                        title: 'Update your purchase prices',
                        imgList: [
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbcqMJdCtRjtPSsWh2b3NX-3DuwuDntyh0Gw&s',
                          'https://content.jdmagicbox.com/v2/comp/delhi/v6/011pxx11.xx11.121011103308.k8v6/catalogue/e-waste-recyclers-india-okhla-industrial-area-phase-1-delhi-e-waste-management-services-os297dh1bk.jpg',
                        ],
                        autoPlay: _isHero2AutoPlay,
                        showBottomWidget: false,
                        onTap: () {
                          Get.to(() => UpdatePriceScreen());
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
