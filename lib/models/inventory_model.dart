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
  String? units;

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
      this.dateAndTime,
      this.units});

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
    return data;
  }
}

/// Order summary
/// created At
/// product Name
/// Grid photoes, when tappend ,enlarge
/// Order details
/// order id, name, address, created at, assignee, order details, status
