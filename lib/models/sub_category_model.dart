class SubCategoryModel {
  int? productId;
  String? productName;
  String? category;
  String? materialDetails;
  String? imagePath;
  String? units;
  String? scale;

  SubCategoryModel(
      {this.productId,
      this.productName,
      this.category,
      this.materialDetails,
      this.imagePath,
      this.units,
      this.scale});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    category = json['category'];
    materialDetails = json['materialDetails'];
    final raw = json['imagePath']?.toString() ?? '';
    imagePath = raw.startsWith('http') ? raw : '';
    units = json['units'];
    scale = json['scale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['category'] = this.category;
    data['materialDetails'] = this.materialDetails;
    data['imagePath'] = this.imagePath;
    data['units'] = this.units;
    data['scale'] = this.scale;
    return data;
  }
}
