import 'dart:math';
import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double glitchFactor; // 0.0 to 1.0

  const GlitchText({
    super.key,
    required this.text,
    required this.style,
    this.glitchFactor = 0.0,
  });

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.glitchFactor == 0) {
      return Text(widget.text, style: widget.style, textAlign: TextAlign.center);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Randomly decide to glitch this frame
        bool shouldGlitch = _random.nextDouble() < widget.glitchFactor * 5;
        
        if (!shouldGlitch) {
          return Text(widget.text, style: widget.style, textAlign: TextAlign.center);
        }

        double offsetX = (_random.nextDouble() - 0.5) * 5;
        double offsetY = (_random.nextDouble() - 0.5) * 5;
        
        // Sometimes replace characters
        String displayText = widget.text;
        if (_random.nextDouble() < 0.3) {
          displayText = displayText.split('').map((char) {
            return _random.nextDouble() < 0.1 ? String.fromCharCode(_random.nextInt(50) + 33) : char;
          }).join();
        }

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Text(
            displayText,
            textAlign: TextAlign.center,
            style: widget.style.copyWith(
              color: _random.nextBool() ? Colors.red : widget.style.color,
              shadows: [
                Shadow(
                  color: Colors.blue,
                  offset: Offset(-2, 0),
                  blurRadius: 2,
                ),
                Shadow(
                  color: Colors.red,
                  offset: Offset(2, 0),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
