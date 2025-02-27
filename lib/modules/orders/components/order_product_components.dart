import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class OrderProductComponent extends StatelessWidget {
  final InventoryModel inventoryModel;
  const OrderProductComponent({super.key, required this.inventoryModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: inventoryModel.imgPath1 ?? "",
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
            )),
        SizedBox(
          width: 15.w,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BricolageText(
            text: inventoryModel.productName ?? "",
            style: TextStyle(
              fontSize: 15.sp,
            ),
          ),
          BricolageText(
            text: inventoryModel.volume != null
                ? "Volume: ${inventoryModel.volume}"
                : "",
            style: TextStyle(
                fontSize: 14.sp,
                color: const Color.fromARGB(255, 105, 105, 105)),
          ),
        ])
      ],
    );
  }
}
