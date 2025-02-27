// class ProductModel {
//   int? productId;
//   String? productName;
//   String? category;
//   String? materialDetails;
//   String? imagePath;
//   String? imagePath2;
//   String? imagePath3;
//   String? imagePath4;
//   String? imagePath5;

//   ProductModel(
//       {this.productId,
//       this.productName,
//       this.category,
//       this.materialDetails,
//       this.imagePath,
//       this.imagePath2,
//       this.imagePath3,
//       this.imagePath4,
//       this.imagePath5});

//   ProductModel.fromJson(Map<String, dynamic> json) {
//     productId = json['productId'];
//     productName = json['productName'];
//     category = json['category'];
//     materialDetails = json['materialDetails'];
//     imagePath = json['imagePath'];
//     try {
//       imagePath2 = json['imagePath2'];
//       imagePath3 = json['imagePath3'];
//       imagePath4 = json['imagePath4'];
//       imagePath5 = json['imagePath5'];
//     } catch (e) {}
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['productId'] = this.productId;
//     data['productName'] = this.productName;
//     data['category'] = this.category;
//     data['materialDetails'] = this.materialDetails;
//     data['imagePath'] = this.imagePath;
//     try {
//       data['imagePath2'] = this.imagePath2;
//       data['imagePath3'] = this.imagePath3;
//       data['imagePath4'] = this.imagePath4;
//       data['imagePath5'] = this.imagePath5;
//     } catch (e) {}
//     return data;
//   }
// }
