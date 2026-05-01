class CategoryModel {
  String? imagePath;
  String? category;

  CategoryModel({this.imagePath, this.category});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    final raw = json['imagePath']?.toString() ?? '';
    // Use URL as-is if it's already absolute, otherwise skip prepending old prod host
    imagePath = raw.startsWith('http') ? raw : '';
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    data['category'] = this.category;
    return data;
  }
}
