// Sidebar Filter UI
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/orders/order_controller.dart';
import 'package:simple_ui/ui_utils/dropdown_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

showFilterBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // showDragHandle: true,
    backgroundColor: Colors.white,
    sheetAnimationStyle: AnimationStyle(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 100),
    ),
    builder: (context) {
      return OrderFiltersWidget();
    },
  );
}

class OrderFiltersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(12.0),
        child: GetBuilder<OrderController>(builder: (orderController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(Icons.filter_list_rounded, size: 25.r),
                  SizedBox(
                    width: 10.w,
                  ),
                  BricolageText(
                      text: "Filters",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(height: 30.h),
              _buildFilterField(
                label: "Filter by ID",
                hintText: "eg: EWS00002",
                initialValue: orderController.searchId.value,
                icon: Icons.search,
                onChanged: (value) {
                  orderController.searchId.value = value;
                  orderController.filterOrders();
                },
              ),
              SizedBox(height: 20.h),
              _buildFilterField(
                label: "Filter by Assignee",
                hintText: "eg. Rahul",
                initialValue: orderController.searchAssignee.value,
                icon: Icons.person,
                onChanged: (value) {
                  orderController.searchAssignee.value = value;
                  orderController.filterOrders();
                },
              ),
              SizedBox(height: 20.h),
              _buildDropdownFilter(
                label: "Filter by Status",
                value: orderController.selectedStatus.value.isEmpty
                    ? "All"
                    : orderController.selectedStatus.value,
                items: ["All", "Pending", "Shipped", "Delivered"],
                onChanged: (value) {
                  orderController.selectedStatus.value = value ?? '';
                  orderController.filterOrders();
                },
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        orderController.clearFilters();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(0, 242, 242, 242)),
                      child: BricolageText(
                        text: "Clear Filters",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFilterField(
      {required String label,
      required String hintText,
      required String initialValue,
      required IconData icon,
      required Function(String) onChanged}) {
    return CustomFieldWithleadingAndActionIcon(
      FieldName: label,
      hintText: hintText,
      onChanged: onChanged,
      initialValue: initialValue,
      borderRadius: 100,
    );
  }

  Widget _buildDropdownFilter(
      {required String label,
      String? value,
      required List<String> items,
      required void Function(dynamic)? onChanged}) {
    return DropDownWidget(
      value: value,
      fieldName: "Filter by Status",
      dropDownItems: items.map((status) {
        return DropdownMenuItem(
            value: status,
            child: BricolageText(
              text: status,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: const Color.fromARGB(255, 0, 0, 0)),
            ));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
