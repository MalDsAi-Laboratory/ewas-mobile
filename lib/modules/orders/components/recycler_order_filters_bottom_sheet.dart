// Sidebar Filter UI
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/product/find_ewaste_controller.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

showRecyclerFilterBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
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
  OrderFiltersWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(bottom: 12.h, left: 12.w, right: 12.w),
        child: GetBuilder<FindEwasteController>(builder: (orderController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                label: "Filter by Product Name",
                hintText: "eg: Plastic Bottle",
                initialValue: orderController.productNameSearch.value,
                icon: Icons.search,
                onChanged: (value) {
                  orderController.productNameSearch.value = value;

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
}
