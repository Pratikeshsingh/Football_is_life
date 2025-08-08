import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:football_is_life/main.dart';

void main() {
  testWidgets('Login and navigate to matches screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Alice');
    await tester.enterText(find.byType(TextField).at(1), '123456');

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Alice'), findsOneWidget);
  });
}

