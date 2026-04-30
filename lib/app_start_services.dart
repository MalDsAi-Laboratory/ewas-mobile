import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_ui/services/apis/location/location_api_services.dart';
import 'package:simple_ui/services/apis/user/user_api_services.dart';

Future<void> appStartServices() async {
  await dotenv.load(fileName: kReleaseMode ? ".env.prod" : ".env.dev");

  // Reset Dio singletons so they are recreated with the freshly loaded env URLs.
  UserDioSingleton.reset();
  LocationDioSingleton.reset();
}
