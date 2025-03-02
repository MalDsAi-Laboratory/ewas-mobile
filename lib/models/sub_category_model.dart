class SubCategoryModel {
  int? productId;
  String? productName;
  String? category;
  String? materialDetails;
  String? imagePath;
  String? units;

  SubCategoryModel(
      {this.productId,
      this.productName,
      this.category,
      this.materialDetails,
      this.imagePath,
      this.units});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    category = json['category'];
    materialDetails = json['materialDetails'];
    imagePath = "http://93.229.113.153:8080/" + json['imagePath'];
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['category'] = this.category;
    data['materialDetails'] = this.materialDetails;
    data['imagePath'] = this.imagePath;
    data['units'] = this.units;
    return data;
  }
}
