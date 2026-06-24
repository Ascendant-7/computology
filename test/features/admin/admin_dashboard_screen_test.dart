import 'package:computology/features/admin/admin_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Admin Screen displays Hello World', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AdminDashboardScreen(),
      )
    );

    final textFinder = find.text('Hello World');

    expect(textFinder, findsOneWidget);
  });
}