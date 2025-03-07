import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class RejectBiddingButton2 extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isBtnActive;

  const RejectBiddingButton2({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isBtnActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.w,
      width: MediaQuery.sizeOf(context).width - 35.w,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: isBtnActive
              ? [Color.fromRGBO(225, 57, 57, 1), Color.fromRGBO(225, 57, 57, 1)]
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}

class RejectBiddingButton extends StatelessWidget {
  final Widget buttonChild;
  final VoidCallback onTap;
  final bool isBtnActive;

  const RejectBiddingButton({
    super.key,
    required this.buttonChild,
    required this.onTap,
    this.isBtnActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.w,
      width: MediaQuery.sizeOf(context).width - 35.w,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: isBtnActive
              ? [Color.fromRGBO(225, 57, 57, 1), Color.fromRGBO(225, 57, 57, 1)]
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
