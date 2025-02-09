import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/product_model.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/product/components/bidding_table.dart';
import 'package:simple_ui/modules/product/product_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class ProductBiddingScreen extends StatefulWidget {
  final ProductModel productModel;
  ProductBiddingScreen({required this.productModel});
  @override
  _ProductBiddingScreenState createState() => _ProductBiddingScreenState();
}

class _ProductBiddingScreenState extends State<ProductBiddingScreen> {
  late Timer _timer;
  int _hours = 12;
  int _minutes = 45;
  int _seconds = 31;

  @override
  void initState() {
    super.initState();
    Get.put(ProductController());
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            if (_hours > 0) {
              _hours--;
              _minutes = 59;
              _seconds = 59;
            } else {
              _timer.cancel();
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: AppBarButton(),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CarousalWidget(
                  fit: BoxFit.cover,
                  height: 250.h,
                  autoPlay: false,
                  imgList: [widget.productModel.imagePath ?? ""],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: BricolageText(
                            textAlign: TextAlign.start,
                            text: widget.productModel.productName ?? "",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          width: 150.w,
                          // color:Colors.blue,
                          child: Column(
                            children: [
                              BricolageText(
                                textAlign: TextAlign.start,
                                text: "Time Left",
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 155, 155, 155),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              BricolageText(
                                text:
                                    '${_hours.toString().padLeft(2, '0')} : ${_minutes.toString().padLeft(2, '0')} : ${_seconds.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 255, 30, 0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                        ),
                        SizedBox(width: 8),
                        BricolageText(
                            text: 'Robert Json',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BricolageText(
                          text: 'Volume',
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.normal),
                        ),
                        BricolageText(
                          text: '100 pieces',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BricolageText(
                          text: 'Current Bid',
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.normal),
                        ),
                        BricolageText(
                          text: 'Rs 9500',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            FieldName: "Amount",
                            // width: size.width - 200.w,
                            hintText: "eg. 100",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SizedBox(
                          width: 140.w,
                          child: TextandIconButton(
                              isBtnActive: true,
                              height: 40.w,
                              iconInFront: false,
                              buttonText: 'Place Bid',
                              onTap: () {},
                              iconData: Icons.send),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    BiddingTableWidget(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
