import 'package:finalmobileproject/Home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
 
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final Color background = Color(0xFFf7fff7);   
  final Color main = Color(0xFF292f36); 
  final Color accentColor = Color(0xFF4ecdc4);    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        // keep your other colors…
        primaryColor: accentColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: main,
      surface: background,
      primary: accentColor
    ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: main),
          labelStyle: TextStyle(color: main),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: main, fontSize: 20),
          iconTheme: IconThemeData(color: main),
        ),
      ),
        
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

