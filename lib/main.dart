import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart' show Colors, Size, WidgetsFlutterBinding, runApp;
import 'package:window_manager/window_manager.dart' show TitleBarStyle, WindowOptions, windowManager;
import 'core/network/local_storage_service.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await LocalStorageService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 800), // phone dimension
    // size: Size(1200, 800), // tablet dimension
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}
