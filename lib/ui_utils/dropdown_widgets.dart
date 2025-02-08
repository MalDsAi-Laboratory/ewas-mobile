import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class DropDownWidget extends StatelessWidget {
  final String? value;
  final void Function(dynamic)? onChanged;
  final List<DropdownMenuItem<dynamic>> dropDownItems;
  final String fieldName;

  const DropDownWidget(
      {super.key,
      required this.value,
      this.fieldName = "",
      this.onChanged,
      required this.dropDownItems});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldName != ""
            ? Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  children: [
                    BricolageText(
                      text: fieldName,
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
        Container(
          height: 45,
          child: DropdownButtonFormField(
              // padding: EdgeInsets.only(top: 7.h),
              elevation: 0,
              dropdownColor: const Color.fromARGB(255, 255, 255, 255),
              focusColor: const Color.fromARGB(255, 180, 253, 182),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.monitor_heart_outlined,
                  size: 25.r,
                ),
                contentPadding:
                    EdgeInsets.only(left: 15.w, right: 15.w, bottom: 7.h),
                hoverColor: Colors.black,
                focusColor: Colors.black,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: const Color.fromARGB(255, 0, 0, 0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
              ),
              isExpanded: true,
              iconSize: 24.sp,
              alignment: Alignment.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.sp,
                  color: Colors.black),
              value: value,
              items: dropDownItems,
              onChanged: onChanged),
        ),
      ],
    );
  }
}
