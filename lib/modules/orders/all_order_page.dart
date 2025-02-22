import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/orders/components/all_order_page_components.dart';
import 'package:simple_ui/modules/orders/components/filters_bottom_sheet.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AllOrderScreen extends StatefulWidget {
  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  final AllOrderController orderController = Get.put(AllOrderController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<AllOrderController>(force: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GetBuilder<AllOrderController>(builder: (orderController) {
              return Badge(
                isLabelVisible: orderController.filterCount == 0 ? false : true,
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
                              color: const Color.fromARGB(59, 158, 158, 158),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.0.h)),
                        ]),
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: order.productImagePath != null
                          ? OrderItemWidget(order: order)
                          : NoImageItemWidget(
                              order: order,
                            ),
                    ),
                  ),
                );
              },
            );
    });
  }
}
