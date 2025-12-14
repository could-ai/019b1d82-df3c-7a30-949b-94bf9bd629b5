import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/glitch_text.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game State
  int _sanity = 100;
  int _step = 0;
  bool _lightsOn = true;
  String _currentText = "Vous êtes dans un couloir sombre. Le silence est total.";
  List<String> _log = [];
  
  // Random Events
  Timer? _randomEventTimer;
  final Random _rng = Random();
  
  // UI State
  bool _showGhost = false;
  double _backgroundNoise = 0.0;
  Color _textColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _startParanoiaEngine();
  }

  @override
  void dispose() {
    _randomEventTimer?.cancel();
    super.dispose();
  }

  void _startParanoiaEngine() {
    // Le moteur de paranoïa déclenche des événements aléatoires
    _randomEventTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_rng.nextDouble() < 0.3) {
        _triggerRandomEvent();
      }
    });
  }

  void _triggerRandomEvent() {
    if (!mounted) return;
    
    int eventType = _rng.nextInt(5);
    
    setState(() {
      switch (eventType) {
        case 0:
          // Audio hallucination visual
          _log.add("> Vous avez entendu ça ?");
          _sanity -= 2;
          break;
        case 1:
          // Light flicker
          _lightsOn = false;
          Future.delayed(Duration(milliseconds: _rng.nextInt(500) + 100), () {
            if (mounted) setState(() => _lightsOn = true);
          });
          break;
        case 2:
          // Fourth wall break
          _log.add("> Je te vois derrière l'écran.");
          _sanity -= 5;
          HapticFeedback.heavyImpact();
          break;
        case 3:
          // Fake UI Glitch
          _backgroundNoise = 0.2;
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) setState(() => _backgroundNoise = 0.0);
          });
          break;
        case 4:
          // Text corruption
          _textColor = Colors.red.shade900;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) setState(() => _textColor = Colors.grey);
          });
          break;
      }
    });
    
    // Scroll to bottom
    // (Implemented in build via reverse list or controller)
  }

  void _makeChoice(String choice) {
    HapticFeedback.selectionClick();
    setState(() {
      _step++;
      _sanity -= _rng.nextInt(5); // Chaque choix coûte de la santé mentale
      _log.add("> $choice");
      
      // Narrative branching logic (simplified for demo)
      if (_sanity < 50 && _rng.nextBool()) {
        _currentText = "Pourquoi continuez-vous ? Il n'y a pas d'issue.";
      } else if (_step == 1) {
        _currentText = "Une porte est entrouverte sur la gauche. Une lumière rouge en émane.";
      } else if (_step == 2) {
        _currentText = "Quelqu'un respire juste derrière vous. Ne vous retournez pas.";
      } else if (_step > 5) {
        _currentText = "Le couloir semble s'étirer à l'infini. Les murs changent de texture.";
      } else {
        List<String> randomNarrative = [
          "Le sol est collant.",
          "Une ombre a bougé au fond.",
          "Votre reflet dans la vitre n'a pas bougé en même temps que vous.",
          "Le silence est assourdissant."
        ];
        _currentText = randomNarrative[_rng.nextInt(randomNarrative.length)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Dynamic Background (Subtle pulsing)
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            color: _lightsOn ? Colors.black : Colors.black87,
            child: _backgroundNoise > 0 
                ? Opacity(opacity: _backgroundNoise, child: Image.network('https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExM3RxeXF6eXF6eXF6eXF6eXF6eXF6eXF6eXF6eXF6eXF6/oEI9uBVPHe9MI/giphy.gif', fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: Colors.white10))) // Noise placeholder
                : null,
          ),

          // 2. Main Interface
          SafeArea(
            child: Column(
              children: [
                // Sanity Meter (Hidden or Subtle)
                LinearProgressIndicator(
                  value: _sanity / 100,
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.lerp(Colors.red, Colors.grey, _sanity / 100)!,
                  ),
                  minHeight: 2,
                ),
                
                // Game Viewport (The "Eye")
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlitchText(
                            text: _currentText,
                            style: GoogleFonts.courierPrime(
                              color: _textColor,
                              fontSize: 18,
                              height: 1.4,
                            ),
                            glitchFactor: (100 - _sanity) / 1000, // More glitch as sanity drops
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Log / History
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade900)),
                      color: Colors.black54,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _log.length,
                      itemBuilder: (context, index) {
                        final logIndex = _log.length - 1 - index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            _log[logIndex],
                            style: GoogleFonts.vt323(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Controls
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton("AVANCER", () => _makeChoice("Vous avancez.")),
                      _buildActionButton("REGARDER", () => _makeChoice("Vous observez attentivement.")),
                      _buildActionButton("ECOUTER", () => _makeChoice("Vous tendez l'oreille.")),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Jumpscare Layer (Rare)
          if (_showGhost)
            Positioned.fill(
              child: Container(color: Colors.red.withOpacity(0.5)),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    // Buttons sometimes disappear or disable based on sanity
    if (_sanity < 30 && _rng.nextDouble() < 0.2) {
      return const SizedBox(width: 80); // Button missing hallucination
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        side: BorderSide(color: Colors.grey.shade800),
      ),
      child: Text(label, style: GoogleFonts.courierPrime(letterSpacing: 1.5)),
    );
  }
}
