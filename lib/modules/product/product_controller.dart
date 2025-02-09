import 'package:get/get.dart';
import 'package:simple_ui/models/bidding_model.dart';

List<BiddingModel> dummyBids = [
  BiddingModel(
    orderId: 101,
    productCatalog: "Plastic Bottles",
    volume: 500,
    recycler: "Green Recycle Ltd.",
    priceTag: 2000,
  ),
  BiddingModel(
    orderId: 102,
    productCatalog: "E-Waste Circuit Boards",
    volume: 300,
    recycler: "EcoTech Recycling",
    priceTag: 5000,
  ),
  BiddingModel(
    orderId: 103,
    productCatalog: "Used Laptop Batteries",
    volume: 200,
    recycler: "Safe Energy Recycle",
    priceTag: 3500,
  ),
  BiddingModel(
    orderId: 104,
    productCatalog: "Scrap Aluminum Cans",
    volume: 1000,
    recycler: "Metal Recyclers Inc.",
    priceTag: 1800,
  ),
  BiddingModel(
    orderId: 105,
    productCatalog: "Old Smartphones",
    volume: 150,
    recycler: "Urban E-Waste Solutions",
    priceTag: 7500,
  ),
  BiddingModel(
    orderId: 106,
    productCatalog: "Discarded Wires & Cables",
    volume: 400,
    recycler: "Cable Green Recycling",
    priceTag: 2700,
  ),
];

class ProductController extends GetxController {
  List<BiddingModel> biddingList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    biddingList.assignAll(dummyBids);
  }
}
