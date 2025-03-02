import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/category_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/categories/components/categories_appbar.dart';
import 'package:simple_ui/modules/sub_categories/sub_categories.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CategoriesPage extends StatefulWidget {
  final bool? isAccessFromBottomTab;
  const CategoriesPage({
    Key? key,
    this.isAccessFromBottomTab = false,
  }) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    CategoriesController controller = Get.find<CategoriesController>();
    controller.clearState();
  }

  @override
  Widget build(BuildContext context) {
    CategoriesController controller = Get.find<CategoriesController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CategoriesAppBar(
        isAccessFromBottomTab: widget.isAccessFromBottomTab,
      ),
      body: Obx(
        () => SafeArea(
          child: controller.isCategoriesLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Keep content at the top
                      children: [
                        // Categories Grid
                        Obx(() => GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16.w,
                                      mainAxisSpacing: 16.h,
                                      childAspectRatio: 0.8),
                              itemCount: controller.filteredCategories.length,
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                    isAccessFromBottomTab:
                                        widget.isAccessFromBottomTab,
                                    category:
                                        controller.filteredCategories[index]);
                              },
                            )),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// Widget to display each category card
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool? isAccessFromBottomTab;

  const CategoryCard({
    required this.category,
    this.isAccessFromBottomTab = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor:
          WidgetStateProperty.all(const Color.fromARGB(0, 92, 92, 92)),
      borderRadius: BorderRadius.circular(25.r),
      onTap: () {
        Get.find<CategoriesController>().setSelectedCategory(category);
        Get.to(() => SubCategoriesPage(
              isAccessFromBottomTab: isAccessFromBottomTab,
            ));
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
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: BricolageText(
                text: category.category ?? "",
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15.h,
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
