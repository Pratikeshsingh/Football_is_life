import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

SupabaseClient get supa => Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Football Is Life',
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _maybeRoute();
    supa.auth.onAuthStateChange.listen((_) => _maybeRoute());
  }

  Future<void> _maybeRoute() async {
    final user = supa.auth.currentUser;
    if (user == null) return;
    await _ensureProfileRow(user);
    final needsPhone = await _needsPhone(user.id);
    if (!mounted) return;
    if (needsPhone) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PhoneCaptureScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<bool> _needsPhone(String uid) async {
    final data = await supa
        .from('profiles')
        .select('phone')
        .eq('id', uid)
        .maybeSingle();
    final phone = (data?['phone'] as String?)?.trim();
    return phone == null || phone.isEmpty;
  }

  Future<void> _ensureProfileRow(User user) async {
    await supa.from('profiles').upsert({
      'id': user.id,
      'display_name': user.email?.split('@').first ?? 'Player',
    });
  }

  @override
  Widget build(BuildContext context) {
    return const OTPSignInScreen();
  }
}

class OTPSignInScreen extends StatefulWidget {
  const OTPSignInScreen({super.key});

  @override
  State<OTPSignInScreen> createState() => _OTPSignInScreenState();
}

class _OTPSignInScreenState extends State<OTPSignInScreen> {
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _sent = false;
  bool _busy = false;
  String? _msg;

  Future<void> _sendOtp() async {
    setState(() {
      _busy = true;
      _msg = null;
    });
    try {
      await supa.auth.signInWithOtp(email: _emailCtrl.text.trim());
      if (!mounted) return;
      setState(() {
        _sent = true;
        _msg = 'Check your email for the 6-digit code.';
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _msg = 'Failed to send OTP: ${e.message}';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _msg = 'Failed to send OTP.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _verify() async {
    setState(() {
      _busy = true;
      _msg = null;
    });
    try {
      // Complete the login process by verifying the OTP. `verifyOTP` also
      // creates an active session for the user once the code is confirmed.
      await supa.auth.verifyOTP(
        email: _emailCtrl.text.trim(),
        token: _otpCtrl.text.trim(),
        type: OtpType.email,
      );
      // AuthGate listens to auth changes and will route the user to the
      // appropriate screen (either [PhoneCaptureScreen] or [HomeScreen]).
      // Avoid navigating here so the post-login setup screen can appear when
      // required.
      if (!mounted) return;
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _msg = 'Verification failed: ${e.message}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _msg = 'Verification failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            if (!_sent) ...[
              ElevatedButton(
                onPressed: _busy ? null : _sendOtp,
                child: _busy
                    ? const CircularProgressIndicator()
                    : const Text('Send OTP'),
              ),
            ] else ...[
              TextField(
                controller: _otpCtrl,
                decoration:
                    const InputDecoration(labelText: 'Enter 6-digit OTP'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _busy ? null : _verify,
                child: _busy
                    ? const CircularProgressIndicator()
                    : const Text('Verify & Continue'),
              ),
              TextButton(
                onPressed: _busy ? null : _sendOtp,
                child: const Text('Resend code'),
              ),
            ],
            if (_msg != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _msg!,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PhoneCaptureScreen extends StatefulWidget {
  const PhoneCaptureScreen({super.key});

  @override
  State<PhoneCaptureScreen> createState() => _PhoneCaptureScreenState();
}

class _PhoneCaptureScreenState extends State<PhoneCaptureScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _err;
  bool _busy = false;

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final uid = supa.auth.currentUser!.id;
      final parsed =
          PhoneNumber.parse(_phoneCtrl.text, callerCountry: IsoCode.NL);
      final e164 = parsed.international;
      await supa.from('profiles').update({
        'display_name': _nameCtrl.text.trim().isEmpty
            ? 'Player'
            : _nameCtrl.text.trim(),
        'phone': e164,
      }).eq('id', uid);
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (_) {
      setState(() {
        _err = 'Invalid phone or failed to save.';
      });
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('One-time setup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
                'Add your name & phone so organisers can contact you if needed.'),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Display name'),
              controller: _nameCtrl,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone (+31…)'),
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const CircularProgressIndicator()
                  : const Text('Save & Continue'),
            ),
            if (_err != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _err!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = supa.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => supa.auth.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome ${user?.email ?? 'Player'}'),
      ),
    );
  }
}

