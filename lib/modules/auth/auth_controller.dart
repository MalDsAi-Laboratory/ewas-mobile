import 'dart:developer';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/services/apis/user/user_apis.dart';
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class AuthController extends GetxController {
  RxBool isObscure = true.obs;
  RxBool isConfirmObscure = true.obs;
  RxString password = ''.obs;
  RxString userId = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString email = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString userRole = UserRole.seller.obs;
  var selectedLatLng = Rxn<LatLng>(); // Nullable LatLng
  var selectedAddress = "".obs;

  void setLocation(LatLng latLng, String address) {
    selectedLatLng.value = latLng;
    selectedAddress.value = address;
  }

  void clearLocation() {
    selectedLatLng.value = null;
    selectedAddress.value = "";
  }

  void registerUser() async {
    try {
      UserModel userModel = UserModel(
        userId: userId.value,
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        phoneNumber: mobileNumber.value,
        password: password.value,
        address: selectedAddress.value,
        roles: [userRole.value],
        lastLogin: DateTime.now().toUtc().toIso8601String(),
      );
      Map<String, dynamic> response = await createUserApi(data: userModel);
      if (response['status']) {
        AppSnackBars.showSuccessSnackBar(
            "Success", 'You have registered successfully');
      } else {
        log("error in registerUser ${response['data']}");
        AppSnackBars.showErrorSnackBar("Error", response['data']);
      }
    } catch (e) {
      log("error in registerUser $e");
    }
  }
}
