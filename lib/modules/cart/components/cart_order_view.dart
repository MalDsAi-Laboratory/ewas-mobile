import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/modules/cart/cart_controller.dart';
import 'package:simple_ui/modules/cart/components/cart_order_product.dart';
import 'package:simple_ui/modules/orders/helper.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';
import 'package:intl/intl.dart';

void showCartOrderDetailScreen(context, orderIndex) {
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
        return CartOrderScreen(orderIndex: orderIndex);
      });
}

class CartOrderScreen extends StatefulWidget {
  final int orderIndex;
  const CartOrderScreen({super.key, required this.orderIndex});

  @override
  _CartOrderScreenState createState() => _CartOrderScreenState();
}

class _CartOrderScreenState extends State<CartOrderScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    CartController allOrderController = Get.find<CartController>();
    return Container(
      height: size.height - 110.h,
      width: size.width,
      child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Obx(() => allOrderController.isCartProductsLoading.value
              ? Center(
                  child: AppLoadingWidget(),
                )
              : OrderComponent(
                  orderIndex: widget.orderIndex,
                ))),
    );
  }
}

class OrderComponent extends StatefulWidget {
  final int orderIndex;

  const OrderComponent({super.key, required this.orderIndex});

  @override
  State<OrderComponent> createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      SubsidiaryInventoryModel model = cartController
          .inventoryMap[cartController.orders[widget.orderIndex].eid]!;
      OrderModel orderModel = cartController.orders[widget.orderIndex];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with Edit button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BricolageText(
              text: "Order summary",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CartOrderProductComponent(inventoryModel: model),
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
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                        title: "Order ID", value: orderModel.eid ?? ""),
                    SizedBox(height: 10.h),

                    OrderDetailItemWidget(
                        title: "Name",
                        value:
                            "${orderModel.firstName} ${orderModel.lastName}"),

                    SizedBox(height: 10.h),

                    OrderDetailItemWidget(
                        title: "Address", value: orderModel.address ?? ""),

                    SizedBox(height: 10.h),

                    OrderDetailItemWidget(
                      title: "Date",
                      value: DateFormat.yMMMd()
                          .format(orderModel.orderDate ?? DateTime.now()),
                    ),

                    SizedBox(height: 10.h),

                    orderModel.assignee != null && orderModel.assignee != ""
                        ? OrderDetailItemWidget(
                            title: "Assignee", value: orderModel.assignee!)
                        : SizedBox(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BricolageText(
                          text: "Order Details",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w300,
                              color: const Color.fromARGB(255, 88, 88, 88)),
                        ),
                        (orderModel.orderDetails != null &&
                                orderModel.orderDetails!.isNotEmpty)
                            ? Column(
                                children: [
                                  SizedBox(height: 8.h),
                                  Builder(builder: (context) {
                                    String details = "";
                                    String? input = orderModel.orderDetails;
                                    List<String> parts = input!
                                        .split("||")
                                        .map((e) => e.trim())
                                        .toList();
                                    if (parts.length == 1) {
                                      details = input;
                                    } else {
                                      // Extract timestamp and parse it
                                      String timestamp = parts[0];
                                      DateTime dateTime =
                                          DateTime.parse(timestamp);

                                      // Format the date for UI
                                      String formattedTime =
                                          "${getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}, "
                                          "${formatHour(dateTime.hour)}:${formatMinute(dateTime.minute)} ${getAmPm(dateTime.hour)}";

                                      details = orderModel.orderDetails ?? "";
                                      details =
                                          "${formattedTime} || ${parts[1]}";
                                    }
                                    return BricolageText(
                                      text: details,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal),
                                    );
                                  })
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: const Color.fromARGB(255, 227, 227, 227),
                        ),
                        BricolageText(
                          text: "Status",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w300,
                              color: const Color.fromARGB(255, 88, 88, 88)),
                        ),
                        SizedBox(height: 8.h),
                        BricolageText(
                          text: orderModel.orderStatus?.value ?? "Order Placed",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                    orderModel.orderStatus == OrderStatus.orderPlaced
                        ? RadialGradientButton(
                            buttonText: 'Start Bidding',
                            onTap: () {
                              cartController.submitItem(
                                  orderModel.eid!, widget.orderIndex, context);
                            },
                            isBtnActive: true,
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
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

showCartRestrictedLoadingDialog(context) {
  showDialog(
      barrierColor: const Color.fromARGB(64, 0, 0, 0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        CartController cartController = Get.find<CartController>();
        return Obx(
          () => PopScope(
              canPop: !cartController.isInventoryCreating.value,
              child: Center(child: AppLoadingWidget())),
        );
      });
}
