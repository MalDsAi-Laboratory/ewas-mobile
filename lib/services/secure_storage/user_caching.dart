import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageServices {
  // Create secure storage instance
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Storage keys
  final String _userModel = 'userModel';
  final String _userLocation = 'userLocation';

  // User Mdoel
  Future<void> setUserModel(Map<String, dynamic> userModel) async {
    await _secureStorage.write(key: _userModel, value: jsonEncode(userModel));
  }

  Future<Map<String, dynamic>?> getUserModel() async {
    final String? userModelJson = await _secureStorage.read(key: _userModel);
    if (userModelJson != null) {
      log("userModelJson is $userModelJson");
      return jsonDecode(userModelJson) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  // User Location
  Future<void> setUserLocation(Map<String, dynamic> userLocation) async {
    await _secureStorage.write(
        key: _userLocation, value: jsonEncode(userLocation));
  }

  Future<Map<String, dynamic>?> getUserLocation() async {
    final String? userLocationJson =
        await _secureStorage.read(key: _userLocation);
    if (userLocationJson != null) {
      log("userLocationJson is $userLocationJson");
      return jsonDecode(userLocationJson) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  // Logout (Clear all storage)
  Future<void> logOut() async {
    await _secureStorage.deleteAll();
    await FirebaseMessaging.instance.deleteToken();
  }
}
