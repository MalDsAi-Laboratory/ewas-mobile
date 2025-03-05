import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/orders/components/recycler_order_components.dart';
import 'package:simple_ui/modules/product/find_ewaste_controller.dart';
import 'package:simple_ui/modules/product/product_bidding_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class RecyclerOrderPage extends StatefulWidget {
  const RecyclerOrderPage({super.key});

  @override
  State<RecyclerOrderPage> createState() => _RecyclerOrderPageState();
}

class _RecyclerOrderPageState extends State<RecyclerOrderPage> {
  @override
  void initState() {
    super.initState();
    Get.put(FindEwasteController());
    Get.find<FindEwasteController>().fetchProducts(isCategoryTabs: true);
  }

  @override
  Widget build(BuildContext context) {
    FindEwasteController ewasteController = Get.find<FindEwasteController>();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: BricolageText(
            text: "My Orders",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              ewasteController.fetchProducts();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: EwasteList(),
            ),
          ),
        ));
  }
}

class EwasteList extends StatelessWidget {
  const EwasteList({super.key});

  @override
  Widget build(BuildContext context) {
    FindEwasteController ewasteController = Get.find<FindEwasteController>();

    return Obx(() {
      // Loading state
      if (ewasteController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      // Empty state
      if (ewasteController.participatedfilteredInventoryProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BricolageText(
                text: "No ongoing auctions near to you",
                style: TextStyle(fontSize: 15.sp),
              ),
              SizedBox(height: 16.h),
              RetryWidget(
                onTap: ewasteController.fetchProducts,
              )
            ],
          ),
        );
      }
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            ewasteController.participatedfilteredInventoryProducts.length,
        itemBuilder: (context, index) {
          final order = ewasteController.orders.elementAt(index);
          return InkWell(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () {
              Get.to(() => ProductBiddingScreen(
                  productModel:
                      ewasteController.participatedfilteredInventoryProducts[
                          order.eid.toString()]!));
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
                child: ewasteController.isLoading.value &&
                        !ewasteController.participatedfilteredInventoryProducts
                            .containsKey(order.eid.toString())
                    ? ParticipatedEwasteItemWidget(order: order)
                    : ewasteController.participatedfilteredInventoryProducts
                            .containsKey(order.eid.toString())
                        ? ParticipatedEwasteItemWidget(
                            order: order,
                            inventory: ewasteController
                                    .participatedfilteredInventoryProducts[
                                order.eid.toString()],
                          )
                        : ParticipatedEwasteNoImageItemWidget(
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
