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
    CategoriesController controller = Get.put(CategoriesController());
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
      body: SafeArea(
        child: Padding(
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.8),
                      itemCount: controller.filteredCategories.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                            category: controller.filteredCategories[index]);
                      },
                    )),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget to display each category card
class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor:
          WidgetStateProperty.all(const Color.fromARGB(0, 92, 92, 92)),
      borderRadius: BorderRadius.circular(25.r),
      onTap: () {
        Get.find<CategoriesController>().setSelectedCategory(category);
        Get.to(() => SubCategoriesPage());
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
                text: category.title,
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
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
                child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.cover,
                ),
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
