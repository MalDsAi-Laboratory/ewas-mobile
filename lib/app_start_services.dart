import 'package:simple_ui/services/apis/bidding/bidding_api_service.dart';
import 'package:simple_ui/services/apis/inventory/inventory_api_services.dart';
import 'package:simple_ui/services/apis/location/location_api_services.dart';
import 'package:simple_ui/services/apis/order/order_api_services.dart';
import 'package:simple_ui/services/apis/product_catalogue/product_catalogue_api_services.dart';
import 'package:simple_ui/services/apis/product_details/product_details_api_services.dart';
import 'package:simple_ui/services/apis/user/user_api_services.dart';

/// Resets all Dio singletons so they are (re)created with the current env config.
/// URLs are compile-time constants via --dart-define, so no file loading needed.
Future<void> appStartServices() async {
  UserDioSingleton.reset();
  OrderDioSingleton.reset();
  InventoryDioSingleton.reset();
  LocationDioSingleton.reset();
  ProductCatalogueDioSingleton.reset();
  ProductDetailsDioSingleton.reset();
  BiddingDioSingleton.reset();
}
