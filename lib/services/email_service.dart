import 'package:supabase_flutter/supabase_flutter.dart';

class EmailService {
  const EmailService();

  Future<void> sendEmail(String to, String subject, String message) async {
    final payload = {
      'to': to,
      'subject': subject,
      'message': message,
    };
    await Supabase.instance.client.functions
        .invoke('send_email', body: payload);
  }
}
