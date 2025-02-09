class BiddingModel {
  int? orderId;
  String? productCatalog;
  int? volume;
  String? recycler;
  int? priceTag;

  BiddingModel(
      {this.orderId,
      this.productCatalog,
      this.volume,
      this.recycler,
      this.priceTag});

  BiddingModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productCatalog = json['productCatalog'];
    volume = json['volume'];
    recycler = json['recycler'];
    priceTag = json['priceTag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['productCatalog'] = this.productCatalog;
    data['volume'] = this.volume;
    data['recycler'] = this.recycler;
    data['priceTag'] = this.priceTag;
    return data;
  }
}
