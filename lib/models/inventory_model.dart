class InventoryModel {
  String? productId;
  String? orderId;
  String? volume;
  String? category;
  String? materialType;
  String? productName;
  String? imgPath1;
  String? imgPath2;
  String? imgPath3;
  String? imgPath4;
  String? imgPath5;
  String? dateAndTime;

  InventoryModel(
      {this.productId,
      this.orderId,
      this.volume,
      this.category,
      this.materialType,
      this.productName,
      this.imgPath1,
      this.imgPath2,
      this.imgPath3,
      this.imgPath4,
      this.imgPath5,
      this.dateAndTime});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    orderId = json['orderId'];
    volume = json['volume'];
    category = json['category'];
    materialType = json['materialType'];
    productName = json['productName'];
    imgPath1 = json['imgPath1'];
    imgPath2 = json['imgPath2'];
    imgPath3 = json['imgPath3'];
    imgPath4 = json['imgPath4'];
    imgPath5 = json['imgPath5'];
    dateAndTime = json['dateAndTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['orderId'] = this.orderId;
    data['volume'] = this.volume;
    data['category'] = this.category;
    data['materialType'] = this.materialType;
    data['productName'] = this.productName;
    data['imgPath1'] = this.imgPath1;
    data['imgPath2'] = this.imgPath2;
    data['imgPath3'] = this.imgPath3;
    data['imgPath4'] = this.imgPath4;
    data['imgPath5'] = this.imgPath5;
    data['dateAndTime'] = this.dateAndTime;
    return data;
  }
}
