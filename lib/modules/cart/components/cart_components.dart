import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/cart/cart_controller.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/shimmer_effects.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CartStatusWidget extends StatelessWidget {
  final OrderModel order;
  const CartStatusWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    CartController controller = Get.find<CartController>();

    return Obx(
      () => controller.isCartProductsLoading.value &&
              !controller.inventoryMap.containsKey(order.eid.toString())
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BricolageText(
                  text: "Status",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color.fromARGB(255, 101, 101, 101),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                BricolageText(
                  textAlign: TextAlign.left,
                  text: order.orderStatus?.value ?? '',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: getStatusColor(order.orderStatus)),
                ),
              ],
            )
          : controller.inventoryMap.containsKey(order.eid.toString())
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BricolageText(
                      text: "Status",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color.fromARGB(255, 101, 101, 101),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    BricolageText(
                      textAlign: TextAlign.left,
                      text: order.orderStatus?.value ?? '',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: getStatusColor(order.orderStatus)),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BricolageText(
                      text: "Status",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color.fromARGB(255, 101, 101, 101),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    BricolageText(
                      textAlign: TextAlign.left,
                      text: order.orderStatus?.value ?? '',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: getStatusColor(order.orderStatus)),
                    ),
                  ],
                ),
    );
  }
}

class CartOrderDateWidget extends StatelessWidget {
  final OrderModel order;

  const CartOrderDateWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    CartController controller = Get.find<CartController>();

    return controller.isCartProductsLoading.value &&
            !controller.inventoryMap.containsKey(order.eid.toString())
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BricolageText(
                text: "Order Date",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color.fromARGB(255, 101, 101, 101),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              BricolageText(
                text:
                    "${DateFormat.yMMMd().format(order.orderDate ?? DateTime.now())}",
                style: TextStyle(fontSize: 15.sp),
              ),
            ],
          )
        : controller.inventoryMap.containsKey(order.eid.toString())
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BricolageText(
                    text: "Order Date",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 101, 101, 101),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  BricolageText(
                    text:
                        "${DateFormat.yMMMd().format(order.orderDate ?? DateTime.now())}",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BricolageText(
                    text: "Order Date",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 101, 101, 101),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  BricolageText(
                    text:
                        "${DateFormat.yMMMd().format(order.orderDate ?? DateTime.now())}",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              );
  }
}

class CartNoImageItemWidget extends StatelessWidget {
  final OrderModel order;
  const CartNoImageItemWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BricolageText(
            text: "ID: ${order.eid}", style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CartStatusWidget(
                order: order,
              ),
            ),
            Container(
              width: 1.w, // Thin vertical line
              height: 40.h, // Adjust height as needed
              color: const Color.fromARGB(255, 226, 226, 226), // Divider color
              margin:
                  EdgeInsets.symmetric(horizontal: 8.w), // Space around divider
            ),
            Expanded(
              child: CartOrderDateWidget(
                order: order,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class CartOrderItemWidget extends StatelessWidget {
  final OrderModel order;
  const CartOrderItemWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    CartController controller = Get.find<CartController>();
    return Row(
      children: [
        Obx(
          () => controller.isCartProductsLoading.value &&
                  !controller.inventoryMap.containsKey(order.eid.toString())
              ? CustomShimmer(height: 100.w, width: 100.w)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Image.file(
                    controller.inventoryMap[order.eid.toString()]!.imgPath1!,
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BricolageText(
                      text: "ID",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 101, 101, 101))),
                  SizedBox(
                    width: 5.w,
                  ),
                  BricolageText(
                      text: "${order.eid} ", style: TextStyle(fontSize: 14.sp)),
                ],
              ),
              SizedBox(height: 10.h),
              CartStatusWidget(
                order: order,
              ),
              SizedBox(height: 10.h),
              CartOrderDateWidget(
                order: order,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ],
    );
  }
}
