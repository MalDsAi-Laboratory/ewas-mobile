import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/modules/main_module/app_screen.dart';
import 'package:simple_ui/services/apis/location/location_apis.dart';
import 'package:simple_ui/services/apis/user/user_apis.dart';
import 'package:simple_ui/services/google_sign_in_service.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
import 'package:simple_ui/services/validation_field.dart';
import 'package:simple_ui/ui_utils/app_snackbars.dart';

class AuthController extends GetxController {
  RxBool isObscure = true.obs;
  RxBool isConfirmObscure = true.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString userId = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString email = ''.obs;
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
      // Registration payload includes password for the API call only.
      // Password is discarded immediately after — never persisted.
      final registrationPayload = {
        'userId': userId.value,
        'firstName': firstName.value,
        'lastName': lastName.value,
        'email': email.value,
        'phoneNumber': mobileNumber.value,
        'password': password.value,
        'address': selectedAddress.value,
        'roles': [userRole.value],
        'lastLogin': DateTime.now().toUtc().toIso8601String(),
      };
      isLoading.value = true;
      Map<String, dynamic> response = await createUserApi(data: registrationPayload);
      if (response['status']) {
        // Save the JWT from the registration response BEFORE calling the
        // location service. Without this the location call goes out with no
        // Authorization header → 401 → _onUnauthorized fires mid-registration,
        // navigates back to AuthScreen, and crashes the TabController.
        final registrationToken = response['data']?['token'] as String?;
        if (registrationToken != null) {
          await SecureStorageServices().setAccessToken(registrationToken);
        }

        // Persist user model without password.
        final userModel = UserModel(
          userId: userId.value,
          firstName: firstName.value,
          lastName: lastName.value,
          email: email.value,
          phoneNumber: mobileNumber.value,
          address: selectedAddress.value,
          roles: [userRole.value],
          lastLogin: DateTime.now().toUtc().toIso8601String(),
        );
        SecureStorageServices().setUserModel(userModel.toJson());
        SecureStorageServices().setUserLocation({
          "latitude": selectedLatLng.value!.latitude,
          "longitude": selectedLatLng.value!.longitude
        });

        // Attempt to register seller location — non-blocking.
        try {
          Map<String, dynamic> locationResponse = await createUser2Api(
              data: CreateUserModel(
                  address: selectedAddress.value,
                  userid: userId.value,
                  location:
                      "${selectedLatLng.value!.latitude},${selectedLatLng.value!.longitude}",
                  role: userRole.value));
          if (!locationResponse['status']) {
            log("Warning: seller-location registration failed: ${locationResponse['data']}");
          }
        } catch (e) {
          log("Warning: seller-location service unavailable: $e");
        }

        // Clear the temp token so the splash screen doesn't auto-login;
        // the user should sign in manually to complete their session.
        await SecureStorageServices().clearTokens();

        tabController.animateTo(0);
        clearFields();
        AppSnackBars.showSuccessSnackBar(
            "Success", 'You have registered successfully.\nPlease login.');
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
          await loginUserApi(email: userId.value, password: password.value);
      if (response['status']) {
        UserModel user = UserModel.fromJson(response['data']);
        
        final token = response['data']['token'] as String?;
        if (token != null) await SecureStorageServices().setAccessToken(token);

        if (user.roles != null && user.roles!.isNotEmpty &&
           (user.roles![0] == UserRole.recycler || user.roles![0] == UserRole.seller)) {
          // Try to fetch seller location from scheduling service.
          // If the service is down, log in anyway using locally cached location.
          Map<String, dynamic> response2 = await getRecyclersIds(user.userId ?? "");
          await SecureStorageServices().setUserModel(response['data']);
          if (response2['status']) {
            await SecureStorageServices().setUserLocation({
              "latitude": response2['lat'],
              "longitude": response2['long'],
              "address": response2['address'] ?? ""
            });
          } else {
            log("Warning: seller-location fetch failed (service may be down): ${response2['data']}");
          }
          clearFields();
          Get.offAll(() => AppScreen(user: user));
          AppSnackBars.showSuccessSnackBar("Success", 'You have logged in successfully.');
        } else {
          await SecureStorageServices().setUserModel(response['data']);
          clearFields();
          Get.offAll(() => AppScreen(user: user));
          AppSnackBars.showSuccessSnackBar('Success', 'You have logged in successfully.');
        }
      } else {
        AppSnackBars.showErrorSnackBar("Error", response['data']?.toString() ?? "Invalid credentials");
      }
    } catch (e) {
      log("error in loginUser $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Sign-In flow.
  /// [role] is passed only when creating a new account — existing users keep their role.
  void loginWithGoogle({String role = 'user'}) async {
    try {
      isLoading.value = true;

      final result = await GoogleSignInService.signIn();
      if (result == null) return; // User cancelled — silent

      final response = await loginWithGoogleApi(idToken: result.idToken, role: role);
      if (response['status']) {
        final user = UserModel.fromJson(response['data']);
        final googleToken = response['data']['token'] as String?;
        if (googleToken != null) await SecureStorageServices().setAccessToken(googleToken);
        await SecureStorageServices().setUserModel(response['data']);

        // Try to fetch location from scheduling service (non-blocking)
        if (user.roles != null && user.roles!.isNotEmpty) {
          try {
            final locResp = await getRecyclersIds(user.userId ?? '');
            if (locResp['status']) {
              await SecureStorageServices().setUserLocation({
                'latitude': locResp['lat'],
                'longitude': locResp['long'],
                'address': locResp['address'] ?? '',
              });
            }
          } catch (_) {}
        }

        clearFields();
        Get.offAll(() => AppScreen(user: user));
        AppSnackBars.showSuccessSnackBar('Welcome!', 'Signed in as ${result.displayName}');
      } else {
        AppSnackBars.showErrorSnackBar('Error', response['data']?.toString() ?? 'Google sign-in failed');
      }
    } catch (e) {
      log('loginWithGoogle error: $e');
      // Show the actual error message so we can diagnose SHA-1 / token issues
      final msg = e.toString().replaceFirst('Exception: ', '');
      AppSnackBars.showErrorSnackBar('Google Sign-In Failed', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getRecyclersIds(String userId) async {
    try {
      Map<String, dynamic> response = await getUserByUserIdApi2(userId: userId);
      if (response['status']) {
        CreateUserModel userModel = CreateUserModel.fromJson(response['data']);
        final parts = userModel.location?.split(',') ?? [];
        if (parts.length < 2) {
          return {"status": false, "data": "Invalid location format"};
        }
        final lat = double.tryParse(parts[0]);
        final lng = double.tryParse(parts[1]);
        if (lat == null || lng == null) {
          return {"status": false, "data": "Could not parse location coordinates"};
        }
        return {"status": true, "lat": lat, "long": lng, "address": userModel.address};
      } else {
        log("Error in fetching recyclerIds ${response['data']}");
        return {"status": false, "data": response['data']};
      }
    } catch (e) {
      log("Error in fetching recyclerIds $e");
      return {"status": false, "data": e.toString()};
    }
  }
}
