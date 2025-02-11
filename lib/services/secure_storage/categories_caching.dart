// import 'dart:developer';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';

// class SecureStorageServices {
//   // Create secure storage instance
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

//   // Storage keys
//   final String _userModel = 'userModel';
//   final String _popupKey = 'lastPopupTime';

//   // User Mdoel
//   Future<void> setUserModel(Map<String, dynamic> userModel) async {
//     await _secureStorage.write(key: _userModel, value: jsonEncode(userModel));
//   }

//   Future<Map<String, dynamic>?> getUserModel() async {
//     final String? userModelJson = await _secureStorage.read(key: _userModel);
//     if (userModelJson != null) {
//       log("userModelJson is $userModelJson");
//       return jsonDecode(userModelJson) as Map<String, dynamic>;
//     } else {
//       return null;
//     }
//   }

//   // Popup Time
//   Future<void> setLastPopupTime(String? popupTimeVal) async {
//     await _secureStorage.write(key: _popupKey, value: popupTimeVal);
//   }

//   Future<String?> getLastPopupTime() async {
//     return await _secureStorage.read(key: _popupKey);
//   }

//   // Logout (Clear all storage)
//   Future<void> logOut() async {
//     await _secureStorage.deleteAll();
//   }
// }

// class AppReviewSecureStorage {
//   // Create secure storage instance
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

//   // Storage keys
//   final String _reviewPopUpKey = 'AppReviewlastPopupTime';

//   // Popup Time
//   Future<void> setLastPopupTime(String? popupTimeVal) async {
//     await _secureStorage.write(key: _reviewPopUpKey, value: popupTimeVal);
//   }

//   Future<String?> getLastPopupTime() async {
//     return await _secureStorage.read(key: _reviewPopUpKey);
//   }
// }

// // Routine Storage with Secure Storage
// class SecureRoutineStorage {
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//   static const String _routineListKey = 'routineList';

//   // Initialize list if not created
//   Future<void> initializeList() async {
//     String? existingList = await _secureStorage.read(key: _routineListKey);
//     if (existingList == null) {
//       await _secureStorage.write(key: _routineListKey, value: jsonEncode([]));
//     }
//   }

//   // Add a routine
//   Future<void> addRoutine(Map<String, dynamic> routine) async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _routineListKey);
//     List<dynamic> routineList = existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];

//     routineList.add(routine);
//     await _secureStorage.write(
//         key: _routineListKey, value: jsonEncode(routineList));
//   }

//   // Replace notification IDs
//   Future<void> replaceNotificationIds(
//       String routineID, List<int> newNotificationIds) async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _routineListKey);
//     List<dynamic> routineList = existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];

//     bool foundRoutine = false;
//     for (var routine in routineList) {
//       if (routine['id'] == routineID) {
//         routine['notification_ids'] = newNotificationIds;
//         foundRoutine = true;
//         break;
//       }
//     }

//     if (!foundRoutine) {
//       routineList
//           .add({"id": routineID, "notification_ids": newNotificationIds});
//     }

//     await _secureStorage.write(
//         key: _routineListKey, value: jsonEncode(routineList));
//   }

//   // Remove routine by ID
//   Future<void> removeRoutineById(String routineID) async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _routineListKey);
//     List<dynamic> routineList = existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];

//     routineList.removeWhere((routine) => routine['id'] == routineID);

//     await _secureStorage.write(
//         key: _routineListKey, value: jsonEncode(routineList));
//   }

//   // Get routine list
//   Future<List<Map<String, dynamic>>> getRoutineList() async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _routineListKey);
//     return existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];
//   }
// }

// class SecureSkinReportStorage {
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//   static const String _skinReportListKey = 'skinReportList';

//   // Initialize the skin report list if it doesn't exist
//   Future<void> initializeList() async {
//     String? existingList = await _secureStorage.read(key: _skinReportListKey);
//     if (existingList == null) {
//       await _secureStorage.write(
//           key: _skinReportListKey, value: jsonEncode([]));
//     }
//   }

//   // Initialize the skin report list with a provided list of skin reports
//   Future<void> initializeListWithReports(
//       List<Map<String, dynamic>> skinReports) async {
//     await _secureStorage.write(
//         key: _skinReportListKey, value: jsonEncode(skinReports));
//   }

//   /// insertSkinReport is called when new skin report is available.
//   Future<void> insertSkinReport(Map<String, dynamic> skinReport) async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _skinReportListKey);
//     List<dynamic> skinReportList = existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];

//     skinReportList.insert(0, skinReport);
//     await _secureStorage.write(
//         key: _skinReportListKey, value: jsonEncode(skinReportList));
//   }

//   /// Add a skin report is used when initializing the cache list
//   Future<void> addSkinReport(Map<String, dynamic> skinReport) async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _skinReportListKey);
//     List<dynamic> skinReportList = existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];

//     skinReportList.add(skinReport);
//     await _secureStorage.write(
//         key: _skinReportListKey, value: jsonEncode(skinReportList));
//   }

//   // Update a skin report by ID
//   Future<void> updateSkinReport(
//       int reportID, Map<String, dynamic> updatedReport) async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _skinReportListKey);
//     List<dynamic> skinReportList = existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];

//     for (var report in skinReportList) {
//       if (report['id'] == reportID) {
//         report.addAll(updatedReport);
//         break;
//       }
//     }

//     await _secureStorage.write(
//         key: _skinReportListKey, value: jsonEncode(skinReportList));
//   }

//   // Remove a skin report by ID
//   Future<void> removeSkinReportById(String reportID) async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _skinReportListKey);
//     List<dynamic> skinReportList = existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];

//     skinReportList.removeWhere((report) => report['id'] == reportID);

//     await _secureStorage.write(
//         key: _skinReportListKey, value: jsonEncode(skinReportList));
//   }
//   // Method to delete all skin reports from cache

//   Future<void> deleteAllSkinReports() async {
//     await _secureStorage.delete(key: _skinReportListKey);
//   }

//   // Get the list of skin reports
//   Future<List<Map<String, dynamic>>> getSkinReportList() async {
//     await initializeList();

//     String? existingListString =
//         await _secureStorage.read(key: _skinReportListKey);
//     return existingListString != null
//         ? List<Map<String, dynamic>>.from(jsonDecode(existingListString))
//         : [];
//   }
// }
