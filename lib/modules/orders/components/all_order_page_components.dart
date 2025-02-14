import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class StatusWidget extends StatelessWidget {
  final OrderModel order;
  const StatusWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return order.productImagePath != null
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
                text: "${order.orderStatus}",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(order.orderStatus ?? "")),
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
                text: "${order.orderStatus}",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(order.orderStatus ?? "")),
              ),
            ],
          );
  }
}

class OrderDateWidget extends StatelessWidget {
  final OrderModel order;

  const OrderDateWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return order.productImagePath != null
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

class NoImageItemWidget extends StatelessWidget {
  final OrderModel order;
  const NoImageItemWidget({super.key, required this.order});

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
              child: StatusWidget(
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
              child: OrderDateWidget(
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

class OrderItemWidget extends StatelessWidget {
  final OrderModel order;
  const OrderItemWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: CachedNetworkImage(
            imageUrl: order.productImagePath ?? "",
            width: 100.w,
            height: 100.w,
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              StatusWidget(
                order: order,
              ),
              SizedBox(height: 10.h),
              OrderDateWidget(
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
