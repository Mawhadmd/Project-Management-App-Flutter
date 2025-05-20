import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finalmobileproject/Auth/LoginScreen.dart';
import 'package:finalmobileproject/Home_screen.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          return session != null ? const HomeScreen() : const LoginScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
