class SubCategoryModel {
  String? productName;
  String? category;
  String? materialDetails;
  String? imagePath;

  SubCategoryModel(
      {this.productName, this.category, this.materialDetails, this.imagePath});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    category = json['category'];
    materialDetails = json['materialDetails'];
    imagePath = "http://93.229.113.153:8080/" + json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['category'] = this.category;
    data['materialDetails'] = this.materialDetails;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
