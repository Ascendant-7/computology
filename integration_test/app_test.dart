import 'package:flutter/material.dart' show ElevatedButton;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart' show IntegrationTestWidgetsFlutterBinding;
import 'package:computology/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Usability Test: Verifying Core Flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // expect(find.text('App Running'), findsOneWidget);

    final Finder loginButton = find.byType(ElevatedButton);
    if (loginButton.evaluate().isNotEmpty) {
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Welcome back!'), findsOneWidget);
    }
  });
}