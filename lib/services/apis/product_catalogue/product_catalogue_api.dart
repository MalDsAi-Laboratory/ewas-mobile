import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:simple_ui/services/apis/product_catalogue/product_catalogue_api_services.dart';

Dio dio =
    ProductCatalogueDioSingleton.instance; // Create an instance of DioSingleton

enum ProductCatalogueAPIPath { categories, products }

extension ProductCatalogueAPIPathExtension on ProductCatalogueAPIPath {
  String get path {
    switch (this) {
      case ProductCatalogueAPIPath.categories:
        // baseUrl already ends in /api/v1/products — Dio does plain string
        // concatenation (baseUrl + path), not URI resolution, so this must
        // be just the suffix or the request 404s against a doubled path.
        return "/categories";
      case ProductCatalogueAPIPath.products:
        return "/category/";
    }
  }
}

Future<Map<String, dynamic>> getAllCategoriesApi(
    {int? pageNumber, int? pageSize}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(
        ProductCatalogueAPIPath.categories.path +
            "?page=${pageNumber}&size=${pageSize}",
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

Future<Map<String, dynamic>> getProductsFromCategoryApi(
    {String? category}) async {
  try {
    final response = await const RetryOptions(maxAttempts: 2).retry(
      () => dio.request(
        ProductCatalogueAPIPath.products.path + category!,
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
