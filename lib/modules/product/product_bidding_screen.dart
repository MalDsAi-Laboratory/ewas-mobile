import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/home/components/banner_carousal.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/modules/product/components/bidding_table.dart';
import 'package:simple_ui/modules/product/components/rejectBidding_btn.dart';
import 'package:simple_ui/modules/product/components/timer_widget.dart';
import 'package:simple_ui/modules/product/product_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class ProductBiddingScreen extends StatefulWidget {
  final InventoryModel productModel;
  final int? orderIndex;
  final OrderModel? order;
  ProductBiddingScreen(
      {required this.productModel, this.order, this.orderIndex});
  @override
  _ProductBiddingScreenState createState() => _ProductBiddingScreenState();
}

class _ProductBiddingScreenState extends State<ProductBiddingScreen> {
  @override
  void initState() {
    super.initState();
    var controller = Get.put(ProductController());
    controller.getBiddingDetails(
        orderStatus: widget.order!.orderStatus,
        orderId: widget.productModel.orderId,
        dateTime: DateTime.parse(widget.productModel.dateAndTime!));
  }

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    final AllOrderController orderController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: AppBarButton(),
        actions: [
          widget.orderIndex != null
              ? Obx(() {
                  return Get.find<MainScreenController>().user?.roles?[0] ==
                              UserRole.seller &&
                          orderController
                                  .filteredOrdersUnderAuction[
                                      widget.orderIndex!]
                                  .orderStatus ==
                              OrderStatus.biddingInProgress
                      ? GetBuilder<ProductController>(
                          builder: (productController) {
                          return Container(
                            margin: EdgeInsets.only(right: 16.w),
                            width: 155.w,
                            height: 40.h,
                            child: productController.isBiddingRejecting
                                ? RejectBiddingButton(
                                    buttonChild: SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    onTap: () {},
                                    isBtnActive:
                                        productController.remainingDatetime ==
                                            Duration.zero,
                                  )
                                : RejectBiddingButton2(
                                    buttonText: 'Reject Bidding',
                                    onTap: productController
                                                .remainingDatetime ==
                                            Duration.zero
                                        ? () async {
                                            productController
                                                .isBiddingRejecting = true;
                                            productController.update();
                                            await productController
                                                .updateOrderStatus(
                                                    orderId: widget.order!.eid!,
                                                    orderStatus: OrderStatus
                                                        .biddingRejected);
                                            productController
                                                .isBiddingRejecting = false;
                                            productController.update();
                                          }
                                        : () {},
                                    isBtnActive:
                                        productController.remainingDatetime ==
                                            Duration.zero,
                                  ),
                          );
                        })
                      : SizedBox();
                })
              : SizedBox()
        ],
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
                                          enabletimer: (widget
                                                      .order!.orderStatus ==
                                                  OrderStatus.biddingStarted ||
                                              widget.order!.orderStatus ==
                                                  OrderStatus
                                                      .biddingInProgress),
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
                                    text:
                                        "${widget.order!.firstName} ${widget.order!.lastName}",
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
                                BricolageText(
                                  text:
                                      "₹ ${productController.highestPrice.value}",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                )
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
                                                          order: widget.order,
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
