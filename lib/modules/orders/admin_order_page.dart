import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/orders/order_screen.dart';
import 'package:simple_ui/modules/orders/components/filters_bottom_sheet.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
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
      body: Obx(
        () => orderController.isOrdersLoading.value
            ? Center(
                child: AppLoadingWidget(),
              )
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: size.width * 0.06,
                            border: TableBorder(
                                top:
                                    BorderSide(width: 0.2, color: Colors.grey)),
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
                                constraints:
                                    BoxConstraints(minWidth: size.width * 0.3),
                                child: BricolageText(
                                    text: "Order ID",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp)),
                              )),
                              DataColumn(
                                  label: Container(
                                constraints:
                                    BoxConstraints(minWidth: size.width * 0.22),
                                child: BricolageText(
                                    text: "Status",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp)),
                              )),
                              DataColumn(
                                  label: Container(
                                constraints:
                                    BoxConstraints(minWidth: size.width * 0.2),
                                child: BricolageText(
                                    text: "Assignee",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp)),
                              )),
                            ],
                            rows: orderController.filteredOrders
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key + 1; // Index starts from 1
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
                                  showOrderDetailScreen(context, entry.key);
                                }),
                                DataCell(
                                    BricolageText(
                                      text: order.eid ?? "",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500),
                                    ), onTap: () {
                                  showOrderDetailScreen(context, entry.key);
                                }),
                                DataCell(
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                            order.orderStatus ?? ""),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: BricolageText(
                                        text: order.orderStatus ?? "No Order",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ), onTap: () {
                                  showOrderDetailScreen(context, entry.key);
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
                                  showOrderDetailScreen(context, entry.key);
                                }),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
