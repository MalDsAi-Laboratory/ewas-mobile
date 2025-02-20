import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AppSnackBars {
  // success snack bar
  static void showSuccessSnackBar(String title, String message) {
    Get.snackbar(title, message,
        titleText: BricolageText(
          textAlign: TextAlign.left,
          text: title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.white),
        ),
        messageText: BricolageText(
          text: message,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
              color: Colors.white),
        ),
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  // error snack bar
  static void showErrorSnackBar(String title, String message) {
    Get.snackbar(title, message,
        titleText: BricolageText(
          text: title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.white),
        ),
        messageText: BricolageText(
          text: message,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
              color: Colors.white),
        ),
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }

  // normal snack bar
  static void showNormalSnackBar(String title, String message) {
    Get.snackbar(title, message,
        titleText: BricolageText(
          text: title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        messageText: BricolageText(
          text: message,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
              color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        colorText: const Color.fromARGB(255, 0, 0, 0));
  }

  static void showNormalSnackBarWithButton(
      String title, String message, VoidCallback onRetry) {
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 5),
      titleText: BricolageText(
        text: title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      messageText: BricolageText(
        text: message,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14.sp,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      colorText: const Color.fromARGB(255, 0, 0, 0),
      mainButton: TextButton(
        onPressed: onRetry,
        child: BricolageText(
          text: "Retry",
          style: TextStyle(
            color: const Color.fromARGB(255, 178, 38, 243),
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
