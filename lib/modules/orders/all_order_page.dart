import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/orders/components/all_order_page_components.dart';
import 'package:simple_ui/modules/orders/components/filters_bottom_sheet.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/order_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AllOrderScreen extends StatefulWidget {
  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  @override
  Widget build(BuildContext context) {
    AllOrderController orderController = Get.find<AllOrderController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => Badge(
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
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: BricolageText(
          text: "My Orders",
          style: TextStyle(fontSize: 18.sp, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            orderController.fetchOrders();
          },
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
      if (orderController.isOrdersLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (orderController.filteredOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BricolageText(
                text: "No $orderType Orders",
                style: TextStyle(fontSize: 15.sp),
              ),
              SizedBox(height: 16.h),
              RetryWidget(
                onTap: orderController.fetchOrders,
              )
            ],
          ),
        );
      }

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
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
                child: orderController.isInventoryLoading.value &&
                        !orderController.inventoryMap
                            .containsKey(order.eid.toString())
                    ? OrderItemWidget(order: order)
                    : orderController.inventoryMap
                            .containsKey(order.eid.toString())
                        ? OrderItemWidget(order: order)
                        : NoImageItemWidget(order: order),
              ),
            ),
          );
        },
      );
    });
  }
}
