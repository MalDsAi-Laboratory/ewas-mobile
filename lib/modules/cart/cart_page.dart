import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/modules/cart/cart_controller.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

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
  void dispose() {
    Get.delete<CartController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartController controller = Get.find<CartController>();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: BricolageText(
            text: "Cart",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        body: Obx(
          () => controller.isCartProductsLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.cartProducts.isEmpty
                  ? Center(
                      child: Text("Cart is empty"),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16.w,
                                        mainAxisSpacing: 16.h,
                                        childAspectRatio: 0.8),
                                itemCount: controller.cartProducts.length,
                                itemBuilder: (context, index) {
                                  return ProductItem(
                                      product: controller.cartProducts[index]);
                                })
                          ],
                        ),
                      ),
                    ),
        ));
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
        // Get.to(() => ProductBiddingScreen(productModel: product));
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
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(
                        base64Decode(product.imgPath1 ?? ""),
                      ),
                      fit: BoxFit.cover,
                    ),
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
