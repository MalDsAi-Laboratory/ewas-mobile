import 'package:get/get.dart';
import 'package:simple_ui/models/order_model.dart';

class OrderController extends GetxController {
  var orders = <Order>[
    Order(eid: "EWAS0000001", orderStatus: "Pending", assignee: "Alice"),
    Order(eid: "EWAS0000002", orderStatus: "Delivered", assignee: "Bob"),
    Order(
        eid: "EWAS0000003",
        orderStatus: "Shipped",
        assignee: "CharlieCharlieCharlieCharlieCharlieCharlie"),
    Order(eid: "EWAS0000002", orderStatus: "Delivered", assignee: "Bob"),
  ].obs;

  var filteredOrders = <Order>[].obs;
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
