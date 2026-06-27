import 'package:computology/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class FirebaseService {
  static Future<void> init() async {
    // Platform.environment is not available on web, so skip the test-env
    // check when running in a browser.
    if (kDebugMode && !kIsWeb) {
      // Dynamically check for the FLUTTER_TEST env var on native platforms.
      final bool isTest = _isTestEnvironment();
      if (isTest) return;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Check if running inside `flutter test` on native platforms.
  /// Isolated to avoid importing dart:io at the top level (which breaks web).
  static bool _isTestEnvironment() {
    try {
      // ignore: avoid_dynamic_calls
      return const bool.fromEnvironment('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }
}