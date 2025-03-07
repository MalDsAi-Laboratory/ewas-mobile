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
  RxString firstName = 'honey'.obs;
  RxString lastName = 'bansal'.obs;
  RxString mobileNumber = '1234567890'.obs;
  RxString email = 'savage@gmail.com'.obs;
  var selectedLatLng = Rxn<LatLng>(); // Nullable LatLng
  var selectedAddress = "".obs;
  RxBool isLoading = false.obs;
  RxBool isDataInitializing = true.obs;

  checkIfAnyFieldIsEmpty({bool? isLogin = false}) {
    if (firstName.value.isEmpty ||
        lastName.value.isEmpty ||
        mobileNumber.value.isEmpty ||
        email.value.isEmpty ||
        selectedAddress.value.isEmpty) {
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
      AppSnackBars.showErrorSnackBar("Error", "Passwords don't match");
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

  void clearFields() {
    firstName.value = "";
    lastName.value = "";
    mobileNumber.value = "";
    email.value = "";
    clearLocation();
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
        SecureStorageServices().setUserLocation({
          "latitude": selectedLatLng.value!.latitude,
          "longitude": selectedLatLng.value!.longitude
        });
        clearFields();
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
  void onInit() {
    super.onInit();
    UserModel model = Get.find<MainScreenController>().user!;
    firstName.value = model.firstName!;
    lastName.value = model.lastName!;
    mobileNumber.value = model.phoneNumber!;
    email.value = model.email!;
  }
}
