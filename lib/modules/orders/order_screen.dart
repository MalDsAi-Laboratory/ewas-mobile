import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/orders/components/order_product_components.dart';
import 'package:simple_ui/modules/orders/components/timeline_widget.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/controller/order_controller.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/dropdown_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';
import 'package:intl/intl.dart';

void showOrderDetailScreen(context, orderIndex) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      barrierColor: const Color.fromARGB(167, 30, 30, 30),
      useSafeArea: true,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return OrderScreen(orderIndex: orderIndex);
      });
}

class OrderScreen extends StatefulWidget {
  final int orderIndex;
  const OrderScreen({super.key, required this.orderIndex});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    OrderController orderController = Get.put((OrderController()));
    orderController.currentOrder =
        Get.find<AllOrderController>().orders[widget.orderIndex];
    orderController.currentInventory = Get.find<AllOrderController>()
        .inventoryMap[orderController.currentOrder!.eid ?? ""];
    orderController.update();
    orderController.initializeEditOrderData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GetBuilder<MainScreenController>(builder: (mainScreenController) {
      final userRole = mainScreenController.user!.roles![0];
      return Container(
        height: size.height - 110.h,
        width: size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GetBuilder<OrderController>(builder: (orderController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header with Edit button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BricolageText(
                        text: "Order summary",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      if (userRole == UserRole.admin ||
                          userRole == UserRole.deliveryAgent)
                        IconButton(
                          onPressed: () {
                            if (isEditing) {
                              orderController.updateCurrentOrderSummary(
                                  widget.orderIndex, context);
                            }
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                          icon: Icon(
                            isEditing ? Icons.check : Icons.edit_note,
                            size: 28.r,
                            color: const Color.fromARGB(255, 103, 103, 103),
                          ),
                        )
                    ],
                  ),
                ),
                orderController.isLoadingCurrentOrder
                    ? SizedBox(
                        height: size.height - 180.h,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: OrderProductComponent(
                                inventoryModel:
                                    orderController.currentInventory!),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            height: 15.h,
                            color: const Color.fromARGB(255, 241, 241, 241),
                          ),
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: BricolageText(
                              text: "Order Details",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            height: 0.4.h,
                            color: const Color.fromARGB(255, 201, 201, 201),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h),

                                /// Order Details
                                OrderDetailItemWidget(
                                    title: "Order ID",
                                    value: orderController.currentOrder?.eid ??
                                        ""),
                                SizedBox(height: 10.h),

                                userRole == UserRole.admin && isEditing
                                    ? EditableField(
                                        controller:
                                            orderController.nameController,
                                        label: "Name",
                                        icon: Icon(Icons.person, size: 25.r),
                                      )
                                    : OrderDetailItemWidget(
                                        title: "Name",
                                        value:
                                            "${orderController.currentOrder?.firstName} ${orderController.currentOrder?.lastName}"),

                                SizedBox(height: 10.h),

                                userRole == UserRole.admin && isEditing
                                    ? EditableField(
                                        controller:
                                            orderController.addressController,
                                        label: "Address",
                                        icon:
                                            Icon(Icons.location_on, size: 25.r),
                                      )
                                    : OrderDetailItemWidget(
                                        title: "Address",
                                        value: orderController
                                                .currentOrder?.address ??
                                            ""),

                                SizedBox(height: 10.h),

                                userRole == UserRole.admin && isEditing
                                    ? EditableField(
                                        controller:
                                            orderController.emailController,
                                        label: "User Id",
                                        icon: Icon(Icons.email_outlined,
                                            size: 25.r),
                                      )
                                    : OrderDetailItemWidget(
                                        title: "User Id",
                                        value: orderController
                                                .currentOrder?.userId ??
                                            ""),

                                SizedBox(height: 10.h),

                                InkWell(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  onTap: userRole == UserRole.admin && isEditing
                                      ? () async {
                                          DateTime? pickedDate =
                                              await datePicker(context);
                                          try {
                                            if (pickedDate != null) {
                                              orderController.orderDate =
                                                  pickedDate;
                                              orderController.update();
                                            }
                                          } catch (e) {}
                                        }
                                      : null,
                                  child: OrderDetailItemWidget(
                                    title: "Date",
                                    value: DateFormat.yMMMd().format(
                                        orderController
                                                .currentOrder?.orderDate ??
                                            DateTime.now()),
                                  ),
                                ),

                                SizedBox(height: 10.h),

                                userRole == UserRole.admin && isEditing
                                    ? EditableField(
                                        controller:
                                            orderController.assigneeController,
                                        label: "Assignee",
                                        icon: Icon(Icons.person_2, size: 25.r),
                                      )
                                    : orderController.currentOrder?.assignee !=
                                                null ||
                                            orderController
                                                    .currentOrder?.assignee !=
                                                ""
                                        ? OrderDetailItemWidget(
                                            title: "Assignee",
                                            value: orderController
                                                .currentOrder!.assignee!)
                                        : SizedBox(),

                                /// Status (Editable for Admin & Delivery Agent)
                                if (userRole == UserRole.admin ||
                                    userRole == UserRole.deliveryAgent)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BricolageText(
                                            text: 'Status',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: const Color.fromARGB(
                                                    255, 124, 124, 124)),
                                          ),
                                          SizedBox(height: 8.h),
                                          isEditing
                                              ? SizedBox(
                                                  width: 200.w,
                                                  child: DropDownWidget(
                                                    value: orderController
                                                            .currentOrder
                                                            ?.orderStatus ??
                                                        OrderStatus.orderPlaced,
                                                    dropDownItems: [
                                                      OrderStatus.orderPlaced,
                                                      OrderStatus
                                                          .biddingStarted,
                                                      OrderStatus
                                                          .biddingInProgress,
                                                      OrderStatus
                                                          .biddingCompleted,
                                                      OrderStatus
                                                          .biddingRejected,
                                                      OrderStatus
                                                          .awaitingForPick,
                                                      OrderStatus.completed,
                                                      OrderStatus
                                                          .deliveredForRecycle,
                                                      OrderStatus
                                                          .deliveredToWarehouse,
                                                      OrderStatus
                                                          .orderCollected,
                                                    ]
                                                        .map((status) =>
                                                            DropdownMenuItem(
                                                              value: status,
                                                              child:
                                                                  Text(status),
                                                            ))
                                                        .toList(),
                                                    onChanged: (newStatus) {
                                                      orderController
                                                              .orderStatus =
                                                          newStatus;
                                                      orderController.update();
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: getStatusColor(
                                                        orderController
                                                                .currentOrder!
                                                                .orderStatus ??
                                                            ""),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: BricolageText(
                                                    text: orderController
                                                            .currentOrder!
                                                            .orderStatus ??
                                                        "No Order",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Divider(
                                        color: const Color.fromARGB(
                                            255, 227, 227, 227),
                                      )
                                    ],
                                  ),

                                userRole == UserRole.admin && isEditing
                                    ? EditableField(
                                        controller: orderController
                                            .orderDetailsController,
                                        label: "Order Details",
                                        icon: Icon(Icons.description_outlined,
                                            size: 25.r),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BricolageText(
                                            text: "Order Details",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w300,
                                                color: const Color.fromARGB(
                                                    255, 88, 88, 88)),
                                          ),
                                          (orderController.currentOrder
                                                          ?.orderDetails !=
                                                      null &&
                                                  orderController.currentOrder!
                                                      .orderDetails!.isNotEmpty)
                                              ? Column(
                                                  children: [
                                                    SizedBox(height: 8.h),
                                                    BricolageText(
                                                      text: orderController
                                                              .currentOrder
                                                              ?.orderDetails ??
                                                          "",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ],
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                if (userRole == UserRole.seller ||
                                    userRole == UserRole.recycler)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        color: const Color.fromARGB(
                                            255, 227, 227, 227),
                                      ),
                                      BricolageText(
                                        text: "Status",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w300,
                                            color: const Color.fromARGB(
                                                255, 88, 88, 88)),
                                      ),
                                      SizedBox(height: 30.h),
                                      OrderStatusTimeline(
                                          currentStatus:
                                              orderController.orderStatus ??
                                                  "Order Placed"),
                                      SizedBox(height: 20.h),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            );
          }),
        ),
      );
    });
  }
}

/// Custom Widget for Editable Fields
class EditableField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget? icon;
  const EditableField(
      {super.key, required this.controller, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BricolageText(
          text: label,
          style: TextStyle(
              fontSize: 15.sp, color: const Color.fromARGB(255, 124, 124, 124)),
        ),
        SizedBox(height: 5.h),
        CustomTextField(
          icon: icon,
          controller: controller,
          onChanged: (val) {
            Get.find<AllOrderController>().update();
          },
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class OrderDetailItemWidget extends StatelessWidget {
  final String title;
  final String value;
  const OrderDetailItemWidget(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BricolageText(
          text: title,
          style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w300,
              color: const Color.fromARGB(255, 88, 88, 88)),
        ),
        SizedBox(
          height: 4.h,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              BricolageText(
                text: value,
                textAlign: TextAlign.left,
                style:
                    TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
      ],
    );
  }
}

showRestrictedLoadingDialog(context) {
  showDialog(
      barrierColor: const Color.fromARGB(64, 0, 0, 0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder<OrderController>(builder: (orderController) {
          return PopScope(
              canPop: !orderController.isUpdatingOrder,
              child: Center(child: AppLoadingWidget()));
        });
      });
}
