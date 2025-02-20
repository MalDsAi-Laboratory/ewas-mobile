import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_ui/services/load_env.dart';

class ErrorModel {
  final String message;

  ErrorModel(this.message);
}

var failedApis = [];
var handlers = [];

class InventoryDioSingleton {
  static Dio? _dio;
  static Dio get instance {
    if (_dio == null) {
      final baseOptions = BaseOptions(
        baseUrl: inventoryBaseUrl!, // Replace with your API base URL
        connectTimeout: const Duration(
            minutes: 1), // Adjust the timeout as needed (milliseconds)
        receiveTimeout: const Duration(
            minutes: 1), // Adjust the timeout as needed (milliseconds)
      );
      _dio = Dio(baseOptions);

      // Interceptor for adding authorization token
      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (kDebugMode) {
            log("method is ${options.method}");
            log("url is ${options.uri}");
          }
          if (options.extra['requiresToken'] == true) {
            // final accessToken =
            //     await FirebaseAuth.instance.currentUser?.getIdToken();

            // if (accessToken != null) {
            //   options.headers['Authorization'] = 'Bearer $accessToken';
            // }
          }
          if (options.extra['customHeaders'] == null) {
            options.headers['Accept'] = 'application/json';
            options.headers['Content-Type'] = 'application/json';
          }
          handler.next(options);
        },
      ));

      // Interceptor for response handling
      _dio!.interceptors.add(InterceptorsWrapper(
        onResponse: (response, handler) {
          if (kDebugMode) {
            // print(" response $response");
            log("response $response");
          }
          handler.next(response); // Continue with the response
        },
      ));

      // Interceptor for error handling
      _dio!.interceptors.add(InterceptorsWrapper(
        onError: (DioException e, handler) async {
          switch (e.response?.statusCode) {
            case 403:
              failedApis.add(e);
              handlers.add(handler);
              break;

            default:
              // Handle other status codes or errors
              if (kDebugMode) {
                log("error from api_services is ${e.response?.data}");
              }
              // FirebaseCrashlytics.instance.recordError(e, StackTrace.current,
              //     reason: ({
              //       "url": e.requestOptions.uri.toString(),
              //       "method": e.requestOptions.method,
              //       "response": e.response?.data?.toString(),
              //       "error": e.message,
              //       "statusCode": e.response?.statusCode,
              //       "stackTrace": e.stackTrace.toString()
              //     }).toString());
              handler.next(e);
              break;
          }
        },
      ));
    }
    return _dio!;
  }

  static removeLoginDataToStorage() async {
    // storage.logOut();
    // getx.Get.offAll(() => const GetStartedView(
    //       source: "/Logout",
    //     ));
  }

  Future<Response<T>> request<T>(
    String path, {
    String method = 'GET', // Default to GET method
    Map<String, dynamic>? queryParameters,
    dynamic data,
    RequestOptions? options,
    Headers? headers,
  }) async {
    return await instance.request<T>(
      path,
      queryParameters: queryParameters,
      data: data,
    );
  }
}

Map<String, String> requestEntityTooLarge(String data) {
  if (data.startsWith('<html>')) {
    return {
      "data": "Please upload a smaller image.",
    };
  }
  return {};
}

Map<String, dynamic>? checkSocketException(e) {
  if (e is SocketException) {
    // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

    if (kDebugMode) {
      print("SocketException: $e");
    }
    return {
      "status": false,
      "statusCode": 0,
      "data": "Network error: Please try again",
    };
  } else {
    return null;
  }
}
