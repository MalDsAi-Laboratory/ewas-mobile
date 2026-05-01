import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/home/components/app_drawer.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/home/components/hero_carousal.dart';
import 'package:simple_ui/modules/product/find_ewaste_screen.dart';
import 'package:simple_ui/modules/updatePrice/update_price_screen.dart';
import 'package:simple_ui/modules/updatePrice/update_price_controller.dart';
import 'package:simple_ui/ui_utils/app_images.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class RecyclerHomePage extends StatefulWidget {
  @override
  _RecyclerHomePageState createState() => _RecyclerHomePageState();
}

class _RecyclerHomePageState extends State<RecyclerHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isBannerAutoPlay = true;
  bool _isHero1AutoPlay = false;
  bool _isHero2AutoPlay = false;
  bool _isHero3AutoPlay = false;

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
      if (currentScroll < maxScroll * 0.2) {
        // Reduced from 0.33
        _isBannerAutoPlay = true;
        _isHero1AutoPlay = false;
        _isHero2AutoPlay = false;
        _isHero3AutoPlay = false;
      } else if (currentScroll < maxScroll * 0.4) {
        // Reduced from 0.66
        _isBannerAutoPlay = false;
        _isHero1AutoPlay = true;
        _isHero2AutoPlay = false;
        _isHero3AutoPlay = false;
      } else if (currentScroll < maxScroll * 0.7) {
        // Reduced from 0.90
        _isBannerAutoPlay = false;
        _isHero1AutoPlay = false;
        _isHero2AutoPlay = true;
        _isHero3AutoPlay = false;
      } else {
        _isBannerAutoPlay = false;
        _isHero1AutoPlay = false;
        _isHero2AutoPlay = false;
        _isHero3AutoPlay = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
        ),
        child: AppDrawerWidget(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu_open_sharp,
              size: 30.r,
            )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BricolageText(
              text: "Hi !",
              style: TextStyle(fontSize: 16.sp),
            ),
            BricolageText(
              text: "Find and buy e-waste",
              style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color.fromARGB(255, 124, 124, 124)),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                // Banner Carousel
                BannerCarousal(autoPlay: _isBannerAutoPlay),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    children: [
                      HeroCarousal(
                        title: 'Find E-waste',
                        imgList: AppImages.findEwaste,
                        autoPlay: _isHero1AutoPlay,
                        showBottomWidget: false,
                        onTap: () {
                          Get.to(() => FindEwasteScreen());
                        },
                      ),
                      SizedBox(height: 16.h),
                      HeroCarousal(
                        title: 'Update your purchase prices',
                        imgList: AppImages.updatePrice,
                        autoPlay: _isHero2AutoPlay,
                        showBottomWidget: false,
                        onTap: () {
                          Get.to(() => UpdatePriceScreen());
                        },
                      ),
                      SizedBox(height: 16.h),
                      HeroCarousal(
                        title: 'Buy Recycled Items',
                        autoPlay: _isHero3AutoPlay,
                        showBottomWidget: false,
                        onTap: () {},
                        imgList: AppImages.buyRecycled,
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
