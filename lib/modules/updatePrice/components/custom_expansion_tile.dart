import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/sub_category_model.dart';
import 'package:simple_ui/modules/updatePrice/update_price_controller.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CustomExpansionTile extends StatefulWidget {
  final int index;
  final String title;
  final Map<String, Map<SubCategoryModel, double>> productsWithPrice;
  const CustomExpansionTile({
    super.key,
    required this.index,
    required this.title,
    required this.productsWithPrice,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isExpanded
                ? Colors.white
                : (widget.index % 2 == 0
                    ? const Color.fromRGBO(247, 247, 247, 1.0)
                    : Colors.white),
            borderRadius: widget.index == 0
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r))
                : widget.index == 8
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r))
                    : BorderRadius.zero,
          ),
          margin: EdgeInsets.only(bottom: 4.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                child: Row(
                  children: [
                    BricolageText(
                      text: widget.title,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.productsWithPrice.entries.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ProductItemWidget(
                                price: widget.productsWithPrice.entries
                                    .elementAt(index)
                                    .value
                                    .entries
                                    .first
                                    .value
                                    .toString(),
                                productModel: widget.productsWithPrice.entries
                                    .elementAt(index)
                                    .value
                                    .entries
                                    .first
                                    .key,
                              ),
                              index != widget.productsWithPrice.length - 1
                                  ? SizedBox(
                                      height: 15.h,
                                    )
                                  : SizedBox()
                            ],
                          );
                        })
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final SubCategoryModel productModel;
  final String price;
  const ProductItemWidget({
    super.key,
    required this.productModel,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    UpdatePriceController controller = Get.find<UpdatePriceController>();
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: CachedNetworkImage(
            imageUrl: productModel.imagePath ?? "",
            width: 100.w,
            height: 100.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BricolageText(
                  text: productModel.productName ?? "",
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 101, 101, 101))),
              SizedBox(height: 10.h),
              Obx(() {
                return CustomTextFieldWithLightBorder(
                  height: 55.h,
                  hintText: "Enter your price",
                  initialValue: controller
                      .textControllers[productModel.category]![
                          productModel.productId.toString()]!
                      .text,
                  onChanged: (val) {
                    String category = productModel.category ?? "";
                    if (controller.actualTextControllers[category] != null) {
                      bool found = controller.actualTextControllers[category]![
                              productModel.productId.toString()] ==
                          null;
                      if (!found) {
                        controller.actualTextControllers[category] = {
                          productModel.productId.toString(): controller
                                  .textControllers[productModel.category]![
                              productModel.productId.toString()]!
                            ..text = val
                        };
                        controller.update();
                      }
                    } else {
                      controller.actualTextControllers[category] = {
                        productModel.productId.toString():
                            controller.textControllers[productModel.category]![
                                productModel.productId.toString()]!
                              ..text = val
                      };
                      controller.update();
                    }
                  },
                  // initialValue: controller.userId.value,
                  icon: Icon(
                    Icons.currency_rupee,
                    size: 20.r,
                    color: Colors.grey,
                  ),
                  keyboardType: TextInputType.text,
                );
              }),
              BricolageText(
                  text: "/${productModel.scale ?? ""} ${productModel.units}"),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ],
    );
  }
}
