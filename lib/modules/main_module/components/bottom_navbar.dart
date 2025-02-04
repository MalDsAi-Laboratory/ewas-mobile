import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: EdgeInsets.all(0.r),
      height: 75.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.r),
        child: Container(
          height: 60.h,
          padding: EdgeInsets.only(bottom: 11.h),
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Row(
            children: [
              const BottomNavBarItem(
                text: "Category",
                icon: Icons.category,
                index: 0,
              ),
              const BottomNavBarItem(
                text: "Orders",
                icon: Icons.list,
                index: 1,
              ),
              const BottomNavBarItem(
                index: 2,
              ),
              const BottomNavBarItem(
                text: "Cart",
                index: 3,
                icon: CupertinoIcons.cart_fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final int index;
  const BottomNavBarItem({
    super.key,
    this.icon = CupertinoIcons.home,
    this.text = "Home",
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(builder: (controller) {
      return Expanded(
        child: InkWell(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: () {
            controller.changePage(index);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                icon,
                size: 25.r,
                color: controller.currentIndex != index
                    ? Colors.grey
                    : AppColors.primaryColor,
              ),
              SizedBox(
                height: 3.h,
              ),
              BricolageText(
                text: text,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: controller.currentIndex != index
                      ? const Color.fromARGB(255, 149, 149, 149)
                      : AppColors.primaryColor,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
