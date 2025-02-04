import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/modules/home/components/card_button.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SellerCard extends StatelessWidget {
  const SellerCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 9.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
        ),
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                bottom: 10.h,
                child: Container(
                  height: 185.h,
                  width: size.width - 30.w,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(224, 224, 224, 1.0),
                          spreadRadius: 0,
                          blurRadius: 4.r,
                          offset:
                              Offset(3.w, 4.h), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30.r),
                      color: Colors.white),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BricolageText(
                              text: "Turn Scrap into Cash!",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            BricolageText(
                              text:
                                  "Get the best rates for your scrap materials.\nSell with ease and maximize your earnings!",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                          ],
                        ),
                        const CardButton(text: "Start Selling")
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
