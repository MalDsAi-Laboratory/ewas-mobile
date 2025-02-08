class OrderModel {
  final String? eid;
  String? firstName;
  String? lastName;
  String? address;
  String? assignee;
  String? emailId;
  String? orderStatus;
  DateTime? orderDate;
  String? orderDetails;

  OrderModel({
    this.eid,
    this.firstName,
    this.lastName,
    this.address,
    this.assignee,
    this.emailId,
    this.orderStatus,
    this.orderDate,
    this.orderDetails,
  });
}
