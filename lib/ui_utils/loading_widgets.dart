import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.w,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10.r)),
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }
}
