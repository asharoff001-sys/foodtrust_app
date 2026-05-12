import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodtrust_app/screens/login_screen.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    expect(find.text('FoodTrust'), findsOneWidget);

    expect(find.text('Login'), findsOneWidget);

    expect(find.byType(TextField), findsNWidgets(2));
  });
}
