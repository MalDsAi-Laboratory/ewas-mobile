import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/product/components/bidding_table.dart';
import 'package:simple_ui/modules/product/components/timer_widget.dart';
import 'package:simple_ui/modules/product/product_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class ProductBiddingScreen extends StatefulWidget {
  final InventoryModel productModel;
  final String? sellerName;
  ProductBiddingScreen({required this.productModel, this.sellerName});
  @override
  _ProductBiddingScreenState createState() => _ProductBiddingScreenState();
}

class _ProductBiddingScreenState extends State<ProductBiddingScreen> {
  @override
  void initState() {
    super.initState();
    var controller = Get.put(ProductController());
    controller
        .setRemainingDuration(DateTime.parse(widget.productModel.dateAndTime!));
    controller.getBiddingDetails(orderId: widget.productModel.orderId);
  }

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
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
          child: Obx(
            () => productController.isLoading.value
                ? Center(
                    child: AppLoadingWidget(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        CarousalWidget(
                          fit: BoxFit.cover,
                          height: 250.h,
                          autoPlay: false,
                          imgList: [widget.productModel.imgPath1 ?? ""],
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
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
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
                                      TimerWidget(
                                          inputTime: DateTime.parse(widget
                                                      .productModel
                                                      .dateAndTime ??
                                                  "")
                                              .add(DateTime.now()
                                                  .timeZoneOffset)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                BricolageText(
                                    text: "Sold by",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w300,
                                    )),
                                SizedBox(width: 4.w),
                                BricolageText(
                                    text: widget.sellerName ??
                                        "${Get.find<MainScreenController>().user!.firstName} ${Get.find<MainScreenController>().user!.lastName}",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            widget.productModel.volume != null
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BricolageText(
                                            text: 'Volume',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          BricolageText(
                                            text:
                                                "${widget.productModel.volume!} ${widget.productModel.units ?? ""}",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  )
                                : SizedBox(),
                            widget.productModel.mbp != null
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BricolageText(
                                            text: 'Minimum base price',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          BricolageText(
                                            text:
                                                "₹ ${widget.productModel.mbp}",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  )
                                : SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BricolageText(
                                  text: 'Current Bid',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                                Builder(builder: (context) {
                                  double? val =
                                      productController.highestPrice.value;
                                  return BricolageText(
                                    text: "₹ ${val}",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  );
                                }),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Get.find<MainScreenController>().user?.roles?[0] !=
                                    UserRole.recycler
                                ? SizedBox()
                                : productController.remainingDatetime ==
                                        Duration.zero
                                    ? SizedBox()
                                    : Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: CustomTextField(
                                                  controller: productController
                                                      .biddingAmountController,
                                                  hintText: "eg. 100",
                                                  keyboardType:
                                                      TextInputType.number,
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
                                                    onTap: () {
                                                      productController.handlePlaceBid(
                                                          context: context,
                                                          orderId: widget
                                                              .productModel
                                                              .orderId!,
                                                          productName: widget
                                                              .productModel
                                                              .productName!,
                                                          mbp: widget
                                                                  .productModel
                                                                  .mbp ??
                                                              0,
                                                          volume: double.parse(
                                                              widget
                                                                  .productModel
                                                                  .volume!));
                                                    },
                                                    iconData: Icons.send),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h),
                                        ],
                                      ),
                            BiddingTableWidget(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

showRestrictedLoadingDialog(context) {
  showDialog(
      barrierColor: const Color.fromARGB(64, 0, 0, 0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        ProductController productController = Get.find<ProductController>();

        return Obx(
          () => PopScope(
              canPop: !productController.isBiddingPlacing.value,
              child: Center(child: AppLoadingWidget())),
        );
      });
}
