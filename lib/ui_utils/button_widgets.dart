import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? boxShadowColor;
  final Color? iconColor;
  final Color? bgColor;
  final IconData? iconData;
  const AppBarButton(
      {super.key,
      this.onTap,
      this.boxShadowColor = const Color.fromARGB(255, 249, 249, 249),
      this.bgColor = const Color.fromARGB(255, 248, 248, 248),
      this.iconColor = const Color.fromARGB(255, 0, 0, 0),
      this.iconData = Icons.arrow_back});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: onTap ??
                () {
                  Get.back();
                },
            borderRadius: BorderRadius.circular(100),
            overlayColor:
                WidgetStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                  height: 38.w,
                  width: 38.w,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 0),
                      blurRadius: 3.0.r,
                      color: boxShadowColor!,
                    ),
                  ], color: bgColor, shape: BoxShape.circle),
                  child: Icon(
                    iconData,
                    size: 25.r,
                    color: iconColor,
                  )),
            ))
      ],
    );
  }
}

class RadialGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isBtnActive;

  const RadialGradientButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isBtnActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.w,
      width: MediaQuery.sizeOf(context).width - 35.w,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: isBtnActive
              ? [Color.fromRGBO(57, 225, 161, 1), AppColors.primaryColor]
              : [
                  const Color.fromARGB(255, 255, 255, 255),
                  const Color.fromRGBO(224, 224, 224, 1.0),
                ],
          center: const Alignment(0, 0), // Center the gradient
          radius: 2.r, // Stretch the gradient horizontally
        ),
        borderRadius: BorderRadius.circular(10.r), // Rounded corners
      ),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
            backgroundColor:
                Colors.transparent, // Make the button itself transparent
            shadowColor: const Color.fromARGB(
                0, 238, 238, 238), // Remove default button shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: onTap,
          child: Center(
            child: BricolageText(
              text: buttonText,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: isBtnActive
                      ? Colors.white
                      : const Color.fromARGB(255, 135, 135, 135),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialGradientButtonWithWidget extends StatelessWidget {
  final Widget buttonChild;
  final VoidCallback onTap;
  final bool isBtnActive;

  const RadialGradientButtonWithWidget({
    super.key,
    required this.buttonChild,
    required this.onTap,
    this.isBtnActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.w,
      width: MediaQuery.sizeOf(context).width - 35.w,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: isBtnActive
              ? [Color.fromRGBO(57, 225, 161, 1), AppColors.primaryColor]
              : [
                  const Color.fromARGB(255, 255, 255, 255),
                  const Color.fromRGBO(224, 224, 224, 1.0),
                ],
          center: const Alignment(0, 0), // Center the gradient
          radius: 2.r, // Stretch the gradient horizontally
        ),
        borderRadius: BorderRadius.circular(10.r), // Rounded corners
      ),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
            backgroundColor:
                Colors.transparent, // Make the button itself transparent
            shadowColor: const Color.fromARGB(
                0, 238, 238, 238), // Remove default button shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: onTap,
          child: Center(
            child: buttonChild,
          ),
        ),
      ),
    );
  }
}

class TextandIconButton extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  final VoidCallback onTap;
  final bool isBtnActive;
  final bool? iconInFront;
  final double? height;
  const TextandIconButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.iconData,
    this.isBtnActive = false,
    this.iconInFront = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 45.w,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: isBtnActive
              ? [AppColors.primaryColor, AppColors.primaryColor]
              : [
                  const Color.fromARGB(255, 246, 246, 246),
                  const Color.fromRGBO(224, 224, 224, 1.0),
                ],
          center: const Alignment(0, 0), // Center the gradient
          radius: 2.r, // Stretch the gradient horizontally
        ),
        borderRadius: BorderRadius.circular(10.r), // Rounded corners
      ),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            backgroundColor:
                Colors.transparent, // Make the button itself transparent
            shadowColor: const Color.fromARGB(
                0, 238, 238, 238), // Remove default button shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconInFront!
                    ? Row(
                        children: [
                          Icon(
                            iconData,
                            size: 25.r,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      )
                    : SizedBox(),
                BricolageText(
                  text: buttonText,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: isBtnActive
                          ? Colors.white
                          : const Color.fromARGB(255, 135, 135, 135),
                      fontWeight: FontWeight.bold),
                ),
                !iconInFront!
                    ? Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Icon(
                            iconData,
                            size: 25.r,
                            color: Colors.white,
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? bgColor;
  final IconData? iconData;
  const CustomIconButton(
      {super.key,
      this.onTap,
      this.bgColor = const Color.fromARGB(255, 248, 248, 248),
      this.iconColor = const Color.fromARGB(255, 0, 0, 0),
      this.iconData = Icons.arrow_back});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.w,
      width: 38.w,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            surfaceTintColor: Colors.white,
            elevation: 0,
            backgroundColor: bgColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
            )),
        child: Icon(
          iconData,
          color: iconColor,
        ),
      ),
    );
  }
}
