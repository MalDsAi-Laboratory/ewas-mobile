# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Flutter secure storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Image picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep Kotlin metadata
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Flutter references Play Store split-install classes for deferred components.
# This app doesn't use deferred components, so suppress the missing-class warnings.
-dontwarn com.google.android.play.core.**
