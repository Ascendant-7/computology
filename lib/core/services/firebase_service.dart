import 'dart:io';

import 'package:computology/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class FirebaseService {
  static Future<void> init() async {
    if (kDebugMode && Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }
}