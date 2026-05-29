import 'dart:developer';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageServices {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _userModel = 'userModel';
  static const String _userLocation = 'userLocation';
  static const String _accessToken = 'accessToken';
  static const String _refreshToken = 'refreshToken';

  // User Model
  Future<void> setUserModel(Map<String, dynamic> userModel) async {
    await _secureStorage.write(key: _userModel, value: jsonEncode(userModel));
  }

  Future<Map<String, dynamic>?> getUserModel() async {
    final String? json = await _secureStorage.read(key: _userModel);
    if (json != null) {
      log('userModel loaded from storage');
      return jsonDecode(json) as Map<String, dynamic>;
    }
    return null;
  }

  // User Location
  Future<void> setUserLocation(Map<String, dynamic> userLocation) async {
    await _secureStorage.write(key: _userLocation, value: jsonEncode(userLocation));
  }

  Future<Map<String, dynamic>?> getUserLocation() async {
    final String? json = await _secureStorage.read(key: _userLocation);
    if (json != null) {
      log('userLocation loaded from storage');
      return jsonDecode(json) as Map<String, dynamic>;
    }
    return null;
  }

  // JWT Tokens
  Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: _accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessToken);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessToken);
    await _secureStorage.delete(key: _refreshToken);
  }

  // Logout — clears all stored data
  Future<void> logOut() async {
    await _secureStorage.deleteAll();
  }
}
