import 'package:get/get.dart';
import 'package:simple_ui/models/order_model.dart';

class AllOrderController extends GetxController {
  var orders = <OrderModel>[
    OrderModel(
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
    OrderModel(eid: "EWAS0000001"),
    OrderModel(eid: "EWAS0000002", orderStatus: "Delivered", assignee: "Bob"),
    OrderModel(
        eid: "EWAS0000003",
        orderStatus: "Shipped",
        assignee: "CharlieCharlieCharlieCharlieCharlieCharlie"),
    OrderModel(eid: "EWAS0000002", orderStatus: "Delivered", assignee: "Bob"),
  ].obs;

  var filteredOrders = <OrderModel>[].obs;
  var searchId = ''.obs;
  var searchAssignee = ''.obs;
  var selectedStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filteredOrders.assignAll(orders);
  }

  void filterOrders() {
    filteredOrders.assignAll(
      orders.where((order) {
        return (searchId.isEmpty ||
                order.eid!
                    .toLowerCase()
                    .contains(searchId.value.toLowerCase())) &&
            (searchAssignee.isEmpty ||
                order.assignee!
                    .toLowerCase()
                    .contains(searchAssignee.value.toLowerCase())) &&
            (selectedStatus.isEmpty ||
                selectedStatus.value == "All" ||
                order.orderStatus == selectedStatus.value);
      }).toList(),
    );
  }

  void clearFilters() {
    searchId.value = '';
    searchAssignee.value = '';
    selectedStatus.value = '';
    filterOrders();
  }
}
