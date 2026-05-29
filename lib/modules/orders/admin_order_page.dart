import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/modules/orders/order_screen.dart';
import 'package:simple_ui/modules/orders/components/filters_bottom_sheet.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

// Admin Order Screen with Sidebar Filters
class AdminOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AllOrderController orderController = Get.find<AllOrderController>();

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: BricolageText(
          text: "All Orders",
          style: TextStyle(fontSize: 20.sp, color: Colors.black87),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              showFilterBottomSheet(context);
            },
            label: Icon(
              Icons.filter_list_outlined,
              color: Colors.black,
              size: 25.r,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            orderController.fetchOrders();
          },
          child: Obx(
            () => orderController.isOrdersLoading.value
                ? Center(
                    child: AppLoadingWidget(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: size.width * 0.06,
                                border: TableBorder(
                                    top: BorderSide(
                                        width: 0.2, color: Colors.grey)),
                                columns: [
                                  DataColumn(
                                    label: Container(
                                      constraints: BoxConstraints(
                                          minWidth: size.width * 0.08),
                                      child: BricolageText(
                                        text: "#",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                      label: Container(
                                    constraints: BoxConstraints(
                                        minWidth: size.width * 0.3),
                                    child: BricolageText(
                                        text: "Order ID",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp)),
                                  )),
                                  DataColumn(
                                      label: Container(
                                    constraints: BoxConstraints(
                                        minWidth: size.width * 0.22),
                                    child: BricolageText(
                                        text: "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp)),
                                  )),
                                  DataColumn(
                                      label: Container(
                                    constraints: BoxConstraints(
                                        minWidth: size.width * 0.2),
                                    child: BricolageText(
                                        text: "Assignee",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp)),
                                  )),
                                ],
                                rows: orderController
                                    .paginatedOrders // Using paginatedOrders instead of filteredOrders
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = orderController
                                              .currentPage.value *
                                          orderController.itemsPerPage.value +
                                      entry.key +
                                      1; // Calculate the real index
                                  OrderModel order = entry.value;
                                  return DataRow(cells: [
                                    DataCell(
                                        BricolageText(
                                          text: index.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                        ), onTap: () {
                                      if (order.orderStatus !=
                                          OrderStatus.orderPlaced) {
                                        // Calculate the real index for the filtered orders
                                        int realIndex = orderController
                                            .filteredOrders
                                            .indexOf(order);
                                        showOrderDetailScreen(
                                            context, realIndex);
                                      }
                                    }),
                                    DataCell(
                                        BricolageText(
                                          text: order.eid ?? "",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                        ), onTap: () {
                                      if (order.orderStatus !=
                                          OrderStatus.orderPlaced) {
                                        // Calculate the real index for the filtered orders
                                        int realIndex = orderController
                                            .filteredOrders
                                            .indexOf(order);
                                        showOrderDetailScreen(
                                            context, realIndex);
                                      }
                                    }),
                                    DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: getStatusColor(
                                                order.orderStatus),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: BricolageText(
                                            text:
                                                order.orderStatus?.value ?? "No Order",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ), onTap: () {
                                      if (order.orderStatus !=
                                          OrderStatus.orderPlaced) {
                                        // Calculate the real index for the filtered orders
                                        int realIndex = orderController
                                            .filteredOrders
                                            .indexOf(order);
                                        showOrderDetailScreen(
                                            context, realIndex);
                                      }
                                    }),
                                    DataCell(
                                        SizedBox(
                                          width: 130.w,
                                          child: BricolageText(
                                            text: order.assignee ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ), onTap: () {
                                      if (order.orderStatus !=
                                          OrderStatus.orderPlaced) {
                                        // Calculate the real index for the filtered orders
                                        int realIndex = orderController
                                            .filteredOrders
                                            .indexOf(order);
                                        showOrderDetailScreen(
                                            context, realIndex);
                                      }
                                    }),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        // Pagination controls
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 16.w),
                          child: GetBuilder<AllOrderController>(
                            builder: (controller) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Previous button
                                  SizedBox(
                                    width: 30.w,
                                    height: 30.w,
                                    child: ElevatedButton(
                                      onPressed: controller.hasPrevPage
                                          ? () => controller.prevPage()
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(left: 5.w),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        disabledForegroundColor:
                                            Colors.grey.withOpacity(0.38),
                                        disabledBackgroundColor:
                                            Colors.grey.withOpacity(0.12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                          side:
                                              BorderSide(color: Colors.black12),
                                        ),
                                      ),
                                      child: Icon(Icons.arrow_back_ios,
                                          size: 16.r),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),

                                  // Page info
                                  BricolageText(
                                    text:
                                        'Page ${controller.currentPage.value + 1} of ${controller.totalPages}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),

                                  // Next button
                                  SizedBox(
                                    width: 30.w,
                                    height: 30.w,
                                    child: ElevatedButton(
                                      onPressed: controller.hasNextPage
                                          ? () => controller.nextPage()
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        padding: EdgeInsets.only(left: 4.w),
                                        disabledForegroundColor:
                                            Colors.grey.withOpacity(0.38),
                                        disabledBackgroundColor:
                                            Colors.grey.withOpacity(0.12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                          side:
                                              BorderSide(color: Colors.black12),
                                        ),
                                      ),
                                      child: Icon(Icons.arrow_forward_ios,
                                          size: 16.r),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
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
