import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/product_model.dart';
import 'package:simple_ui/modules/product/all_product_controller.dart';
import 'package:simple_ui/modules/product/components/all_product_appbar.dart';
import 'package:simple_ui/modules/product/product_bidding_screen.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(AllProductController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AllProductsAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              GetBuilder<AllProductController>(builder: (controller) {
                return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.8),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductItem(
                          product: controller.filteredProducts[index]);
                    });
              })
            ],
          ),
        ),
      ),
    );
  }
}

// Widget to display each category card
class ProductItem extends StatelessWidget {
  final ProductModel product;
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
                    imageUrl: product.imagePath ?? "",
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
