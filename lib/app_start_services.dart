import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> appStartServices() async {
  await dotenv.load(fileName: ".env");
}
