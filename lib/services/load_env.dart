import 'package:flutter_dotenv/flutter_dotenv.dart';

final String? productCatalogueBaseUrl =
    dotenv.env['PRODUCT_CATALOGUE_BASE_URL'];
final String? orderBaseUrl = dotenv.env['ORDER_BASE_URL'];
final String? inventoryBaseUrl = dotenv.env['INVENTORY_BASE_URL'];
final String? userBaseUrl = dotenv.env['USER_BASE_URL'];
final String? biddingBaseUrl = dotenv.env['BIDDING_BASE_URL'];
final String? productDetailsBaseUrl = dotenv.env['PRODUCT_DETAILS_BASE_URL'];
final String? locationBaseUrl = dotenv.env['LOCATION_BASE_URL'];
