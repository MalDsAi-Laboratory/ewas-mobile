import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/contact_us/contact_us_page.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BricolageText(
            text: "Hi !",
            style: TextStyle(fontSize: 14.sp),
          ),
          BricolageText(
            text: "Let's sell your e-waste",
            style: TextStyle(
                fontSize: 12.sp,
                color: const Color.fromARGB(255, 124, 124, 124)),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
