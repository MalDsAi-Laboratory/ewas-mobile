import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/services/apis/user/user_api_services.dart';
import 'package:simple_ui/services/load_env.dart';

/// Singleton for user CRUD calls (baseUrl = /api/v1/users)
Dio dio = UserDioSingleton.instance;

/// Plain Dio with no baseUrl, used for auth endpoints that live outside /users
final Dio _authDio = Dio(
  BaseOptions(
    connectTimeout: const Duration(minutes: 1),
    receiveTimeout: const Duration(minutes: 1),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ),
);

/// Derives the auth base URL from userBaseUrl by stripping /api/v1/users -> /api/v1/auth
String get _authBaseUrl => userBaseUrl.replaceFirst('/api/v1/users', '/api/v1/auth');

// Accepts raw map so the password can be included for registration without
// storing it in UserModel (which is used for persistence).
Future<Map<String, dynamic>> createUserApi({required Map<String, dynamic> data}) async {
  try {
    if (kDebugMode) log('createUserApi payload keys: ${data.keys.toList()}');
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => _authDio.post('$_authBaseUrl/register', data: jsonEncode(data)),
      retryIf: (e) => e is SocketException || (e is DioException && e.response == null),
    );
    return {'status': true, 'statusCode': response.statusCode, 'data': response.data};
  } catch (e) {
    if (e is DioException && e.response != null) {
      return {
        'status': false,
        'statusCode': e.response?.statusCode ?? 0,
        'data': e.response?.data?['message'] ?? 'Registration failed',
      };
    }
    Map<String, dynamic>? result = checkSocketException(e);
    if (result != null) return result;
    if (kDebugMode) log('createUserApi error: $e');
    return {'status': false, 'statusCode': 0, 'data': 'Something went wrong'};
  }
}

/// Sends the Google ID token to the backend for verification.
/// The backend verifies with Google, then creates/finds the user and returns a JWT.
Future<Map<String, dynamic>> loginWithGoogleApi({
  required String idToken,
  String role = 'user',
}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => _authDio.post(
        '$_authBaseUrl/google',
        data: jsonEncode({'idToken': idToken, 'role': role}),
      ),
      retryIf: (e) => e is SocketException || (e is DioException && e.response == null),
    );
    return {'status': true, 'statusCode': response.statusCode, 'data': response.data};
  } catch (e) {
    if (e is DioException && e.response != null) {
      return {
        'status': false,
        'statusCode': e.response?.statusCode ?? 0,
        'data': e.response?.data?['message'] ?? 'Google login failed',
      };
    }
    Map<String, dynamic>? result = checkSocketException(e);
    if (result != null) return result;
    if (kDebugMode) log('loginWithGoogleApi error: $e');
    return {'status': false, 'statusCode': 0, 'data': 'Something went wrong'};
  }
}

Future<Map<String, dynamic>> loginUserApi({required String email, required String password}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => _authDio.post(
        '$_authBaseUrl/login',
        data: jsonEncode({"email": email, "password": password}),
      ),
      retryIf: (e) => e is SocketException || (e is DioException && e.response == null),
    );
    return {
      "status": true,
      "statusCode": response.statusCode,
      "data": response.data,
    };
  } catch (e) {
    if (e is DioException && e.response != null) {
      return {
        "status": false,
        "statusCode": e.response?.statusCode ?? 0,
        "data": e.response?.data?['message'] ?? 'Login failed',
      };
    }
    return {"status": false, "statusCode": 0, "data": "Something went wrong"};
  }
}

Future<Map<String, dynamic>> getUserByUserIdApi({String? userId}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(
        "/$userId",
        options: Options(
          method: "GET",
          extra: {
            "requiresToken": false,
          },
        ),
      ),
      retryIf: (e) => e is SocketException || (e is DioException && e.response == null),
    );
    final responseBody = response.data;
    return {
      "status": true,
      "statusCode": response.statusCode,
      "data": responseBody,
    };
  } catch (e) {
    // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    if (e is DioException) {
      // Handle DioError and access the response
      final dioError = e;
      final response = dioError.response;
      if (response != null) {
        log("response ${response.data}");
        return {
          "status": false,
          "statusCode": response.statusCode ?? 0,
          "data": response.data?['detail'].toString(),
        };
      }
    }
    // Handle SocketException for abrupt connection resets
    Map<String, dynamic>? result = checkSocketException(e);
    if (result != null) {
      return result;
    }
    // Handle other exceptions here
    if (kDebugMode) {
      log('Error: $e');
    }
    return {
      "status": false,
      "statusCode":
          0, // You can set a default status code or handle differently
      "data": e.toString(),
    };
  }
}

Future<Map<String, dynamic>> updateUserApi({UserModel? data}) async {
  try {
    log("data ${data?.toJson()}");
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request("/${data!.userId}",
          data: jsonEncode(data.toJson()),
          options: Options(method: "PUT", extra: {
            "requiresToken": false,
          })),
      retryIf: (e) => e is SocketException || (e is DioException && e.response == null),
    );

    final responseBody = response.data;
    return {
      'status': true,
      "statusCode": response.statusCode,
      "data": responseBody,
    };
  } catch (e) {
    if (e is DioException) {
      // Handle DioError and access the response
      final dioError = e;
      final response = dioError.response;
      if (response != null) {
        return {
          'status': false,
          "statusCode": response.statusCode ?? 0,
          "data": response.data?['message'],
        };
      }
    }
    // Handle SocketException for abrupt connection resets
    Map<String, dynamic>? result = checkSocketException(e);
    if (result != null) {
      return result;
    }
    // Handle other exceptions here
    if (kDebugMode) {
      print('Error: $e');
    }
    return {
      'status': false,
      "statusCode":
          0, // You can set a default status code or handle differently
      "data": "Something went wrong",
    };
  }
}

Future<Map<String, dynamic>> getAllUserApi() async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(
        "",
        options: Options(
          method: "GET",
          extra: {
            "requiresToken": false,
          },
        ),
      ),
      retryIf: (e) => e is SocketException || (e is DioException && e.response == null),
    );
    final responseBody = response.data;
    return {
      "status": true,
      "statusCode": response.statusCode,
      "data": responseBody,
    };
  } catch (e) {
    if (e is DioException) {
      final response = e.response;
      if (response != null) {
        log("response ${response.data}");
        return {
          "status": false,
          "statusCode": response.statusCode ?? 0,
          "data": response.data?['detail'].toString(),
        };
      }
    }
    Map<String, dynamic>? result = checkSocketException(e);
    if (result != null) {
      return result;
    }
    if (kDebugMode) log('Error: $e');
    return {"status": false, "statusCode": 0, "data": e.toString()};
  }
}

Future<Map<String, dynamic>> logoutApi() async {
  try {
    final response = await _authDio.post('$_authBaseUrl/logout');
    return {'status': true, 'statusCode': response.statusCode, 'data': response.data};
  } catch (e) {
    if (kDebugMode) log('logoutApi error (non-fatal): $e');
    return {'status': false, 'statusCode': 0, 'data': 'Logout failed'};
  }
}
