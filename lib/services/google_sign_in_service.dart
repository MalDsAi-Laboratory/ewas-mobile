import 'package:google_sign_in/google_sign_in.dart';

/// Wraps the Google Sign-In flow and returns the ID token needed
/// for backend verification at POST /api/v1/auth/google.
///
/// Setup required (one-time):
///   1. Create a Firebase project (free): https://console.firebase.google.com
///   2. Add Android app with package name `com.ewaste.ewas`
///   3. Enable Google Sign-In under Authentication → Sign-in method
///   4. Download google-services.json → place in android/app/
///   5. Add to android/build.gradle classpath:
///        classpath 'com.google.gms:google-services:4.4.0'
///   6. Add to android/app/build.gradle (bottom):
///        apply plugin: 'com.google.gms.google-services'
class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Signs the user in with Google and returns their ID token.
  /// Returns null if the user cancels or an error occurs.
  static Future<_GoogleAuthResult?> signIn() async {
    try {
      // Sign out first to force the account picker to show every time
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null; // User cancelled

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) return null;

      return _GoogleAuthResult(
        idToken: idToken,
        email: account.email,
        displayName: account.displayName ?? account.email,
      );
    } catch (e) {
      return null;
    }
  }

  /// Signs the user out of Google (clears local Google session).
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

class _GoogleAuthResult {
  final String idToken;
  final String email;
  final String displayName;

  _GoogleAuthResult({
    required this.idToken,
    required this.email,
    required this.displayName,
  });
}
