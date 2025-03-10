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
  String? fcmToken;
  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.password,
    this.address,
    this.roles,
    this.lastLogin,
    this.fcmToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    address = json['address'];
    roles = json['roles']?.cast<String>();
    lastLogin = json['lastLogin'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['address'] = address;
    data['roles'] = roles;
    data['lastLogin'] = lastLogin;
    data['fcmToken'] = fcmToken;
    return data;
  }

  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? address,
    List<String>? roles,
    String? lastLogin,
    String? fcmToken,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      address: address ?? this.address,
      roles: roles ?? this.roles,
      lastLogin: lastLogin ?? this.lastLogin,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

class UserRole {
  static const String admin = "Admin";
  static const String deliveryAgent = "DeliveryUser";
  static const String recycler = "Recycler";
  static const String seller = "Seller";
}
