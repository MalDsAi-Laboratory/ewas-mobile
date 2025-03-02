class CreateUserModel {
  String? userid;
  String? role;
  String? address;
  String? location;
  String? crossuserId;
  String? crossuserLocations;

  CreateUserModel(
      {this.userid,
      this.role,
      this.address,
      this.location,
      this.crossuserId,
      this.crossuserLocations});

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    role = json['role'];
    address = json['address'];
    location = json['location'];
    crossuserId = json['crossuserId'];
    crossuserLocations = json['crossuserLocations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['role'] = this.role;
    data['address'] = this.address;
    data['location'] = this.location;
    data['crossuserId'] = this.crossuserId;
    data['crossuserLocations'] = this.crossuserLocations;
    return data;
  }
}
