class UserQueryModel {
  String? userName;
  String? query;
  String? status;

  UserQueryModel({this.userName, this.query, this.status});

  factory UserQueryModel.fromJson(Map<String, dynamic> json) {
    return UserQueryModel(
      userName: json['userName'],
      query: json['query'],
      status: json['status'],
    );
  }
}
