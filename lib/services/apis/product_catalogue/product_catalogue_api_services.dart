import 'package:dio/dio.dart';
import 'package:simple_ui/services/apis/base_dio.dart';

export 'package:simple_ui/services/apis/base_dio.dart'
    show ErrorModel, checkSocketException, requestEntityTooLarge;

class ProductCatalogueDioSingleton {
  static Dio? _dio;
  static void reset() => _dio = null;
  static Dio get instance =>
      _dio ??= createDio(const String.fromEnvironment('PRODUCT_CATALOGUE_BASE_URL'));
}
