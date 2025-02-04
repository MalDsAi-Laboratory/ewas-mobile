import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class HeroCarousal extends StatelessWidget {
  const HeroCarousal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          color: const Color.fromARGB(255, 241, 241, 241),
          text: "EXPLORE",
        ),
        SizedBox(height: 20.h),
        InkWell(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarousalWidget(),
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
                        text: 'Sell your E-waste',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      Row(
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
                                color: Colors.grey, shape: BoxShape.circle),
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

class CarousalWidget extends StatefulWidget {
  @override
  _CarousalWidgetState createState() => _CarousalWidgetState();
}

class _CarousalWidgetState extends State<CarousalWidget> {
  final List<String> imgList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbcqMJdCtRjtPSsWh2b3NX-3DuwuDntyh0Gw&s',
    'https://content.jdmagicbox.com/v2/comp/delhi/v6/011pxx11.xx11.121011103308.k8v6/catalogue/e-waste-recyclers-india-okhla-industrial-area-phase-1-delhi-e-waste-management-services-os297dh1bk.jpg',
  ];

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
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r)),
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
