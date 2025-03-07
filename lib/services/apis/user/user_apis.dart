import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/services/apis/user/user_api_services.dart';
import "package:http/http.dart" as http;
import 'package:simple_ui/services/load_env.dart';

Dio dio = UserDioSingleton.instance; // Create an instance of DioSingleton

enum UserAPIPath { createUser }

extension UserAPIPathExtension on UserAPIPath {
  String get path {
    switch (this) {
      case UserAPIPath.createUser:
        return "/add";
    }
  }
}

Future<Map<String, dynamic>> createUserApi({UserModel? data}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(UserAPIPath.createUser.path,
          data: jsonEncode(data!.toJson()),
          options: Options(method: "POST", extra: {
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

Future<Map<String, dynamic>> getUserAccountPasswordApi({String? userId}) async {
  try {
    final Uri url = Uri.parse("$userBaseUrl/$userId/password");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    log('Response Body: ${response.body}');

    // Ensure response body is handled correctly
    if (response.statusCode == 200) {
      try {
        final data = response.body;
        return {
          "status": true,
          "statusCode": response.statusCode,
          "data": data, // JSON response
        };
      } catch (e) {
        // If response is not JSON, return it as plain text
        return {
          "status": true,
          "statusCode": response.statusCode,
          "data": response.body, // Plain text response
        };
      }
    }

    return {
      "status": false,
      "statusCode": response.statusCode,
      "data": response.body.isNotEmpty ? response.body : 'Unknown error',
    };
  } catch (e) {
    log("Error in getUserAccountPasswordApi: $e");

    if (e is SocketException) {
      return {
        "status": false,
        "statusCode": 0,
        "data": "No Internet Connection",
      };
    }

    return {
      "status": false,
      "statusCode": 0,
      "data": e.toString(),
    };
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
