class UserModel {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address;
  List<String>? roles;
  String? lastLogin;

  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address,
    this.roles,
    this.lastLogin,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? json['id']?.toString();
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    roles = (json['roles'] as List?)?.cast<String>() ?? [];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'roles': roles,
      'lastLogin': lastLogin,
    };
  }
}

class UserRole {
  static const String admin = "admin";
  static const String deliveryAgent = "deliveryuser";
  static const String recycler = "recycler";
  static const String seller = "seller";
}
