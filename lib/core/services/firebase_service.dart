import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_service.g.dart';

@riverpod
FirebaseApp firebaseApp(Ref ref) {
  return Firebase.app();
}
