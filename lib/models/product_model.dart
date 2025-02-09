class ProductModel {
  int? productId;
  String? productName;
  String? category;
  String? materialDetails;
  String? imagePath;

  ProductModel(
      {this.productId,
      this.productName,
      this.category,
      this.materialDetails,
      this.imagePath});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    category = json['category'];
    materialDetails = json['materialDetails'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['category'] = this.category;
    data['materialDetails'] = this.materialDetails;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
