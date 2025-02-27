class BiddingModel {
  String? orderId;
  String? productCatalog;
  double? volume;
  String? fullName;
  String? bidder;
  double? priceTag;

  BiddingModel(
      {this.orderId,
      this.productCatalog,
      this.volume,
      this.fullName,
      this.bidder,
      this.priceTag});

  BiddingModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productCatalog = json['productCatalog'];
    volume = json['volume'];
    fullName = json['fullName'];
    bidder = json['bidder'];
    priceTag = json['priceTag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['productCatalog'] = this.productCatalog;
    data['volume'] = this.volume;
    data['fullName'] = this.fullName;
    data['bidder'] = this.bidder;
    data['priceTag'] = this.priceTag;
    return data;
  }
}
