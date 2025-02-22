import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/services/apis/user/user_apis.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
import 'package:simple_ui/services/validation_field.dart';
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class AuthController extends GetxController {
  RxBool isObscure = true.obs;
  RxBool isConfirmObscure = true.obs;
  RxString password = '&honeyB90'.obs;
  RxString confirmPassword = '&honeyB90'.obs;
  RxString userId = 'honey123'.obs;
  RxString firstName = 'honey'.obs;
  RxString lastName = 'bansal'.obs;
  RxString mobileNumber = '1234567890'.obs;
  RxString email = 'savage@gmail.com'.obs;
  RxString userRole = UserRole.seller.obs;
  var selectedLatLng = Rxn<LatLng>(); // Nullable LatLng
  var selectedAddress = "".obs;
  late TabController tabController;

  checkIfAnyFieldIsEmpty() {
    if (userId.value.isEmpty ||
        firstName.value.isEmpty ||
        lastName.value.isEmpty ||
        mobileNumber.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty ||
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
    if (!Validations.validatePassword(password.value)) {
      AppSnackBars.showErrorSnackBar("Error", "Weak password");
      return false;
    }
    if (!Validations.validateConfirmPassword(
        password.value, confirmPassword.value)) {
      AppSnackBars.showErrorSnackBar("Error", "Passwords don't match");
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
    userId.value = "";
    firstName.value = "";
    lastName.value = "";
    mobileNumber.value = "";
    email.value = "";
    password.value = "";
    confirmPassword.value = "";
    userRole.value = UserRole.seller;
    clearLocation();
  }

  void registerUser() async {
    try {
      if (checkIfAnyFieldIsEmpty()) {
        AppSnackBars.showErrorSnackBar(
            "Error", "Please fill all the required fields");
        return;
      }
      if (!areFieldsValidated()) {
        return;
      }
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
        tabController.animateTo(0);
        SecureStorageServices().setUserModel(userModel.toJson());
        clearFields();

        AppSnackBars.showSuccessSnackBar(
            "Success", 'You have registered successfully.\nPlease login.');
      } else {
        log("error in registerUser ${response['data']}");
        AppSnackBars.showErrorSnackBar("Error", response['data']);
      }
    } catch (e) {
      log("error in registerUser $e");
    }
  }
}
