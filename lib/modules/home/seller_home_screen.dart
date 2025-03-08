import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/home/components/app_drawer.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/home/components/hero_carousal.dart';
import 'package:simple_ui/modules/seller_items/seller_items.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SellerHomePage extends StatefulWidget {
  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isBannerAutoPlay = true;
  bool _isHero1AutoPlay = false;
  bool _isHero2AutoPlay = false;
  bool _isHero3AutoPlay = false;

  @override
  void initState() {
    super.initState();
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
              text: "Let's sell your e-waste",
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
                // Carousel Section
                BannerCarousal(
                  autoPlay: _isBannerAutoPlay,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      HeroCarousal(
                        title: 'Sell your E-waste',
                        autoPlay: _isHero1AutoPlay,
                        showBottomWidget: false,
                        onTap: () {
                          Get.to(() => CategoriesPage());
                        },
                        imgList: [
                          'http://ewas.maldsai.com:8080/myapp/home_banner/1.webp',
                          'http://ewas.maldsai.com:8080/myapp/home_banner/2.webp',
                        ],
                      ),
                      SizedBox(height: 16.h),
                      HeroCarousal(
                        title: 'View your items',
                        autoPlay: _isHero2AutoPlay,
                        showBottomWidget: false,
                        onTap: () {
                          Get.to(() => SellerItemsScreen());
                        },
                        imgList: [
                          'http://ewas.maldsai.com:8080/myapp/home_banner/1.webp',
                          'http://ewas.maldsai.com:8080/myapp/home_banner/2.webp',
                        ],
                      ),
                      SizedBox(height: 16.h),
                      HeroCarousal(
                        title: 'Buy Recycled Items',
                        autoPlay:
                            _isHero3AutoPlay, // Updated autoplay condition
                        showBottomWidget: false,
                        onTap: () {
                          // Get.to(() => SellerItemsScreen());
                        },
                        imgList: [
                          'http://ewas.maldsai.com:8080/myapp/home_banner/1.webp',
                          'http://ewas.maldsai.com:8080/myapp/home_banner/2.webp',
                        ],
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
