import 'package:flutter_dotenv/flutter_dotenv.dart';

final String? productCatalogueBaseUrl =
    dotenv.env['PRODUCT_CATALOGUE_BASE_URL'];
final String? orderBaseUrl = dotenv.env['ORDER_BASE_URL'];
