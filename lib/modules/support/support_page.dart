import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/models/query_model.dart';
import 'package:simple_ui/modules/home/components/app_drawer.dart';
import 'package:simple_ui/modules/support/support_controller.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/modules/orders/order_helper.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/loading_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class UserQueryScreen extends StatefulWidget {
  @override
  State<UserQueryScreen> createState() => _UserQueryScreenState();
}

class _UserQueryScreenState extends State<UserQueryScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(UserQueryController());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    UserQueryController queryController = Get.find<UserQueryController>();

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
        ),
        child: AppDrawerWidget(),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: BricolageText(
          text: "User Queries",
          style: TextStyle(fontSize: 20.sp, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu_open_sharp,
              size: 30.r,
            )),
        actions: [
          TextButton.icon(
            onPressed: () {
              queryController.fetchQueries();
            },
            label: Icon(
              Icons.refresh,
              color: Colors.black,
              size: 25.r,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            queryController.fetchQueries();
          },
          child: Obx(
            () => queryController.isLoading.value
                ? Center(child: AppLoadingWidget())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: size.width * 0.06,
                              border: TableBorder(
                                  top: BorderSide(
                                      width: 0.2, color: Colors.grey)),
                              columns: [
                                DataColumn(
                                    label: BricolageText(
                                        text: "#",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp))),
                                DataColumn(
                                    label: BricolageText(
                                        text: "User Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp))),
                                DataColumn(
                                    label: BricolageText(
                                        text: "Query",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp))),
                                DataColumn(
                                    label: BricolageText(
                                        text: "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp))),
                              ],
                              rows: queryController.paginatedQueries
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = queryController.currentPage.value *
                                        queryController.itemsPerPage +
                                    entry.key +
                                    1;
                                UserQueryModel query = entry.value;
                                return DataRow(cells: [
                                  DataCell(BricolageText(
                                    text: index.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataCell(BricolageText(
                                    text: query.userName ?? "",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataCell(BricolageText(
                                    text: query.query ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataCell(Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(OrderStatus.fromString(query.status)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: BricolageText(
                                      text: query.status ?? "Pending",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                        PaginationControls(queryController: queryController),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class PaginationControls extends StatelessWidget {
  final UserQueryController queryController;
  const PaginationControls({Key? key, required this.queryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: GetBuilder<UserQueryController>(
        builder: (controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed:
                    controller.hasPrevPage ? () => controller.prevPage() : null,
                icon: Icon(Icons.arrow_back_ios, size: 16.r),
              ),
              BricolageText(
                text:
                    'Page ${controller.currentPage.value + 1} of ${controller.totalPages}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed:
                    controller.hasNextPage ? () => controller.nextPage() : null,
                icon: Icon(Icons.arrow_forward_ios, size: 16.r),
              ),
            ],
          );
        },
      ),
    );
  }
}
