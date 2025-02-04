import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

// Order Model
class Order {
  final String eid;
  final String firstName;
  final String lastName;
  final String address;
  final String assignee;
  final String emailId;
  final String orderStatus;
  final DateTime orderDate;
  final String orderDetails;

  Order({
    required this.eid,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.assignee,
    required this.emailId,
    required this.orderStatus,
    required this.orderDate,
    required this.orderDetails,
  });
}

// Order Controller using GetX
class OrderController extends GetxController {
  var orders = <Order>[
    Order(
      eid: "EWAS0000001",
      firstName: "John",
      lastName: "Doe",
      address: "123 Main Street, NY",
      assignee: "Alice",
      emailId: "john.doe@example.com",
      orderStatus: "Pending",
      orderDate: DateTime(2024, 2, 1),
      orderDetails: "Order contains electronic gadgets.",
    ),
    Order(
      eid: "EWAS0000002",
      firstName: "Jane",
      lastName: "Smith",
      address: "456 Elm Street, CA",
      assignee: "Bob",
      emailId: "jane.smith@example.com",
      orderStatus: "Delivered",
      orderDate: DateTime(2024, 1, 28),
      orderDetails: "Order contains electronic gadgets.",
    ),
    Order(
      eid: "EWAS0000003",
      firstName: "Alice",
      lastName: "Brown",
      address: "789 Pine Ave, TX",
      assignee: "Charlie",
      emailId: "alice.brown@example.com",
      orderStatus: "Shipped",
      orderDate: DateTime(2024, 1, 30),
      orderDetails: "Order contains electronic gadgets.",
    ),
  ].obs;

  List<Order> get ongoingOrders =>
      orders.where((order) => order.orderStatus != "Delivered").toList();
  List<Order> get completedOrders =>
      orders.where((order) => order.orderStatus == "Delivered").toList();
}

// Order Screen with Tabs
class OrderScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: BricolageText(text: "My Orders"),
          bottom: TabBar(
            labelColor: Colors.green,
            indicatorColor: Colors.green,
            tabs: [
              Tab(
                child: BricolageText(
                  text: "Ongoing",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderList(orderType: "Ongoing"),
            OrderList(orderType: "Completed"),
          ],
        ),
      ),
    );
  }
}

// Order List Widget
class OrderList extends StatelessWidget {
  final String orderType;
  final OrderController orderController = Get.find();

  OrderList({required this.orderType});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var orders = orderType == "Ongoing"
          ? orderController.ongoingOrders
          : orderController.completedOrders;

      return orders.isEmpty
          ? Center(child: Text("No $orderType Orders"))
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${order.eid}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 5),
                        Text("Name: ${order.firstName} ${order.lastName}"),
                        Text("Address: ${order.address}"),
                        Text("Assignee: ${order.assignee}"),
                        Text("Email: ${order.emailId}"),
                        Text("Status: ${order.orderStatus}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: order.orderStatus == "Delivered"
                                    ? Colors.green
                                    : Colors.orange)),
                        Text(
                            "Order Date: ${DateFormat.yMMMd().format(order.orderDate)}"),
                        SizedBox(height: 5),
                        Text("Details: ${order.orderDetails}",
                            style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }
}
