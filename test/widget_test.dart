import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:football_is_life/main.dart';

void main() {
  setUpAll(() async {
    await Supabase.initialize(url: 'https://example.supabase.co', anonKey: 'anon');
  });

  testWidgets('Email login sends OTP', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Send OTP'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();

    expect(find.text('Check your email for the 6-digit code.'), findsOneWidget);
  });
}

