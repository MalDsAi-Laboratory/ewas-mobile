import 'dart:developer';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/models/product_details_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/services/apis/location/location_apis.dart';
import 'package:simple_ui/services/apis/product_details/product_details_api.dart';

class LocateRecyclersController extends GetxController {
  Rx<CreateUserModel> model = CreateUserModel().obs;
  RxMap<String, LatLng> recyclersIdsAndLocations = RxMap<String, LatLng>();
  RxList<ProductDetailsModel> inventories = RxList<ProductDetailsModel>();
  String? productId;
  LocateRecyclersController({this.productId});
  Rx<LatLng?> currentLocation = LatLng(27, 23).obs;
  Rx<ProductDetailsModel> selectedRecycler = ProductDetailsModel().obs;

  RxBool isLoading = true.obs;
  Future<void> getRecyclersIds() async {
    try {
      Map<String, dynamic> response = await getUserByUserIdApi2(
          userId: Get.find<MainScreenController>().user?.userId ?? "");
      if (response['status']) {
        List<String> recyclerIds = [];
        List<String> locationCoords = [];
        CreateUserModel userModel = CreateUserModel.fromJson(response['data']);
        currentLocation.value = LatLng(
          double.parse(userModel.location!.split(',')[0]),
          double.parse(userModel.location!.split(',')[1]),
        );
        // split the userModel.crossuserId by ;
        recyclerIds = userModel.crossuserId!.split(';');
        locationCoords = userModel.crossuserLocations!.split(';');
        for (int i = 0; i < recyclerIds.length; i++) {
          recyclersIdsAndLocations[recyclerIds[i]] = LatLng(
              double.parse(locationCoords[i].split(',')[0]),
              double.parse(locationCoords[i].split(',')[1]));
        }
        log("recyclerIds ${recyclerIds}");
        log("locationCoords ${locationCoords}");
      } else {
        log("Error in fetching recyclerIds ${response['data']}");
      }
    } catch (e) {
      log("Error in fetching recyclerIds ${e}");
    }
  }

  Future<void> getInventories() async {
    try {
      Map<String, dynamic> response =
          await getProductPricingApi(productId: productId);
      if (response['status']) {
        inventories.clear();
        List<ProductDetailsModel> temp = [];
        for (var i = 0; i < response['data'].length; i++) {
          temp.add(ProductDetailsModel.fromJson(response['data'][i]));
        }
        inventories.assignAll(temp);
      } else {
        log("Error in fetching inventories ${response['data']}");
      }
    } catch (e) {
      log("Error in fetching inventories ${e}");
    }
  }

  Future<void> fetchDataSimultaneously() async {
    try {
      await Future.wait([
        getRecyclersIds(),
        getInventories(),
      ]);
      // keep only those inventories whose userid is present in recyclerIdsAndLocations
      List<ProductDetailsModel> temp = inventories
          .where((inventory) =>
              recyclersIdsAndLocations.containsKey(inventory.userId))
          .toList();
      inventories.value = temp;
      if (inventories.isNotEmpty) {
        selectedRecycler.value = inventories[0];
        update();
      }
      log("Both API calls completed successfully");
    } catch (e) {
      log("Error in fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDataSimultaneously();
  }
}
