import 'package:get/get.dart';
import 'package:simple_ui/models/bidding_model.dart';
import 'package:simple_ui/services/apis/bidding/bidding_apis.dart';

class ProductController extends GetxController {
  List<BiddingModel> biddingList = [];
  RxBool isLoading = true.obs;

  void getBiddingDetails({String? orderId}) async {
    try {
      Map<String, dynamic> response = await getAllBiddingApi(orderId: orderId);
      if (response['status']) {
        List<BiddingModel> temp = [];
        for (var i = 0; i < response['data'].length; i++) {
          temp.add(BiddingModel.fromJson(response['data'][i]));
        }
        biddingList.assignAll(temp);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Method to get the highest bid price
  double? getHighestBidPrice() {
    if (biddingList.isEmpty) return null;
    return biddingList
        .map((b) => b.priceTag ?? 0)
        .reduce((a, b) => a > b ? a : b);
  }
}
