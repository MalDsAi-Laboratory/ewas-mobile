class CreateUserModel {
  String? userid;
  String? role;
  String? address;
  String? location;
  String? recyclerId;
  String? recyclerLocations;

  CreateUserModel(
      {this.userid,
      this.role,
      this.address,
      this.location,
      this.recyclerId,
      this.recyclerLocations});

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    role = json['role'];
    address = json['address'];
    location = json['location'];
    recyclerId = json['recyclerId'] ?? json['crossuserId'];
    recyclerLocations = json['recyclerLocations'] ?? json['crossuserLocations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    if (this.role != null) data['role'] = this.role;
    data['address'] = this.address;
    data['location'] = this.location;
    data['recyclerId'] = this.recyclerId ?? "none";
    data['recyclerLocations'] = this.recyclerLocations ?? "none";
    return data;
  }
}
