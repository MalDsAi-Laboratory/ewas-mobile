import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/product/components/find_ewaste_orders.dart';
import 'package:simple_ui/modules/product/find_ewaste_controller.dart';
import 'package:simple_ui/modules/product/components/find_ewaste_appbar.dart';
import 'package:simple_ui/modules/product/product_bidding_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class FindEwasteScreen extends StatefulWidget {
  const FindEwasteScreen({super.key});

  @override
  State<FindEwasteScreen> createState() => _FindEwasteScreenState();
}

class _FindEwasteScreenState extends State<FindEwasteScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(FindEwasteController());
    Get.find<FindEwasteController>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    FindEwasteController ewasteController = Get.find<FindEwasteController>();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AllProductsAppBar(),
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              ewasteController.fetchProducts(isRefreshed: true);
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
          child: AppLoadingWidget(),
        );
      }

      // Empty state
      if (ewasteController.filteredInventoryProducts.isEmpty) {
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
        itemCount: ewasteController.filteredInventoryProducts.length,
        itemBuilder: (context, index) {
          final order = ewasteController.orders.elementAt(index);
          return InkWell(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () {
              Get.to(() => ProductBiddingScreen(
                  order: order,
                  productModel: ewasteController
                      .filteredInventoryProducts[order.eid.toString()]!));
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
                        !ewasteController.filteredInventoryProducts
                            .containsKey(order.eid.toString())
                    ? EwasteItemWidget(order: order)
                    : ewasteController.filteredInventoryProducts
                            .containsKey(order.eid.toString())
                        ? EwasteItemWidget(
                            order: order,
                            inventory:
                                ewasteController.filteredInventoryProducts[
                                    order.eid.toString()],
                          )
                        : EwasteNoImageItemWidget(
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
