class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert UserModel to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last, // Store as string
    };
  }

  // Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'], // Default role
    );
  }
}

// enum UserRole { admin, deliveryAgent, seller, recycler }

class UserRole {
  static const String admin = "admin";
  static const String deliveryAgent = "delivery user";
  static const String recycler = "recycler";
  static const String seller = "seller";
  static const String generalUser = "user";
}
