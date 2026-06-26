import 'dart:io';

class InventoryModel {
  String? productId;
  String? orderId;
  String? volume;
  double? mbp;
  String? category;
  String? materialType;
  String? productName;
  String? imgPath1;
  String? imgPath2;
  String? imgPath3;
  String? imgPath4;
  String? imgPath5;
  String? dateAndTime;
  String? units;
  String? description;

  InventoryModel({
    this.productId,
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
    this.dateAndTime,
    this.units,
    this.mbp,
    this.description,
  });

  InventoryModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    orderId = json['orderId'];
    volume = json['volume'];
    category = json['category'];
    materialType = json['materialType'];
    productName = json['productName'];
    imgPath1 = json['imgPath1'] != null
        ? "http://93.229.113.153:8080${json['imgPath1']}"
        : null;
    imgPath2 = json['imgPath2'] != null
        ? "http://93.229.113.153:8080${json['imgPath2']}"
        : null;
    imgPath3 = json['imgPath3'] != null
        ? "http://93.229.113.153:8080${json['imgPath3']}"
        : null;
    imgPath4 = json['imgPath4'] != null
        ? "http://93.229.113.153:8080${json['imgPath4']}"
        : null;
    imgPath5 = json['imgPath5'] != null
        ? "http://93.229.113.153:8080${json['imgPath5']}"
        : null;
    dateAndTime = json['dateAndTime'];
    units = json['units'];
    mbp = json['mbp'];
    description = json['description'];
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
    data['units'] = this.units;
    data['mbp'] = this.mbp;
    data['description'] = this.description;
    return data;
  }
}

class SubsidiaryInventoryModel {
  String? productId;
  String? orderId;
  String? volume;
  double? mbp;
  String? category;
  String? materialType;
  String? productName;
  File? imgPath1;
  File? imgPath2;
  File? imgPath3;
  File? imgPath4;
  File? imgPath5;
  String? dateAndTime;
  String? units;

  SubsidiaryInventoryModel({
    this.productId,
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
    this.dateAndTime,
    this.units,
    this.mbp,
  });

  SubsidiaryInventoryModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'].toString();
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
    units = json['units'];
    mbp = double.parse(json['minimum_base_price']);
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
    data['units'] = this.units;
    data['mbp'] = this.mbp;
    return data;
  }
}
