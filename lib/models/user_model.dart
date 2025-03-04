class UserModel {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? password;
  String? address;
  List<String>? roles;
  String? lastLogin;

  UserModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.password,
      this.address,
      this.roles,
      this.lastLogin});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    address = json['address'];
    roles = json['roles'].cast<String>();
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['address'] = this.address;
    data['roles'] = this.roles;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}

class UserRole {
  static const String admin = "Admin";
  static const String deliveryAgent = "DeliveryUser";
  static const String recycler = "Recycler";
  static const String seller = "Seller";
}
