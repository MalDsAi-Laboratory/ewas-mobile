import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:simple_ui/models/inventory_model.dart';
import 'package:simple_ui/services/apis/inventory/inventory_api_services.dart';

Dio dio = InventoryDioSingleton.instance; // Create an instance of DioSingleton

enum InventoryAPIPath { createInventory, imageUpload }

extension InventoryAPIPathExtension on InventoryAPIPath {
  String get path {
    switch (this) {
      case InventoryAPIPath.createInventory:
        return "/add";
      case InventoryAPIPath.imageUpload:
        return "/uploadImage/slot";
    }
  }
}

Future<Map<String, dynamic>> createInventoryApi({InventoryModel? data}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(InventoryAPIPath.createInventory.path,
          data: data!.toJson(),
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
      "data": e.toString(),
    };
  }
}

Future<Map<String, dynamic>> uploadInventoryImageApi(
    {required FormData imageForm,
    required int index,
    required String orderId}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 0).retry(
      () => dio.request(
        "${InventoryAPIPath.imageUpload.path}${index}?order_id=$orderId",
        data: imageForm,
        options: Options(
          method: "POST",
          extra: {"requiresToken": false},
          contentType: "multipart/form-data",
        ),
      ),
      retryIf: (e) => e is DioException || e is SocketException,
    );

    return {
      'status': true,
      "statusCode": response.statusCode,
      "data": response.data,
    };
  } catch (e) {
    if (e is DioException) {
      final response = e.response;
      if (response != null) {
        return {
          'status': false,
          "statusCode": response.statusCode ?? 0,
          "data": response.data?['message'],
        };
      }
    }
    Map<String, dynamic>? result = checkSocketException(e);
    if (result != null) {
      return result;
    }
    if (kDebugMode) {
      print('Error: $e');
    }
    return {
      'status': false,
      "statusCode": 0,
      "data": e.toString(),
    };
  }
}

Future<Map<String, dynamic>> getInventoryByIdApi({String? orderId}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(
        "/$orderId",
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
