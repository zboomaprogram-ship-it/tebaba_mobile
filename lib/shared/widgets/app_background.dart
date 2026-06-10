import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Replicates the Tebaba website's animated background:
/// - Dark base (#030A10)
/// - Subtle grid overlay
/// - Radial teal glow (top-left area)
/// - Lush field of 35 glowing, floating 3D rotating DNA double helices drifting upwards
class AppBackground extends StatefulWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with TickerProviderStateMixin {
  late List<_DnaParticle> _dnaParticles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final rand = math.Random();
    _dnaParticles = List.generate(35, (i) => _DnaParticle(rand));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark background
        Container(color: const Color(0xFF030A10)),

        // Animated 3D DNA background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _DnaPainter(
                  t: _controller.value,
                  dnaParticles: _dnaParticles,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),

        // Radial glow — top left
        Positioned(
          top: -200,
          left: -100,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00C2A8).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Subtle grid overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(),
            child: const SizedBox.expand(),
          ),
        ),

        // Content
        Positioned.fill(
          child: widget.child,
        ),
      ],
    );
  }
}

class _DnaParticle {
  final double x; // 0-1 relative to width
  final double startY; // 0-1 relative to height
  final double size; // 8 to 20 pixels wide
  final double speed;
  final double delay;
  final double rotationPhase;
  final double wobbleSpeed;
  final double wobbleAmplitude;
  final Color color;

  _DnaParticle(math.Random rand)
      : x = rand.nextDouble(),
        startY = rand.nextDouble(),
        size = rand.nextDouble() * 12 + 8, // 8 to 20 pixels wide
        speed = rand.nextDouble() * 0.12 + 0.08,
        delay = rand.nextDouble(),
        rotationPhase = rand.nextDouble() * 2 * math.pi,
        wobbleSpeed = rand.nextDouble() * 2 + 1.5,
        wobbleAmplitude = rand.nextDouble() * 10 + 5,
        color = const Color(0xFF00C2A8);
}

class _DnaPainter extends CustomPainter {
  final double t; // animation progress 0 to 1
  final List<_DnaParticle> dnaParticles;

  _DnaPainter({required this.t, required this.dnaParticles});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw 35 glowing, floating 3D rotating DNA double helices drifting upwards
    for (final particle in dnaParticles) {
      _drawDnaParticle(canvas, size, particle);
    }
  }

  void _drawDnaParticle(Canvas canvas, Size size, _DnaParticle particle) {
    final progress = ((t * particle.speed + particle.delay) % 1.0);
    final y = size.height * (1 - progress);
    
    // Wobble dynamically side-to-side for fluid organic motion
    final wobble = math.sin(t * particle.wobbleSpeed * math.pi + particle.delay * 10) * particle.wobbleAmplitude;
    final x = (size.width * particle.x) + wobble;

    // Fade out smoothly near top and bottom edges
    double alphaFactor = 1.0;
    if (progress < 0.15) {
      alphaFactor = progress / 0.15;
    } else if (progress > 0.85) {
      alphaFactor = (1.0 - progress) / 0.15;
    }

    final baseOpacity = 0.03 + (particle.size / 20.0) * 0.07; 
    final opacity = baseOpacity * alphaFactor;

    // Only paint if visible
    if (opacity <= 0) return;

    // Draw the micro DNA double-helix
    final helixWidth = particle.size * 0.9;
    final spacing = particle.size * 0.6;
    final rotation = (t * 4 * math.pi) + particle.rotationPhase;

    for (int j = -1; j <= 1; j++) {
      final rY = y + (j * spacing);
      final rTheta = (j * 0.8) + rotation;

      final xA = x + (helixWidth / 2) * math.sin(rTheta);
      final zA = math.cos(rTheta);

      final xB = x - (helixWidth / 2) * math.sin(rTheta);

      final dnaOpacity = opacity * 1.5;
      final nodeSize = 0.8 + (zA + 1.0) * 0.7;

      // Connecting rung
      canvas.drawLine(
        Offset(xA, rY),
        Offset(xB, rY),
        Paint()
          ..color = particle.color.withValues(alpha: dnaOpacity * 0.4)
          ..strokeWidth = 0.8,
      );

      // Back node
      if (zA < 0) {
        canvas.drawCircle(Offset(xA, rY), nodeSize, Paint()..color = particle.color.withValues(alpha: dnaOpacity));
      }
      // Front node
      if (zA >= 0) {
        canvas.drawCircle(Offset(xA, rY), nodeSize, Paint()..color = particle.color.withValues(alpha: dnaOpacity));
      }
      
      // Node B
      canvas.drawCircle(Offset(xB, rY), nodeSize, Paint()..color = particle.color.withValues(alpha: dnaOpacity));
    }
  }

  @override
  bool shouldRepaint(_DnaPainter old) => true;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
