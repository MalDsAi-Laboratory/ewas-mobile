import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showLoadingDialog(context) {
  showDialog(
      barrierColor: const Color.fromARGB(64, 0, 0, 0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: AppLoadingWidget());
      });
}

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.w,
      height: 45.w,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 245, 245),
          borderRadius: BorderRadius.circular(10.r)),
      child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 2,
      ),
    );
  }
}
