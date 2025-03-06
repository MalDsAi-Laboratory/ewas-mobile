import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
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

Color getStatusColor(String status) {
  switch (status) {
    case OrderStatus.orderPlaced:
      return Colors.orange;
    case OrderStatus.biddingStarted:
      return Colors.blueGrey;
    case OrderStatus.biddingInProgress:
      return Colors.purple;
    case OrderStatus.biddingCompleted:
      return Colors.teal;
    case OrderStatus.awaitingForPick:
      return Colors.amber;
    case OrderStatus.orderCollected:
      return Colors.cyan;
    case OrderStatus.deliveredToWarehouse:
      return Colors.indigo;
    case OrderStatus.deliveredForRecycle:
      return Colors.green;
    case OrderStatus.biddingRejected:
      return Colors.red;
    case OrderStatus.completed:
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

datePicker(context) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(
          1950), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101));
  return pickedDate;
}

class RetryWidget extends StatelessWidget {
  final void Function()? onTap;
  const RetryWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap ?? () {},
        child: Icon(
          Icons.refresh,
          size: 25.r,
          color: Colors.black,
        ));
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        backgroundColor: const Color.fromARGB(
            255, 244, 244, 244), // Make the button itself transparent
        shadowColor: const Color.fromARGB(
            0, 238, 238, 238), // Remove default button shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      onPressed: () async {
        try {
          await SecureStorageServices().logOut();
          Get.off(() => SplashScreen());
        } catch (e) {
          log("error in logOut $e");
        }
      },
      child: Center(
        child: BricolageText(
          text: "Logout",
          style: TextStyle(
              fontSize: 16.sp,
              color: const Color.fromARGB(255, 237, 0, 0),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
