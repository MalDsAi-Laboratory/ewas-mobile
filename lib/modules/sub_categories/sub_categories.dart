import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/sub_category_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/locate_recyclers/locate_recylers.dart';
import 'package:simple_ui/modules/sub_categories/components/sub_categories_appbar.dart';
import 'package:simple_ui/modules/submit_item/submit_item.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SubCategoriesPage extends StatefulWidget {
  final bool? isAccessFromBottomTab;
  const SubCategoriesPage({
    Key? key,
    this.isAccessFromBottomTab = false,
  }) : super(key: key);

  @override
  State<SubCategoriesPage> createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  @override
  void initState() {
    super.initState();
    Get.find<CategoriesController>().fetchSubCategories();
  }

  @override
  void dispose() {
    Get.find<CategoriesController>().isSubCategoriesLoading.value = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.find<CategoriesController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SubCategoriesAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(
            () => controller.isSubCategoriesLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CategoriesMainComponent(
                    isAccessFromBottomTab: widget.isAccessFromBottomTab,
                  ),
          ),
        ),
      ),
    );
  }
}

class CategoriesMainComponent extends StatelessWidget {
  final bool? isAccessFromBottomTab;

  const CategoriesMainComponent(
      {super.key, this.isAccessFromBottomTab = false});

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.find<CategoriesController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Categories Grid
          Obx(() => GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.8),
                itemCount: controller
                    .allSubCategories[controller.selectedCategory!.category!]!
                    .length,
                itemBuilder: (context, index) {
                  return SubCategoryCard(
                      isAccessFromBottomTab: isAccessFromBottomTab,
                      category: controller.allSubCategories[
                          controller.selectedCategory!.category!]![index]);
                },
              )),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

// Widget to display each category card
class SubCategoryCard extends StatelessWidget {
  final bool? isAccessFromBottomTab;

  final SubCategoryModel category;

  const SubCategoryCard(
      {required this.category, this.isAccessFromBottomTab = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<CategoriesController>().setSelectedSubCategory(category);
        Get.to(() =>
            isAccessFromBottomTab! ? OpenStreetMapPage() : SubmitItemPage());
      },
      overlayColor:
          WidgetStateProperty.all(const Color.fromARGB(0, 92, 92, 92)),
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
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: BricolageText(
                text: category.productName ?? "",
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: CachedNetworkImage(
                    imageUrl: category.imagePath ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
