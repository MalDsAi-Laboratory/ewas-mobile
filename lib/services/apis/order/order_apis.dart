import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:simple_ui/models/order_model.dart';
import 'package:simple_ui/models/user_model.dart';
import 'package:simple_ui/services/apis/order/order_api_services.dart';

Dio dio = OrderDioSingleton.instance; // Create an instance of DioSingleton

enum OrderAPIPath { createOrder, getAllOrders }

extension OrderAPIPathExtension on OrderAPIPath {
  String get path {
    switch (this) {
      case OrderAPIPath.createOrder:
        return "/user";
      case OrderAPIPath.getAllOrders:
        return "/";
    }
  }
}

Future<Map<String, dynamic>> createOrderApi({OrderModel? data}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(OrderAPIPath.createOrder.path,
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
      "data": e.toString(),
    };
  }
}

Future<Map<String, dynamic>> getAllOrdersApi(
    {String? userId, int? pageNumber, int? pageSize, String? role}) async {
  try {
    // Admin/delivery agent: GET /api/v1/orders?page=N&size=N  (paginated all-orders)
    // Everyone else:        GET /api/v1/orders/user/{userId}?page=N&size=N
    final path = (role == UserRole.admin || role == UserRole.deliveryAgent)
        ? "?page=$pageNumber&size=$pageSize"
        : "/user/$userId?page=$pageNumber&size=$pageSize";
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(
        path,
        options: Options(
          method: "GET",
          extra: {"requiresToken": false},
        ),
      ),
      retryIf: (e) => e is SocketException ||
          (e is DioException && e.response == null),
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

/// PUT Api to update order
Future<Map<String, dynamic>> updateOrderApi({OrderModel? data}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request("/${data?.eid ?? ""}",
          data: jsonEncode(data!.toJson()),
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
      "data": e.toString(),
    };
  }
}
