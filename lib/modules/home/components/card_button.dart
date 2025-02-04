import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CardButton extends StatelessWidget {
  final String text;
  const CardButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 111.w,
      height: 36.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(
              color: Colors.white.withOpacity(0.43),
              width: 1.w,
              strokeAlign: BorderSide.strokeAlignInside),
          color: const Color.fromARGB(255, 154, 51, 239)),
      child: Center(
        child: BricolageText(
          text: text,
          style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}
