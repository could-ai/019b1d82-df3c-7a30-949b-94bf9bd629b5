import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/intro_screen.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const HorrorApp());
}

class HorrorApp extends StatelessWidget {
  const HorrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'L\'Observateur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF8B0000), // Blood Red
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B0000),
          secondary: Colors.grey,
          surface: Colors.black,
          onSurface: Color(0xFFE0E0E0),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.nosifer(color: Colors.red[900]),
          bodyLarge: GoogleFonts.courierPrime(color: Colors.grey[300], fontSize: 16),
          bodyMedium: GoogleFonts.courierPrime(color: Colors.grey[400], fontSize: 14),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
