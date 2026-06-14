import 'package:flutter_test/flutter_test.dart' show expect, isTrue, test;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:integration_test/integration_test.dart' show IntegrationTestWidgetsFlutterBinding;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  test('Verify Firebase connection', () async {
    // You might need to mock your FirebaseOptions or use a test project
    await Firebase.initializeApp();

    final firestore = FirebaseFirestore.instance;
    await firestore.collection('test').doc('ping').set({'status': 'ok'});

    final doc = await firestore.collection('test').doc('ping').get();
    expect(doc.exists, isTrue);
  });
}