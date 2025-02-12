import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_ui/modules/orders/components/filters_bottom_sheet.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
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
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GetBuilder<AllOrderController>(builder: (orderController) {
                return Badge(
                  isLabelVisible:
                      orderController.filterCount == 0 ? false : true,
                  smallSize: 10,
                  backgroundColor: AppColors.primaryColor,
                  child: SizedBox(
                    width: 30.r,
                    height: 30.r,
                    child: TextButton.icon(
                      onPressed: () {
                        showFilterBottomSheet(context);
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      label: Icon(
                        Icons.filter_list_outlined,
                        color: Colors.black,
                        size: 25.r,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: BricolageText(
            text: "My Orders",
            style: TextStyle(fontSize: 20.sp, color: Colors.black87),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: OrderList(orderType: "Ongoing"),
          ),
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
      return orderController.filteredOrders.isEmpty
          ? Center(child: Text("No $orderType Orders"))
          : ListView.builder(
              itemCount: orderController.filteredOrders.length,
              itemBuilder: (context, index) {
                final order = orderController.filteredOrders[index];
                return InkWell(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () {
                    showOrderDetailScreen(context, index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                            color: const Color.fromARGB(255, 168, 168, 168),
                            width: 0.3.w),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.0.h)),
                        ]),
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BricolageText(
                              text: "ID: ${order.eid}",
                              style: TextStyle(fontSize: 14.sp)),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BricolageText(
                                      text: "Status",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color.fromARGB(
                                            255, 101, 101, 101),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    BricolageText(
                                      textAlign: TextAlign.left,
                                      text: "${order.orderStatus}",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: getStatusColor(
                                              order.orderStatus ?? "")),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1.w, // Thin vertical line
                                height: 40.h, // Adjust height as needed
                                color: const Color.fromARGB(
                                    255, 226, 226, 226), // Divider color
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w), // Space around divider
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
    });
  }
}
