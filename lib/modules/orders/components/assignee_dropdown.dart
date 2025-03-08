import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/orders/controller/all_order_controller.dart';
import 'package:simple_ui/modules/orders/controller/order_controller.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AssigneeDropdown extends StatelessWidget {
  const AssigneeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BricolageText(
            text: "Search & Select User:", style: TextStyle(fontSize: 15.sp)),
        SizedBox(height: 3.h),
        GetBuilder<AllOrderController>(builder: (allorderController) {
          return GetBuilder<OrderController>(builder: (orderController) {
            return DropDownSearchField<UserModel>(
              displayAllSuggestionWhenTap: false,
              isMultiSelectDropdown: false,

              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                controller: orderController.assigneeController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(10.r)),
                    hintText: "Search for a user",
                    hintStyle: GoogleFonts.bricolageGrotesque(
                        textStyle: TextStyle(fontSize: 15.sp))),
              ),
              suggestionsCallback: (pattern) async {
                return allorderController.deliveryUsers
                    .where((user) => "${user.firstName} ${user.lastName}"
                        .toLowerCase()
                        .contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, user) {
                return Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10), // Adjust spacing
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BricolageText(
                              text: "${user.firstName} ${user.lastName}",
                              style: TextStyle(fontSize: 16.sp)),
                          BricolageText(
                              text: user.email ?? "",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 16.sp)),
                        ],
                      ),
                    ],
                  ),
                );
              },
              onSuggestionSelected: (user) {
                orderController.assignee = user.userId!;
                orderController.assigneeName =
                    "${user.firstName} ${user.lastName}";
                orderController.assigneeController.text =
                    "${user.firstName} ${user.lastName}";
                orderController.update();
              },
              // Customize the loading view background color
              loadingBuilder: (context) {
                return Container(
                  color: Colors
                      .white, // Change this to your desired background color
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: CircularProgressIndicator(
                      color:
                          Colors.blue, // Customize the loading indicator color
                    ),
                  ),
                );
              },
            );
          });
        }),
      ],
    );
  }
}
