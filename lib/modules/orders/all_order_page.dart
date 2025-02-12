import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AllOrderScreen extends StatelessWidget {
  final AllOrderController orderController = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: BricolageText(
            text: "My Orders",
            style: TextStyle(fontSize: 20.sp, color: Colors.black87),
          ),
        ),
        body: SafeArea(
          child: OrderList(orderType: "Ongoing"),
        ),
      ),
    );
  }
}

// Order List Widget
class OrderList extends StatelessWidget {
  final String orderType;
  final AllOrderController orderController = Get.find();

  OrderList({required this.orderType});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return orderController.orders.isEmpty
          ? Center(child: Text("No $orderType Orders"))
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: orderController.orders.length,
              itemBuilder: (context, index) {
                final order = orderController.orders[index];
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                          color: const Color.fromARGB(255, 168, 168, 168),
                          width: 0.3),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2.0)),
                      ]),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: BricolageText(
                                  textAlign: TextAlign.start,
                                  text: "${order.firstName} ${order.lastName}",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(width: 5.w),
                            BricolageText(
                                text: "ID: ${order.eid}",
                                style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        BricolageText(
                            text: "Address",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color.fromARGB(255, 101, 101, 101),
                                fontWeight: FontWeight.w500)),
                        BricolageText(
                            text: "${order.address}",
                            style: TextStyle(fontSize: 15.sp)),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BricolageText(
                                    text: "Assignee",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: const Color.fromARGB(
                                          255, 101, 101, 101),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  BricolageText(
                                    textAlign: TextAlign.left,
                                    text: "${order.assignee}",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1, // Thin vertical line
                              height: 40, // Adjust height as needed
                              color: const Color.fromARGB(
                                  255, 226, 226, 226), // Divider color
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8), // Space around divider
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BricolageText(
                                    text: "Order Date",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: const Color.fromARGB(
                                          255, 101, 101, 101),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  BricolageText(
                                    text:
                                        "${DateFormat.yMMMd().format(order.orderDate ?? DateTime.now())}",
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BricolageText(
                              text: "Email",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color.fromARGB(255, 101, 101, 101),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            BricolageText(
                              textAlign: TextAlign.left,
                              text: "${order.emailId}",
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
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
                                  color:
                                      getStatusColor(order.orderStatus ?? "")),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BricolageText(
                              text: "Details",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color.fromARGB(255, 101, 101, 101),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            BricolageText(
                              textAlign: TextAlign.left,
                              text: "${order.orderDetails}",
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }
}
