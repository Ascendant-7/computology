import 'package:flutter/material.dart';
import 'core/network/local_storage_service.dart';
import 'app.dart';

Future<void> main() async {
  // flutter initialization
  WidgetsFlutterBinding.ensureInitialized();
  // custom initialization
  await LocalStorageService.init();
  // app run
  runApp(const MyApp());
}
