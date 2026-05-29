// All URLs are supplied at build time via --dart-define flags.
// Run with: flutter run --dart-define=USER_BASE_URL=http://... (see .vscode/launch.json)
const String productCatalogueBaseUrl = String.fromEnvironment('PRODUCT_CATALOGUE_BASE_URL');
const String orderBaseUrl = String.fromEnvironment('ORDER_BASE_URL');
const String inventoryBaseUrl = String.fromEnvironment('INVENTORY_BASE_URL');
const String userBaseUrl = String.fromEnvironment('USER_BASE_URL');
const String biddingBaseUrl = String.fromEnvironment('BIDDING_BASE_URL');
const String productDetailsBaseUrl = String.fromEnvironment('PRODUCT_DETAILS_BASE_URL');
const String locationBaseUrl = String.fromEnvironment('LOCATION_BASE_URL');
const String radius = String.fromEnvironment('RADIUS', defaultValue: '10000');
