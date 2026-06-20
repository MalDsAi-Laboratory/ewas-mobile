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
        await SecureStorageServices().logOut();
        _onUnauthorized?.call();
        // Reject with DioExceptionType.cancel so RetryOptions.retryIf
        // (which matches DioException) does NOT fire a second attempt —
        // retrying an expired-token request would just trigger a second
        // _onUnauthorized call and cause the login-page flicker.
        handler.reject(DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          error: 'Session expired',
          type: DioExceptionType.cancel,
        ));
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
