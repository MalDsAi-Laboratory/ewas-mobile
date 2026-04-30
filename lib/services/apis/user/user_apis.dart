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
String get _authBaseUrl => userBaseUrl!.replaceFirst('/api/v1/users', '/api/v1/auth');

Future<Map<String, dynamic>> createUserApi({UserModel? data}) async {
  try {
    log("create user ${jsonEncode(data!.toJson())}");
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => _authDio.post(
        '$_authBaseUrl/register',
        data: jsonEncode(data.toJson()),
      ),
      retryIf: (e) => e is DioException || e is SocketException,
    );
    return {
      'status': true,
      "statusCode": response.statusCode,
      "data": response.data,
    };
  } catch (e) {
    if (e is DioException && e.response != null) {
      return {
        'status': false,
        "statusCode": e.response?.statusCode ?? 0,
        "data": e.response?.data?['message'] ?? 'Registration failed',
      };
    }
    Map<String, dynamic>? result = checkSocketException(e);
    if (result != null) return result;
    if (kDebugMode) print('createUserApi error: $e');
    return {'status': false, "statusCode": 0, "data": "Something went wrong"};
  }
}

Future<Map<String, dynamic>> loginUserApi({required String email, required String password}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => _authDio.post(
        '$_authBaseUrl/login',
        data: jsonEncode({"email": email, "password": password}),
      ),
      retryIf: (e) => e is DioException || e is SocketException,
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
      retryIf: (e) => e is DioException || e is SocketException,
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
      retryIf: (e) => e is DioException || e is SocketException,
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
      retryIf: (e) => e is DioException || e is SocketException,
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
