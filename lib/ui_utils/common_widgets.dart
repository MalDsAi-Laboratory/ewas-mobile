import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
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
    case OrderStatus.preparing:
      return const Color.fromARGB(255, 119, 0, 255);
    case OrderStatus.onTheWay:
      return Colors.blue;
    case OrderStatus.delivered:
      return Colors.green;
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
