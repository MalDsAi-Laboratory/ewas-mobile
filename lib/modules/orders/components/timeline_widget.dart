import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class OrderStatusTimeline extends StatelessWidget {
  final int currentStep;

  const OrderStatusTimeline({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: EasyStepper(
        activeStep: 2,
        lineStyle: LineStyle(
          lineLength: 70.w,
          lineSpace: 0,
          lineType: LineType.dashed,
          defaultLineColor: const Color.fromARGB(255, 227, 227, 227),
          finishedLineColor: AppColors.primaryColor,
        ),
        activeStepTextColor: Colors.black87,
        stepBorderRadius: 0,
        finishedStepTextColor: Colors.black87,
        internalPadding: 0,
        showLoadingAnimation: false,
        disableScroll: true,
        stepRadius: 10.r,
        showStepBorder: false,
        steps: [
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: 2 >= 1 ? AppColors.primaryColor : Colors.white,
              child: 2 >= 1
                  ? Icon(
                      Icons.check,
                      size: 15.r,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    )
                  : null,
            ),
            customTitle: BricolageText(
              text: "Order Placed",
              style: TextStyle(color: Colors.black87, fontSize: 13.sp),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 12,
              backgroundColor: 2 >= 2 ? AppColors.primaryColor : Colors.white,
              child: 2 >= 2
                  ? Icon(
                      Icons.check,
                      size: 15.r,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    )
                  : null,
            ),
            customTitle: BricolageText(
              text: "Preparing",
              style: TextStyle(color: Colors.black87, fontSize: 13.sp),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 12,
              backgroundColor: 2 >= 3
                  ? AppColors.primaryColor
                  : const Color.fromARGB(255, 231, 231, 231),
              child: Icon(
                Icons.check,
                size: 15.r,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            customTitle: BricolageText(
              text: "On Way",
              style: TextStyle(color: Colors.black87, fontSize: 13.sp),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 12,
              backgroundColor: 2 >= 4
                  ? AppColors.primaryColor
                  : const Color.fromARGB(255, 231, 231, 231),
              child: Icon(
                Icons.check,
                size: 15.r,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            customTitle: BricolageText(
              text: "Delivered",
              style: TextStyle(color: Colors.black87, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}
