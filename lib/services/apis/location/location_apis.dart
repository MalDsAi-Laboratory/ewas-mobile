import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:simple_ui/models/create_user_model.dart';
import 'package:simple_ui/services/apis/location/location_api_services.dart';

Dio dio = LocationDioSingleton.instance; // Create an instance of DioSingleton

enum LocatioAPIPath { createUser }

extension UserAPIPathExtension on LocatioAPIPath {
  String get path {
    switch (this) {
      case LocatioAPIPath.createUser:
        return "";
    }
  }
}

Future<Map<String, dynamic>> createUser2Api({CreateUserModel? data}) async {
  try {
    if (kDebugMode) log("createUser2Api ${jsonEncode(data!.toJson())}");
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(LocatioAPIPath.createUser.path,
          data: jsonEncode(data!.toJson()),
          options: Options(method: "POST", extra: {
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

Future<Map<String, dynamic>> getUserByUserIdApi2({String? userId}) async {
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

Future<Map<String, dynamic>> updateUser2Api({CreateUserModel? data}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request("/${data!.userid}",
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
