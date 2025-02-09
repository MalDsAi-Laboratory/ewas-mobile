import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/bidding_model.dart';
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
          // Sort the list by priceTag in descending order
          List<BiddingModel> sortedBids = List.from(controller.biddingList)
            ..sort((a, b) => (b.priceTag ?? 0).compareTo(a.priceTag ?? 0));

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
                label: BricolageText(
                  text: "Recycler",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
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
            rows: sortedBids.asMap().entries.map((entry) {
              int index = entry.key + 1; // Index starts from 1
              BiddingModel bidding = entry.value;
              return DataRow(cells: [
                DataCell(BricolageText(
                  text: index.toString(),
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                )),
                DataCell(SizedBox(
                  width: 200.w,
                  child: BricolageText(
                    text: bidding.recycler ?? "",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                )),
                DataCell(Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: BricolageText(
                    text: bidding.priceTag != null
                        ? bidding.priceTag.toString()
                        : "0",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                )),
              ]);
            }).toList(),
          );
        }),
      ),
    );
  }
}
