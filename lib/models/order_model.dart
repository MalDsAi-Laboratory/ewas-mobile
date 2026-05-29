import 'package:simple_ui/modules/orders/order_helper.dart';

class OrderModel {
  final String? eid;
  String? firstName;
  String? lastName;
  String? address;
  String? assignee;
  String? userId;
  OrderStatus? orderStatus;
  DateTime? orderDate;
  String? orderDetails;
  String? productImagePath;

  OrderModel({
    this.eid,
    this.firstName,
    this.lastName,
    this.address,
    this.assignee,
    this.userId,
    this.orderStatus,
    this.orderDate,
    this.orderDetails,
    this.productImagePath,
  });

  // Convert JSON to OrderModel
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      eid: json['eid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      assignee: json['assignee'],
      userId: json['userId'],
      orderStatus: OrderStatus.fromString(json['orderStatus']),
      orderDate:
          json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      orderDetails: json['orderDetails'],
    );
  }

  // Convert OrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'eid': eid,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'assignee': assignee,
      'userId': userId,
      'orderStatus': orderStatus?.value,
      'orderDate': orderDate?.toIso8601String(),
      'orderDetails': orderDetails,
    };
  }
}
