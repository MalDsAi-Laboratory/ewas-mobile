import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/app_screen.dart';
import 'package:simple_ui/services/apis/location/location_apis.dart';
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
  RxBool isLoading = false.obs;

  checkIfAnyFieldIsEmpty({bool? isLogin = false}) {
    if (isLogin!) {
      if (userId.value.isEmpty || password.value.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
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
  }

  bool areFieldsValidated() {
    if (!Validations.validateName(userId.value)) {
      AppSnackBars.showErrorSnackBar(
          "Error", "UserId should be atleast of length 4");
      return false;
    }
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
      isLoading.value = true;
      Map<String, dynamic> response = await createUserApi(data: userModel);
      if (response['status']) {
        Map<String, dynamic> response = await createUser2Api(
            data: CreateUserModel(
                address: selectedAddress.value,
                userid: userId.value,
                location:
                    "${selectedLatLng.value!.latitude},${selectedLatLng.value!.longitude}",
                role: userRole.value));
        if (response['status']) {
          tabController.animateTo(0);
          SecureStorageServices().setUserModel(userModel.toJson());
          SecureStorageServices().setUserLocation({
            "latitude": selectedLatLng.value!.latitude,
            "longitude": selectedLatLng.value!.longitude
          });
          clearFields();
          AppSnackBars.showSuccessSnackBar(
              "Success", 'You have registered successfully.\nPlease login.');
        } else {
          log("error in registerUser ${response['data']}");
          AppSnackBars.showErrorSnackBar("Error", response['data']);
        }
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

  void loginUser() async {
    try {
      if (checkIfAnyFieldIsEmpty(isLogin: true)) {
        AppSnackBars.showErrorSnackBar(
            "Error", "Please fill all the required fields");
        return;
      }
      isLoading.value = true;
      Map<String, dynamic> response =
          await getUserAccountPasswordApi(userId: userId.value);
      if (response['status']) {
        if (password.value.trim() == response['data']) {
          Map<String, dynamic> response =
              await getUserByUserIdApi(userId: userId.value);
          if (response['status']) {
            UserModel user = UserModel.fromJson(response['data']);
            if (user.roles![0] == UserRole.recycler ||
                user.roles![0] == UserRole.seller) {
              Map<String, dynamic> response2 =
                  await getRecyclersIds(userId.value);
              if (response2['status']) {
                await SecureStorageServices().setUserModel(response['data']);
                await SecureStorageServices().setUserLocation({
                  "latitude": response2['lat'],
                  "longitude": response2['long'],
                  "address": response2['address'] ?? ""
                });
                clearFields();
                Get.offAll(() =>
                    AppScreen(user: UserModel.fromJson(response['data'])));
                AppSnackBars.showSuccessSnackBar(
                    "Success", 'You have logged in successfully.');
              } else {
                AppSnackBars.showErrorSnackBar("Error", response['data']);
              }
            } else {
              await SecureStorageServices().setUserModel(response['data']);

              clearFields();
              Get.offAll(
                  () => AppScreen(user: UserModel.fromJson(response['data'])));
              AppSnackBars.showSuccessSnackBar(
                  "Success", 'You have logged in successfully.');
            }
          } else {
            AppSnackBars.showErrorSnackBar("Error", response['data']);
          }
        } else {
          AppSnackBars.showErrorSnackBar("Error", "Invalid credentials");
        }
      } else {
        AppSnackBars.showErrorSnackBar("Error", response['data']);
      }
    } catch (e) {
      log("error in loginUser $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getRecyclersIds(String userId) async {
    try {
      Map<String, dynamic> response = await getUserByUserIdApi2(userId: userId);
      if (response['status']) {
        CreateUserModel userModel = CreateUserModel.fromJson(response['data']);
        return {
          "status": true,
          "lat": double.parse(userModel.location!.split(',')[0]),
          "long": double.parse(userModel.location!.split(',')[1]),
          "address": userModel.address
        };
      } else {
        log("Error in fetching recyclerIds ${response['data']}");
        return {"status": false, "data": response['data']};
      }
    } catch (e) {
      log("Error in fetching recyclerIds ${e}");
      return {"status": false, "data": e};
    }
  }
}
