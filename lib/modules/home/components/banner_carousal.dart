import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';

class BannerCarousal extends StatelessWidget {
  const BannerCarousal({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => CategoriesPage());
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2.0),
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6.0,
              ),
            ],
            border: Border.all(
                color: const Color.fromARGB(133, 48, 48, 48), width: 0.2)),
        child: CarousalWidget(),
      ),
    );
  }
}

class CarousalWidget extends StatefulWidget {
  @override
  _CarousalWidgetState createState() => _CarousalWidgetState();
}

class _CarousalWidgetState extends State<CarousalWidget> {
  int _currentIndex = 0; // Track the current index of the carousel

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://static.vecteezy.com/system/resources/previews/002/372/705/non_2x/abstract-green-geometric-banner-background-free-vector.jpg',
      'https://e7.pngegg.com/pngimages/869/370/png-clipart-low-polygon-background-green-banner-low-poly-materialized.png',
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255), // Background color
            borderRadius: BorderRadius.circular(25.r), // Rounded corners
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.r),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200.h, // Height of the carousel
                autoPlay: true, // Auto-play the carousel
                enlargeCenterPage: false, // Enlarge the center image
                aspectRatio: 1, // Aspect ratio of the images
                autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                enableInfiniteScroll: true, // Infinite scrolling
                autoPlayAnimationDuration:
                    Duration(milliseconds: 800), // Animation duration
                viewportFraction: 1, // Fraction of the viewport to show
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Update the current index
                  });
                },
              ),
              items: imgList.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(item),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: _currentIndex == index ? 16.0.w : 5.0.w,
                height: 5.w,
                margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: _currentIndex == index
                      ? const Color.fromARGB(
                          255, 255, 255, 255) // Active dot color
                      : const Color.fromARGB(
                          213, 158, 158, 158), // Inactive dot color
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
