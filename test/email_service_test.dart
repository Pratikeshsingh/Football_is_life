import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:football_is_life/screens/profile_setup_screen.dart';
import 'package:football_is_life/services/email_service.dart';

class _SuccessEmailService extends EmailService {
  bool called = false;
  @override
  Future<void> sendEmail(String to, String subject, String message) async {
    called = true;
  }
}

class _ErrorEmailService extends EmailService {
  @override
  Future<void> sendEmail(String to, String subject, String message) async {
    throw Exception('fail');
  }
}

void main() {
  setUpAll(() async {
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'anon',
    );
  });

  Future<void> _enterData(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'Name');
    await tester.enterText(find.byType(TextField).at(1), '123456789');
  }

  testWidgets('shows success message when email sent', (tester) async {
    final service = _SuccessEmailService();
    await tester.pumpWidget(
      MaterialApp(home: ProfileSetupScreen(emailService: service)),
    );
    await _enterData(tester);
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump();
    expect(service.called, true);
    expect(find.text('Confirmation email sent'), findsOneWidget);
  });

  testWidgets('shows error message when email sending fails', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ProfileSetupScreen(emailService: _ErrorEmailService())),
    );
    await _enterData(tester);
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Failed to send email'), findsOneWidget);
  });
}
