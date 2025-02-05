import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CustomFieldWithleadingAndActionIcon extends StatelessWidget {
  final double? width;
  final String? FieldName;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final double? borderRadius;
  final Function()? onPressOfSearchButton;
  const CustomFieldWithleadingAndActionIcon({
    super.key,
    this.validator,
    this.width,
    this.FieldName,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.onPressOfSearchButton,
    this.hintText,
    this.borderRadius = 10,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldName != null && FieldName!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  children: [
                    BricolageText(
                      text: FieldName ?? "",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    )
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(
          height: 45.h,
          width: width,
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: keyboardType ?? TextInputType.text,
              cursorColor: Colors.black,
              onChanged: onChanged,
              controller: controller,
              cursorWidth: 1,
              initialValue: initialValue,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 24.sp,
                    ),
                    onPressed: onPressOfSearchButton ?? () {},
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color(0xff0033ff),
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 7, left: 10),
                  filled: true,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 240, 8, 8),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 144, 144, 144),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color(0xff0033ff),
                      width: 2.0,
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 171, 171, 171)))),
        ),
      ],
    );
  }
}
