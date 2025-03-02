import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/updatePrice/components/custom_expansion_tile.dart';
import 'package:simple_ui/modules/updatePrice/update_price_controller.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class UpdatePriceScreen extends StatefulWidget {
  @override
  _UpdatePriceScreenState createState() => _UpdatePriceScreenState();
}

class _UpdatePriceScreenState extends State<UpdatePriceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UpdatePriceController controller = Get.find<UpdatePriceController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: BricolageText(
          text: "Update Price",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        surfaceTintColor: Colors.white,
        leading: AppBarButton(),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Obx(
                () => AppBarButton(
                  onTap: controller.isProductsPricingLoading.value
                      ? () {}
                      : controller.handleSubmit,
                  iconData: Icons.check,
                  iconColor: AppColors.primaryColor,
                ),
              )),
        ],
      ),
      body: Obx(
        () => controller.isProductsPricingLoading.value
            ? Center(
                child: AppLoadingWidget(),
              )
            : ListView.builder(
                itemCount: controller.allSubCategories.length,
                itemBuilder: (context, index) {
                  final category =
                      controller.allSubCategories.keys.elementAt(index);
                  final productsWithPrice =
                      controller.allSubCategories.values.elementAt(index);

                  return CustomExpansionTile(
                      title: category,
                      index: index,
                      productsWithPrice: productsWithPrice);
                },
              ),
      ),
    );
  }

//   Widget _buildProductItem(SubCategoryModel product) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               // Product Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image.network(
//                   product.imagePath ?? '',
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: 80,
//                     height: 80,
//                     color: Colors.grey[300],
//                     child: Icon(Icons.image_not_supported),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               // Product Details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.productName ?? 'Unknown Product',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       product.materialDetails ?? 'No details available',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     // Price TextField
//                     TextField(
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Price',
//                         border: OutlineInputBorder(),
//                         prefixText: '\$',
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           if (value.isNotEmpty) {
//                             try {
//                               product.price = double.parse(value);
//                             } catch (e) {
//                               // Handle invalid input
//                             }
//                           } else {
//                             product.price = 0.0;
//                           }
//                         });
//                       },
//                       controller:
//                           TextEditingController(text: product.price.toString()),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Divider(height: 24),
//         ],
//       ),
//     );
//   }
}
