import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_ui/services/notifications/notifications_service.dart';
import 'package:simple_ui/services/notifications/server_key.dart';

Future<void> appStartServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  initializeAppNotifications();
}
