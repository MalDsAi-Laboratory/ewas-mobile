import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerCarousal extends StatelessWidget {
  final bool autoPlay;
  const BannerCarousal({super.key, required this.autoPlay});

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
          autoPlay: autoPlay,
          height: 270.h,
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

class CarousalWidget extends StatelessWidget {
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
                height: height ?? 200.h, // Height of the carousel
                autoPlay: autoPlay!, // Auto-play the carousel
                enlargeCenterPage: false, // Enlarge the center image
                aspectRatio: 1, // Aspect ratio of the images
                viewportFraction: 1, // Fraction of the viewport to show
                autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                enableInfiniteScroll: imgList.length > 1, // Infinite scrolling
                autoPlayAnimationDuration:
                    Duration(milliseconds: 800), // Animation duration
              ),
              items: imgList.map((item) {
                return CachedNetworkImage(
                  imageUrl: item,
                  fit: fit!,
                  width: double.infinity,
                  height: height ?? 200.h,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
