import 'dart:developer';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/models/product_details_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/services/apis/product_details/product_details_api.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';

class LocateRecyclersController extends GetxController {
  Rx<CreateUserModel> model = CreateUserModel().obs;
  RxList<ProductDetailsModel> inventories = RxList<ProductDetailsModel>();
  String? productId;
  LocateRecyclersController({this.productId});
  Rx<LatLng?> currentLocation = LatLng(27, 23).obs;
  Rx<ProductDetailsModel> selectedRecycler = ProductDetailsModel().obs;
  RxBool isLoading = true.obs;

  Future<void> getInventories() async {
    try {
      Map<String, dynamic> response =
          await getProductPricingApi(productId: productId);
      if (response['status']) {
        inventories.clear();
        List<ProductDetailsModel> temp = [];
        for (var i = 0; i < response['data'].length; i++) {
          ProductDetailsModel model =
              ProductDetailsModel.fromJson(response['data'][i]);
          if (model.latitudeLongitude != null &&
              model.latitudeLongitude!.split(",").length > 1) {
            temp.add(model);
          }
          ;
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
        setUserLocation(),
        getInventories(),
      ]);
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

  Future<void> setUserLocation() async {
    try {
      Map<String, dynamic> location =
          await SecureStorageServices().getUserLocation() ?? {};
      final lat = location['latitude'];
      final lon = location['longitude'];
      if (lat != null && lon != null) {
        currentLocation.value = LatLng(
          (lat is double) ? lat : double.tryParse(lat.toString()) ?? 20.5937,
          (lon is double) ? lon : double.tryParse(lon.toString()) ?? 78.9629,
        );
      } else {
        // Default to center of India when no location cached
        currentLocation.value = LatLng(20.5937, 78.9629);
      }
    } catch (e) {
      log("Error in fetching user location: $e");
      currentLocation.value = LatLng(20.5937, 78.9629);
    }
  }

  @override
  void onInit() {
    super.onInit();
    String role = Get.find<MainScreenController>().user?.roles![0] ?? "";
    if (role == UserRole.seller || role == UserRole.recycler) {
      fetchDataSimultaneously();
    } else {
      isLoading.value = false;
    }
  }
}
