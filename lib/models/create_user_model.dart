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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = this.userid;
    if (this.role != null) data['role'] = this.role;
    data['address'] = this.address;
    data['location'] = this.location;
    data['recyclerId'] = this.recyclerId ?? "none";
    data['recyclerLocations'] = this.recyclerLocations ?? "none";

    // location-service requires separate latitude/longitude Double fields.
    // Parse them from the combined "lat,lon" location string.
    if (this.location != null) {
      final parts = this.location!.split(',');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0].trim());
        final lon = double.tryParse(parts[1].trim());
        if (lat != null) data['latitude'] = lat;
        if (lon != null) data['longitude'] = lon;
      }
    }
    return data;
  }
}
