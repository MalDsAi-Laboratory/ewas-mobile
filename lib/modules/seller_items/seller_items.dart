import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/categories/categories.dart';
import 'package:simple_ui/modules/orders/components/all_order_page_components.dart';
import 'package:simple_ui/modules/orders/components/filters_bottom_sheet.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/product/product_bidding_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SellerItemsScreen extends StatefulWidget {
  @override
  State<SellerItemsScreen> createState() => _SellerItemsScreenState();
}

class _SellerItemsScreenState extends State<SellerItemsScreen> {
  @override
  Widget build(BuildContext context) {
    AllOrderController orderController = Get.find<AllOrderController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBarButton(),
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
                      showFilterBottomSheet(context, useAllOrders: false);
                      ;
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => CategoriesPage()),
        backgroundColor: AppColors.primaryColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "List Item",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
      return orderController.isOrdersLoading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : orderController.filteredOrdersUnderAuction.isEmpty
              ? Center(child: Text("No $orderType Orders"))
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: orderController.filteredOrdersUnderAuction.length,
                  itemBuilder: (context, index) {
                    final order =
                        orderController.filteredOrdersUnderAuction[index];
                    return InkWell(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      onTap: () {
                        Get.to(() => ProductBiddingScreen(
                            orderIndex: index,
                            order: order,
                            productModel: orderController.inventoryMap[
                                orderController
                                    .filteredOrdersUnderAuction[index].eid!]!));
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
                                  color:
                                      const Color.fromARGB(59, 158, 158, 158),
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
