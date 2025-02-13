import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerCarousal extends StatelessWidget {
  const BannerCarousal({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(() => CategoriesPage());
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
        child: CarousalWidget(
          imgList: [
            'http://93.229.113.153:8080/myapp/home_banner/1.webp',
            'http://93.229.113.153:8080/myapp/home_banner/2.webp',
            'http://93.229.113.153:8080/myapp/home_banner/3.webp',
          ],
        ),
      ),
    );
  }
}

class CarousalWidget extends StatefulWidget {
  final List<String> imgList;
  final bool? autoPlay;
  final BoxFit? fit;
  final double? height;
  CarousalWidget(
      {required this.imgList,
      this.autoPlay = true,
      this.fit = BoxFit.cover,
      this.height});
  @override
  _CarousalWidgetState createState() => _CarousalWidgetState();
}

class _CarousalWidgetState extends State<CarousalWidget> {
  int _currentIndex = 0; // Track the current index of the carousel

  @override
  Widget build(BuildContext context) {
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
                height: widget.height ?? 200.h, // Height of the carousel
                autoPlay: widget.autoPlay!, // Auto-play the carousel
                enlargeCenterPage: false, // Enlarge the center image
                aspectRatio: 1, // Aspect ratio of the images
                viewportFraction: 1, // Fraction of the viewport to show
                autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                enableInfiniteScroll:
                    widget.imgList.length > 1, // Infinite scrolling
                autoPlayAnimationDuration:
                    Duration(milliseconds: 800), // Animation duration
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Update the current index
                  });
                },
              ),
              items: widget.imgList.map((item) {
                return CachedNetworkImage(
                  imageUrl: item,
                  fit: widget.fit!,
                  width: double.infinity,
                  height: widget.height ?? 200.h,
                );
              }).toList(),
            ),
          ),
        ),
        widget.imgList.length > 1
            ? Padding(
                padding: EdgeInsets.only(bottom: 16.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imgList.map((url) {
                    int index = widget.imgList.indexOf(url);
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
              )
            : SizedBox(),
      ],
    );
  }
}
