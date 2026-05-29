import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class OrderStatusTimeline extends StatefulWidget {
  final OrderStatus? currentStatus;

  const OrderStatusTimeline({super.key, required this.currentStatus});

  @override
  State<OrderStatusTimeline> createState() => _OrderStatusTimelineState();
}

class _OrderStatusTimelineState extends State<OrderStatusTimeline> {
  late List<OrderStatus> orderFlow;

  @override
  void initState() {
    super.initState();
    _determineFlow();
  }

  void _determineFlow() {
    // Select the flow based on the current status
    if (widget.currentStatus == OrderStatus.biddingRejected) {
      orderFlow = [
        OrderStatus.orderPlaced,
        OrderStatus.biddingStarted,
        OrderStatus.biddingRejected,
      ];
    } else {
      orderFlow = [
        OrderStatus.orderPlaced,
        OrderStatus.biddingStarted,
        OrderStatus.biddingInProgress,
        OrderStatus.biddingCompleted,
        OrderStatus.awaitingForPick,
        OrderStatus.orderCollected,
        OrderStatus.deliveredToWarehouse,
        OrderStatus.deliveredForRecycle,
        OrderStatus.completed,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: EasyStepper(
        activeStep: widget.currentStatus != null ? orderFlow.indexOf(widget.currentStatus!) : 0,
        lineStyle: LineStyle(
          lineLength: 70.w,
          lineSpace: 0,
          lineType: LineType.dashed,
          defaultLineColor: const Color.fromARGB(255, 227, 227, 227),
          finishedLineColor: AppColors.primaryColor,
        ),
        activeStepTextColor: Colors.black87,
        finishedStepTextColor: Colors.black87,
        showLoadingAnimation: false,
        disableScroll: false,
        direction: Axis.horizontal,
        stepRadius: 10.r,
        internalPadding: 70.w,
        showStepBorder: false,
        steps: orderFlow
            .map((status) => _buildStep(status))
            .toList(),
      ),
    );
  }

  EasyStep _buildStep(OrderStatus status) {
    final stepIndex = orderFlow.indexOf(status);
    final activeIndex = orderFlow.indexOf(widget.currentStatus!);
    return EasyStep(
      customStep: CircleAvatar(
        radius: 12,
        backgroundColor: stepIndex <= activeIndex
            ? AppColors.primaryColor
            : const Color.fromARGB(255, 231, 231, 231),
        child: stepIndex <= activeIndex
            ? Icon(
                Icons.check,
                size: 15.r,
                color: Colors.white,
              )
            : null,
      ),
      customTitle: BricolageText(
        text: status.value,
        style: TextStyle(color: Colors.black87, fontSize: 13.sp),
      ),
    );
  }
}
