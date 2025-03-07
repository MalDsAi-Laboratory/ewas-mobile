import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/cart/cart_controller.dart';
import 'package:simple_ui/modules/cart/components/cart_components.dart';
import 'package:simple_ui/modules/cart/components/cart_order_view.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.find<CartController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: BricolageText(
          text: "Cart Orders",
          style: TextStyle(fontSize: 18.sp, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            cartController.pollOrderStatusAndUpdateCart();
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
  final CartController cartController = Get.find<CartController>();

  OrderList({required this.orderType});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cartController.isCartProductsLoading.value) {
        return Center(child: AppLoadingWidget());
      }

      if (cartController.inventoryMap.isEmpty) {
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
                onTap: cartController.pollOrderStatusAndUpdateCart,
              )
            ],
          ),
        );
      }

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: cartController.orders.length,
        itemBuilder: (context, index) {
          final order = cartController.orders[index];
          return InkWell(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () {
              showCartOrderDetailScreen(context, index);
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
                child: cartController.isCartProductsLoading.value &&
                        !cartController.inventoryMap
                            .containsKey(order.eid.toString())
                    ? CartOrderItemWidget(order: order)
                    : cartController.inventoryMap
                            .containsKey(order.eid.toString())
                        ? CartOrderItemWidget(order: order)
                        : CartNoImageItemWidget(order: order),
              ),
            ),
          );
        },
      );
    });
  }
}
