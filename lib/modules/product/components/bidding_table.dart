import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/bidding_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/modules/product/product_controller.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class BiddingTableWidget extends StatelessWidget {
  const BiddingTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: GetBuilder<ProductController>(builder: (controller) {
          // Create a list to hold both the bid and its index
          List<Map<String, dynamic>> indexedBids = [];

          // Sort the remaining bids by priceTag in descending order
          controller.biddingList
              .sort((a, b) => (b.priceTag ?? 0).compareTo(a.priceTag ?? 0));
          // Add the sorted bids with their index
          for (int i = 0; i < controller.biddingList.length; i++) {
            indexedBids.add({"bid": controller.biddingList[i], "index": i + 1});
          }

          return DataTable(
            columnSpacing: size.width * 0.06,
            border:
                TableBorder(top: BorderSide(width: 0.2, color: Colors.grey)),
            columns: [
              DataColumn(
                label: BricolageText(
                  text: "#",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
              ),
              DataColumn(
                label: Container(
                  width: size.width * 0.55,
                  child: BricolageText(
                    text: "Recycler",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                ),
              ),
              DataColumn(
                label: BricolageText(
                  text: "Bids",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
              ),
            ],
            rows: indexedBids.map((entry) {
              int index = entry['index']; // Index starts from 1
              BiddingModel bidding = entry['bid'];
              MainScreenController mainScreenController =
                  Get.find<MainScreenController>();
              bool isUser =
                  (mainScreenController.user!.roles![0] == UserRole.recycler &&
                      bidding.bidder == mainScreenController.user?.userId);
              bool isWinner = controller.remainingDatetime == Duration.zero
                  ? bidding.priceTag == controller.highestPrice
                  : false;
              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    return isWinner
                        ? const Color.fromARGB(255, 255, 237, 101)
                        : isUser
                            ? const Color.fromARGB(255, 33, 243, 65)
                                .withOpacity(0.2)
                            : null;
                  },
                ),
                cells: [
                  DataCell(BricolageText(
                    text: index.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight:
                            isWinner ? FontWeight.bold : FontWeight.w500),
                  )),
                  DataCell(SizedBox(
                    width: 200.w,
                    child: BricolageText(
                      text: bidding.fullName ?? "",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight:
                              isWinner ? FontWeight.bold : FontWeight.w500),
                    ),
                  )),
                  DataCell(Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: BricolageText(
                      text: bidding.priceTag != null
                          ? bidding.priceTag.toString()
                          : "0",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight:
                              isWinner ? FontWeight.bold : FontWeight.w500),
                    ),
                  )),
                ],
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
