class CategoryModel {
  String? imagePath;
  String? category;

  CategoryModel({this.imagePath, this.category});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    imagePath = "http://93.229.113.153:8080/" + json['imagePath'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    data['category'] = this.category;
    return data;
  }
}
