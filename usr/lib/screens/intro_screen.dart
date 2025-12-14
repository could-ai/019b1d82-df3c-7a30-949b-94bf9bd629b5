import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _showWarning = false;
  bool _glitchEffect = false;
  String _buttonText = "COMMENCER";
  int _refusalCount = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showWarning = true);
    });
  }

  void _startGame() {
    // Simulation d'un comportement imprévisible
    if (_refusalCount < 2 && Random().nextBool()) {
      setState(() {
        _refusalCount++;
        _glitchEffect = true;
        _buttonText = _refusalCount == 1 ? "ÊTES-VOUS SÛR ?" : "NE FAITES PAS ÇA";
      });
      
      HapticFeedback.heavyImpact();
      
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) setState(() => _glitchEffect = false);
      });
      return;
    }

    Navigator.pushReplacementNamed(context, '/game');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background noise simulation
          if (_glitchEffect)
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.1)),
            ),
            
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_showWarning)
                    Text(
                      "INITIALISATION...",
                      style: GoogleFonts.courierPrime(letterSpacing: 4),
                    ).animate().fade().shimmer(),

                  if (_showWarning) ...[
                    Text(
                      "AVERTISSEMENT",
                      style: GoogleFonts.nosifer(
                        fontSize: 32, 
                        color: _glitchEffect ? Colors.white : Colors.red[900]
                      ),
                    ).animate().fadeIn(duration: 2.seconds).shake(hz: 0.5),
                    
                    const SizedBox(height: 32),
                    
                    Text(
                      "Ce logiciel n'est pas un jeu.\nIl apprend de vos peurs.\n\nÉteignez les lumières.\nMettez un casque.\nNe vous retournez pas.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.courierPrime(
                        height: 1.5,
                        color: Colors.grey[400],
                      ),
                    ).animate().fadeIn(delay: 1.seconds),

                    const SizedBox(height: 64),

                    MouseRegion(
                      onEnter: (_) {
                        // Subtle UI hostility: Button moves slightly or shakes
                        if (Random().nextDouble() > 0.7) {
                          HapticFeedback.lightImpact();
                        }
                      },
                      child: OutlinedButton(
                        onPressed: _startGame,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade900),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          _buttonText,
                          style: GoogleFonts.courierPrime(
                            color: Colors.red[100], 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 3.seconds),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
