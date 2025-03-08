import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroCarousal extends StatelessWidget {
  final String title;
  final List<String> imgList;
  final void Function()? onTap;
  final bool autoPlay;
  final bool? showBottomWidget;
  const HeroCarousal(
      {super.key,
      required this.title,
      required this.imgList,
      this.onTap,
      required this.autoPlay,
      this.showBottomWidget = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: onTap ?? null,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarousalWidget(
                  autoPlay: autoPlay,
                  imgList: imgList,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  padding:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      BricolageText(
                        text: title,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      !showBottomWidget!
                          ? SizedBox()
                          : Row(
                              children: [
                                Row(children: [
                                  Icon(
                                    Icons.location_on_sharp,
                                    size: 15.r,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  BricolageText(
                                    text: "1 km - 10 km",
                                    style: TextStyle(fontSize: 13.sp),
                                  )
                                ]),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                  width: 3,
                                  height: 3,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                BricolageText(
                                  text: "7 Recyclers",
                                  style: TextStyle(fontSize: 13.sp),
                                )
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CarousalWidget extends StatelessWidget {
  final List<String> imgList;
  final bool autoPlay;
  CarousalWidget({super.key, required this.imgList, required this.autoPlay});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255), // Background color
        borderRadius: BorderRadius.circular(25.r), // Rounded corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 200.h, // Height of the carousel
            autoPlay: autoPlay, // Auto-play the carousel
            enlargeCenterPage: false, // Enlarge the center image
            autoPlayInterval: Duration(seconds: 3),
            aspectRatio: 1, // Aspect ratio of the images
            autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
            enableInfiniteScroll: true, // Infinite scrolling
            autoPlayAnimationDuration:
                Duration(milliseconds: 800), // Animation duration
            viewportFraction: 1, // Fraction of the viewport to show
          ),
          items: imgList.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: item,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
