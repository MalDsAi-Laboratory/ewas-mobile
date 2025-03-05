import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/updatePrice/components/custom_expansion_tile.dart';
import 'package:simple_ui/modules/updatePrice/components/update_price_appbar.dart';
import 'package:simple_ui/modules/updatePrice/update_price_controller.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';

class UpdatePriceScreen extends StatefulWidget {
  final bool? isAccessFromBottomTab;
  UpdatePriceScreen({this.isAccessFromBottomTab = false});

  @override
  State<UpdatePriceScreen> createState() => _UpdatePriceScreenState();
}

class _UpdatePriceScreenState extends State<UpdatePriceScreen> {
  @override
  void dispose() {
    super.dispose();
    UpdatePriceController controller = Get.find<UpdatePriceController>();
    controller.searchController.clear();
    controller.filteredSubCategories.assignAll(controller.allSubCategories);
  }

  @override
  Widget build(BuildContext context) {
    UpdatePriceController controller = Get.find<UpdatePriceController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UpdatePriceAppBar(
        isAccessFromBottomTab: widget.isAccessFromBottomTab,
      ),
      body: Obx(
        () => controller.isProductsPricingLoading.value
            ? Center(
                child: AppLoadingWidget(),
              )
            : ListView.builder(
                itemCount: controller.filteredSubCategories.length,
                itemBuilder: (context, index) {
                  final category =
                      controller.filteredSubCategories.keys.elementAt(index);
                  final productsWithPrice =
                      controller.filteredSubCategories.values.elementAt(index);

                  return CustomExpansionTile(
                      title: category,
                      index: index,
                      productsWithPrice: productsWithPrice);
                },
              ),
      ),
    );
  }
}

showUpdatePricingRestrictedLoadingDialog(context) {
  showDialog(
      barrierColor: const Color.fromARGB(64, 0, 0, 0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder<UpdatePriceController>(builder: (controller) {
          return PopScope(
              canPop: controller.isUpdatingPrices.value,
              child: Center(child: AppLoadingWidget()));
        });
      });
}
