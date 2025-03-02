class ProductDetailsModel {
  int? id;
  String? userId;
  String? address;
  String? latitudeLongitude;
  int? productId;
  String? productName;
  String? category;
  String? materialDetails;
  double? price;
  String? unit;

  ProductDetailsModel(
      {this.id,
      this.userId,
      this.address,
      this.latitudeLongitude,
      this.productId,
      this.productName,
      this.category,
      this.materialDetails,
      this.price,
      this.unit});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    address = json['address'];
    latitudeLongitude = json['latitudeLongitude'];
    productId = json['productId'];
    productName = json['productName'];
    category = json['category'];
    materialDetails = json['materialDetails'];
    price = json['price'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['address'] = this.address;
    data['latitudeLongitude'] = this.latitudeLongitude;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['category'] = this.category;
    data['materialDetails'] = this.materialDetails;
    data['price'] = this.price;
    data['unit'] = this.unit;
    return data;
  }
}
