# Flutter ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Riverpod
-keep class flutter_riverpod.** { *; }
-keep class riverpod.** { *; }
-keep class riverpod_annotation.** { *; }

# SharedPreferences
-keep class androidx.security.crypto.** { *; }
-keep class shared_preferences.** { *; }
-keep class shared_preferences_android.** { *; }
-keep class shared_preferences_platform_interface.** { *; }
-keep class shared_preferences_web.** { *; }
-keep class shared_preferences_foundation.** { *; }

# Encrypt / PointyCastle / Bcrypt
-keep class org.bouncycastle.** { *; }
-keep class pointycastle.** { *; }
-keep class encrypt.** { *; }
-keep class bcrypt.** { *; }

# Annotations
-keep @interface androidx.annotation.Keep
-keep @interface androidx.annotation.KeepName
-keep @interface androidx.annotation.KeepClassMember

# Native methods
-keepclasseswithmembers class * {
    native <methods>;
}

# Support classes
-keep class androidx.** { *; }

# Formz
-keep class formz.** { *; }

# GoRouter
-keep class go_router.** { *; }

# Keep enum values
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}