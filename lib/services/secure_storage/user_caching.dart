import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageServices {
  // Create secure storage instance
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Storage keys
  final String _userModel = 'userModel';

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

  // Logout (Clear all storage)
  Future<void> logOut() async {
    await _secureStorage.deleteAll();
  }
}
