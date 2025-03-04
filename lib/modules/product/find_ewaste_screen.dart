import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/modules/product/components/find_ewaste_orders.dart';
import 'package:simple_ui/modules/product/find_ewaste_controller.dart';
import 'package:simple_ui/modules/product/components/find_ewaste_appbar.dart';
import 'package:simple_ui/modules/product/product_bidding_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
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
      return ewasteController.isLoading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ewasteController.filteredInventoryProducts.isEmpty
              ? Center(child: Text("No nearby orders right now"))
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: ewasteController.filteredInventoryProducts.length,
                  itemBuilder: (context, index) {
                    final order = ewasteController.orders.elementAt(index);
                    return InkWell(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      onTap: () {
                        Get.to(() => ProductBiddingScreen(
                            productModel:
                                ewasteController.filteredInventoryProducts[
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
                                  color:
                                      const Color.fromARGB(59, 158, 158, 158),
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
                                  ? EwasteItemWidget(order: order)
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

// Widget to display each category card
class ProductItem extends StatelessWidget {
  final InventoryModel product;
  const ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor:
          WidgetStateProperty.all(const Color.fromARGB(0, 92, 92, 92)),
      borderRadius: BorderRadius.circular(25.r),
      onTap: () {
        Get.to(() => ProductBiddingScreen(productModel: product));
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 8.h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                  child: CachedNetworkImage(
                    imageUrl: product.imgPath1 ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: BricolageText(
                text: product.productName ?? "",
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 8.h,
            )
          ],
        ),
      ),
    );
  }
}
