import 'dart:math';
import 'package:flutter/material.dart';

class FrequencyDial extends StatefulWidget {
  final double frequency;
  final Function(double) onFrequencyChanged;

  const FrequencyDial({
    super.key,
    required this.frequency,
    required this.onFrequencyChanged,
  });

  @override
  State<FrequencyDial> createState() => _FrequencyDialState();
}

class _FrequencyDialState extends State<FrequencyDial> {
  double _rotation = 0;

  @override
  void initState() {
    super.initState();
    _rotation = (widget.frequency - 87.5) * (pi * 2 / 20.5); // 87.5 to 108.0 (20.5 range)
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Calculate rotation based on drag
          _rotation += details.delta.dx * 0.01;
          
          // Map rotation back to frequency
          double freq = 87.5 + (_rotation % (pi * 2)) * (20.5 / (pi * 2));
          if (freq < 87.5) freq = 87.5;
          if (freq > 108.0) freq = 108.0;
          
          widget.onFrequencyChanged(freq);
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  blurRadius: 100,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          
          // Tick Marks
          Transform.rotate(
            angle: _rotation,
            child: CustomPaint(
              size: const Size(300, 300),
              painter: DialPainter(primaryColor: Theme.of(context).colorScheme.primary),
            ),
          ),
          
          // Center Frequency Display
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.frequency.toStringAsFixed(1),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                ),
              ),
              Text(
                "MHz",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
          
          // Indicator Needle (Fixed)
          Positioned(
            top: 0,
            child: Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DialPainter extends CustomPainter {
  final Color primaryColor;
  DialPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw 100 ticks
    for (int i = 0; i < 100; i++) {
      final angle = (i * 2 * pi) / 100;
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 15.0 : 8.0;
      
      final start = Offset(
        center.dx + (radius - tickLength) * cos(angle),
        center.dy + (radius - tickLength) * sin(angle),
      );
      final end = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      
      paint.color = isMajor ? Colors.white70 : Colors.white24;
      paint.strokeWidth = isMajor ? 3 : 1.5;
      
      canvas.drawLine(start, end, paint);
    }
    
    // Outer Circle
    canvas.drawCircle(center, radius, paint..color = Colors.white10);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
