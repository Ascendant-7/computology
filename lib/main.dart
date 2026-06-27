import 'package:computology/core/services/firebase_service.dart';
import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'core/network/local_storage_service.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await FirebaseService.init();

  runApp(const MyApp());
}
