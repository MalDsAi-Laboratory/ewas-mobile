import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/orders/components/filters_bottom_sheet.dart';
import 'package:simple_ui/modules/orders/order_controller.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

// Admin Order Screen with Sidebar Filters
class AdminOrderScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
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
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: size.width * 0.06,
                    border: TableBorder(
                        top: BorderSide(width: 0.2, color: Colors.grey)),
                    columns: [
                      DataColumn(
                        label: Container(
                          constraints:
                              BoxConstraints(minWidth: size.width * 0.08),
                          child: BricolageText(
                            text: "#",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp),
                          ),
                        ),
                      ),
                      DataColumn(
                          label: Container(
                        constraints: BoxConstraints(minWidth: size.width * 0.2),
                        child: BricolageText(
                            text: "Order ID",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      )),
                      DataColumn(
                          label: Container(
                        constraints:
                            BoxConstraints(minWidth: size.width * 0.22),
                        child: BricolageText(
                            text: "Status",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      )),
                      DataColumn(
                          label: Container(
                        constraints: BoxConstraints(minWidth: size.width * 0.2),
                        child: BricolageText(
                            text: "Assignee",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      )),
                    ],
                    rows: orderController.filteredOrders
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key + 1; // Index starts from 1
                      Order order = entry.value;
                      return DataRow(cells: [
                        DataCell(BricolageText(
                          text: index.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w500),
                        )),
                        DataCell(BricolageText(
                          text: order.eid ?? "",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.orderStatus!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: BricolageText(
                              text: order.orderStatus!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        DataCell(SizedBox(
                          width: 130.w,
                          child: BricolageText(
                            text: order.assignee!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w500),
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Shipped":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
