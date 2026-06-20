import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';

class ErrorModel {
  final String message;
  ErrorModel(this.message);
}

// Set once at app startup (in main.dart) so this file has no direct dependency on UI screens.
void Function()? _onUnauthorized;
void setUnauthorizedCallback(void Function() cb) => _onUnauthorized = cb;

// Prevents multiple concurrent 401 responses from all firing _onUnauthorized.
// Resets automatically after enough time for all in-flight retries to drain.
bool _isHandlingUnauthorized = false;
void resetUnauthorizedHandling() => _isHandlingUnauthorized = false;

/// Creates a fully-configured Dio instance for the given [baseUrl].
/// All interceptors (JWT auth, logging, 401 handling) are wired here once.
Dio createDio(String baseUrl) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(minutes: 1),
    receiveTimeout: const Duration(minutes: 1),
  ));

  // Auth + default headers
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      if (kDebugMode) {
        log('→ ${options.method} ${options.uri}');
      }
      final token = await SecureStorageServices().getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      options.headers['Accept'] = 'application/json';
      options.headers['Content-Type'] = 'application/json';
      handler.next(options);
    },
  ));

  // Response logging
  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (response, handler) {
      if (kDebugMode) {
        log('← ${response.statusCode} ${response.requestOptions.uri}');
      }
      handler.next(response);
    },
  ));

  // Error handling — 401 clears session and navigates to login
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException e, handler) async {
      if (e.response?.statusCode == 401) {
        // Only fire once even if multiple concurrent requests all return 401.
        // Reset after 5 s so the next fresh login session is clean.
        if (!_isHandlingUnauthorized) {
          _isHandlingUnauthorized = true;
          await SecureStorageServices().logOut();
          _onUnauthorized?.call();
          Future.delayed(const Duration(seconds: 5),
              () => _isHandlingUnauthorized = false);
        }
        handler.reject(e);
        return;
      }
      if (kDebugMode) {
        log('✕ ${e.response?.statusCode} ${e.requestOptions.uri}: ${e.response?.data}');
      }
      handler.next(e);
    },
  ));

  return dio;
}

Map<String, String> requestEntityTooLarge(String data) {
  if (data.startsWith('<html>')) {
    return {'data': 'Please upload a smaller image.'};
  }
  return {};
}

Map<String, dynamic>? checkSocketException(dynamic e) {
  if (e is SocketException) {
    if (kDebugMode) log('SocketException: $e');
    return {'status': false, 'statusCode': 0, 'data': 'Network error: Please try again'};
  }
  return null;
}
