import 'dart:developer';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/main_screen_controller.dart';
import 'package:simple_ui/services/apis/location/location_apis.dart';
import 'package:simple_ui/services/apis/user/user_apis.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
import 'package:simple_ui/services/validation_field.dart';
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class ProfileController extends GetxController {
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString email = ''.obs;
  var selectedLatLng = Rxn<LatLng>(); // Nullable LatLng
  var selectedAddress = "".obs;
  RxBool isLoading = false.obs;
  RxBool isDataInitializing = true.obs;

  checkIfAnyFieldIsEmpty({bool? isLogin = false}) {
    if (firstName.value.isEmpty ||
        lastName.value.isEmpty ||
        mobileNumber.value.isEmpty ||
        email.value.isEmpty ||
        (Get.find<MainScreenController>().user?.roles![0] == UserRole.seller ||
                Get.find<MainScreenController>().user?.roles![0] ==
                    UserRole.recycler
            ? selectedAddress.value.isEmpty
            : false)) {
      return true;
    }
    return false;
  }

  bool areFieldsValidated() {
    if (!Validations.isEmail(email.value)) {
      AppSnackBars.showErrorSnackBar("Error", "Invalid email");
      return false;
    }
    if (!Validations.validateMobile(mobileNumber.value)) {
      AppSnackBars.showErrorSnackBar("Error", "Mobile number is not valid");
      return false;
    }
    return true;
  }

  void setLocation(LatLng latLng, String address) {
    selectedLatLng.value = latLng;
    selectedAddress.value = address;
  }

  void clearLocation() {
    selectedLatLng.value = null;
    selectedAddress.value = "";
  }

  void updateUser() async {
    try {
      if (checkIfAnyFieldIsEmpty()) {
        AppSnackBars.showErrorSnackBar(
            "Error", "Please fill all the required fields");
        return;
      }
      if (!areFieldsValidated()) {
        return;
      }
      UserModel model = Get.find<MainScreenController>().user!;
      
      UserModel userModel = UserModel(
        userId: model.userId,
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        phoneNumber: mobileNumber.value,
        address: selectedAddress.value,
        roles: model.roles,
        lastLogin: DateTime.now().toUtc().toIso8601String(),
      );
        isLoading.value = true;
        Map<String, dynamic> response = await updateUserApi(data: userModel);
        if (response['status']) {
          SecureStorageServices().setUserModel(userModel.toJson());
          if (Get.find<MainScreenController>().user?.roles![0] ==
                  UserRole.seller ||
              Get.find<MainScreenController>().user?.roles![0] ==
                  UserRole.recycler) {
            await updateUser2Api(
                data: CreateUserModel(
                    userid: model.userId,
                    role: model.roles![0],
                    location:
                        "${selectedLatLng.value!.latitude},${selectedLatLng.value!.longitude}",
                    address: selectedAddress.value));
            SecureStorageServices().setUserLocation({
              "latitude": selectedLatLng.value!.latitude,
              "longitude": selectedLatLng.value!.longitude,
              "address": selectedAddress.value
            });
          }
          AppSnackBars.showSuccessSnackBar(
              "Success", 'Updated profile successfully.');
        } else {
          log("error in registerUser ${response['data']}");
          AppSnackBars.showErrorSnackBar("Error", response['data']);
        }
    } catch (e) {
      log("error in registerUser $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRecyclersIds() async {
    try {
      Map<String, dynamic> response = await getUserByUserIdApi2(
          userId: Get.find<MainScreenController>().user?.userId ?? "");
      if (response['status']) {
        CreateUserModel userModel = CreateUserModel.fromJson(response['data']);
        selectedLatLng.value = LatLng(
          double.parse(userModel.location!.split(',')[0]),
          double.parse(userModel.location!.split(',')[1]),
        );
        selectedAddress.value = userModel.address!;
      } else {
        log("Error in fetching recyclerIds ${response['data']}");
      }
    } catch (e) {
      log("Error in fetching recyclerIds ${e}");
    } finally {
      isDataInitializing.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    UserModel model = Get.find<MainScreenController>().user!;
    firstName.value = model.firstName!;
    lastName.value = model.lastName!;
    mobileNumber.value = model.phoneNumber!;
    email.value = model.email!;
    Map<String, dynamic> location =
        await SecureStorageServices().getUserLocation() ?? {};
    if (location.containsKey("latitude") && location.containsKey("longitude")) {
      selectedLatLng.value =
          LatLng(location['latitude'], location['longitude']);
      selectedAddress.value = location['address'];
    }
  }
}
