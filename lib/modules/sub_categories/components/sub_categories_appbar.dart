import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SubCategoriesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SubCategoriesAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Row(
                  children: [
                    AppBarButton(),
                    SizedBox(
                      width: 12.w,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BricolageText(
                      text: 'Select material type',
                      style: TextStyle(fontSize: 20.sp, color: Colors.black87),
                    ),
                    BricolageText(
                      text: 'Select specific material type',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color.fromARGB(221, 101, 101, 101)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 24.h);
}
