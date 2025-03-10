import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    return token;
  }

  Future<void> sendFCMNotification(
      {required String token,
      required String FCMtoken,
      required String title,
      required String body}) async {
    const String url =
        "https://fcm.googleapis.com/v1/projects/scrapit-1826c/messages:send";
    String bearerToken = token; // Replace with actual Bearer token
    // log("Bearer Token: $bearerToken");
    Map<String, dynamic> payload = {
      "message": {
        "token": FCMtoken,
        "notification": {"title": title, "body": body},
        "android": {
          "notification": {
            "sound": "ringtone",
            "channel_id": "high_importance_channel"
          }
        },
        "apns": {
          "payload": {
            "aps": {"sound": "ringtone.mp3", "content-available": 1}
          }
        }
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $bearerToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully: ${response.body}");
      } else {
        print(
            "Failed to send notification: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
