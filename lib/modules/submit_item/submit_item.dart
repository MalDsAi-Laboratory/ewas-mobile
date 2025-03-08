import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/submit_item/components/image_widget.dart';
import 'package:simple_ui/modules/submit_item/submit_item_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SubmitItemPage extends StatelessWidget {
  final bool? willGoUnderAuction;
  const SubmitItemPage({super.key, this.willGoUnderAuction = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubmitItemController>(
        init: SubmitItemController(),
        builder: (controller) {
          return PopScope(
            canPop: controller.isOrderCreated,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                leading: AppBarButton(),
                title: BricolageText(
                  text: 'Sell your E-waste',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SubmitItemComponent(
                    willGoUnderAuction: willGoUnderAuction!,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class SubmitItemComponent extends StatelessWidget {
  final bool willGoUnderAuction;
  const SubmitItemComponent({super.key, required this.willGoUnderAuction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                BricolageText(
                  text: "Approximate volume of scrap",
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                GetBuilder<SubmitItemController>(builder: (controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.volumeController,
                              onChanged: (value) {
                                controller.update();
                              },
                              style: TextStyle(fontSize: 14.sp),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.balance_outlined,
                                  size: 23.r,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.r)),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 232, 232, 232),
                                        width: 0)),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.r)),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 232, 232, 232),
                                        width: 0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.r)),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(0, 255, 255, 255),
                                        width: 0)),
                                hintText: "eg. 100",
                                hintStyle: GoogleFonts.bricolageGrotesque(
                                    textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color:
                                      const Color.fromARGB(255, 111, 111, 111),
                                  fontWeight: FontWeight.w400,
                                )),
                                // contentPadding: EdgeInsets.only(bottom: 13.h, left: 19.w),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 19.w, vertical: 16.h),
                                filled: true,
                                fillColor: Color.fromRGBO(244, 244, 244, 1.0),
                              ),
                            ),
                          ),
                          GetBuilder<CategoriesController>(
                              builder: (categoriesController) {
                            return Row(
                              children: [
                                SizedBox(width: 10.w),
                                Container(
                                  height: 50,
                                  child: Center(
                                    child: BricolageText(
                                        style: TextStyle(),
                                        text: categoriesController
                                                .selectedSubCategory!.units ??
                                            ""),
                                  ),
                                )
                              ],
                            );
                          }),
                        ],
                      ),
                      willGoUnderAuction
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                BricolageText(
                                  text: "Minimum base price",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                                TextFormField(
                                  controller: controller.basePriceController,
                                  onChanged: (value) {
                                    controller.update();
                                  },
                                  style: TextStyle(fontSize: 14.sp),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.currency_rupee_sharp,
                                      size: 23.r,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.r)),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 232, 232, 232),
                                            width: 0)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.r)),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 232, 232, 232),
                                            width: 0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.r)),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                0, 255, 255, 255),
                                            width: 0)),
                                    hintText: "100",
                                    hintStyle: GoogleFonts.bricolageGrotesque(
                                        textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: const Color.fromARGB(
                                          255, 111, 111, 111),
                                      fontWeight: FontWeight.w400,
                                    )),
                                    // contentPadding: EdgeInsets.only(bottom: 13.h, left: 19.w),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 19.w, vertical: 16.h),
                                    filled: true,
                                    fillColor:
                                        Color.fromRGBO(244, 244, 244, 1.0),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  );
                }),
                SizedBox(
                  height: 20.h,
                ),
                BricolageText(
                  text: "Image Upload*",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                BricolageText(
                  text:
                      "1. Upload images of your scrap justifying the volume.\n2. You can upload upto 5 images of your scrap.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(221, 98, 98, 98)),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ImagePickerWidget()
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child:
                      GetBuilder<SubmitItemController>(builder: (controller) {
                    return RadialGradientButton(
                      buttonText: 'Submit',
                      onTap: () {
                        controller.submitProduct(
                            context, willGoUnderAuction, false);
                      },
                      isBtnActive:
                          controller.volumeController.text.trim().isNotEmpty &&
                              (willGoUnderAuction
                                  ? controller.basePriceController.text
                                      .trim()
                                      .isNotEmpty
                                  : true) &&
                              controller.images.isNotEmpty,
                    );
                  }),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child:
                      GetBuilder<SubmitItemController>(builder: (controller) {
                    return RadialGradientButton(
                      buttonText: 'Scrape Cart',
                      onTap: () {
                        controller.submitProduct(
                            context, willGoUnderAuction, true);
                      },
                      isBtnActive:
                          controller.volumeController.text.trim().isNotEmpty &&
                              (willGoUnderAuction
                                  ? controller.basePriceController.text
                                      .trim()
                                      .isNotEmpty
                                  : true) &&
                              controller.images.isNotEmpty,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        )
      ],
    );
  }
}

showOrderRestrictedLoadingDialog(context) {
  showDialog(
      barrierColor: const Color.fromARGB(64, 0, 0, 0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder<SubmitItemController>(builder: (controller) {
          return PopScope(
              canPop: controller.isOrderCreated,
              child: Center(child: AppLoadingWidget()));
        });
      });
}
