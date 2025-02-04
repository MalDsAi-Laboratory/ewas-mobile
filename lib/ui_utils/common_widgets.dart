import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  final double thickness;
  final Color color;
  final double spacing;

  const SectionHeader({
    super.key,
    this.text = "OR",
    this.thickness = 1.0,
    this.color = Colors.grey,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: BricolageText(
            text: text,
            style: TextStyle(
                letterSpacing: 1.4,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(99, 99, 99, 1.0),
                fontSize: 17.sp),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
      ],
    );
  }
}
