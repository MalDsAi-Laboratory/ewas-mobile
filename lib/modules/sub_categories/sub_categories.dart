import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/category_model.dart';
import 'package:simple_ui/modules/sub_categories/components/sub_categories_appbar.dart';
import 'package:simple_ui/modules/sub_categories/sub_categories_controller.dart';
import 'package:simple_ui/modules/submit_item/submit_item.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SubCategoriesPage extends StatelessWidget {
  final bool? isAccessFromBottomTab;
  const SubCategoriesPage({
    Key? key,
    this.isAccessFromBottomTab = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final SubCategoriesController controller =
        Get.put(SubCategoriesController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SubCategoriesAppBar(),
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
                      itemCount: controller.allCategories.length,
                      itemBuilder: (context, index) {
                        return SubCategoryCard(
                            category: controller.allCategories[index]);
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
class SubCategoryCard extends StatelessWidget {
  final Category category;

  const SubCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => SubmitItemPage());
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
                  // height: 160.h,
                  // width: 160.h,
                  category.imageUrl,
                  fit: BoxFit.contain,
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
