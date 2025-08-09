import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:football_is_life/main.dart';

void main() {
  testWidgets('Email login sends magic link', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Send Magic Link'), findsOneWidget);

    await tester.enterText(
        find.byType(TextField).first, 'test@example.com');
    await tester.tap(find.text('Send Magic Link'));
    await tester.pump();

    expect(find.text('Check your email for a login link.'), findsOneWidget);
  });
}

