import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Replicates the Tebaba website's animated background:
/// - Dark base (#030A10)
/// - Subtle grid overlay
/// - Radial teal glow (top-left area)
/// - Floating particles
class AppBackground extends StatefulWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with TickerProviderStateMixin {
  late final List<_Particle> _particles;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final rand = math.Random();
    _particles = List.generate(22, (i) => _Particle(rand));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
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

        // Animated particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _ParticlePainter(_particles, _controller.value),
              child: const SizedBox.expand(),
            );
          },
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
        CustomPaint(
          painter: _GridPainter(),
          child: const SizedBox.expand(),
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class _Particle {
  final double x; // 0–1 relative to screen width
  final double startY; // starting position (1 = bottom, comes from bottom)
  final double size;
  final double speed; // duration multiplier
  final double delay; // animation delay 0–1
  final Color color;

  _Particle(math.Random rand)
      : x = rand.nextDouble(),
        startY = rand.nextDouble(),
        size = rand.nextDouble() * 4 + 2,
        speed = rand.nextDouble() * 0.5 + 0.3,
        delay = rand.nextDouble(),
        color = [
          const Color(0xFF00C2A8).withValues(alpha: 0.4),
          const Color(0xFF0B4F6C).withValues(alpha: 0.6),
          const Color(0xFFE8A020).withValues(alpha: 0.3),
        ][rand.nextInt(3)];
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t; // animation value 0–1

  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Each particle drifts upward, loops with its own speed + delay
      final progress = ((t * p.speed + p.delay) % 1.0);
      final y = size.height * (1 - progress); // bottom to top
      final x = size.width * p.x;

      canvas.drawCircle(
        Offset(x, y),
        p.size,
        Paint()..color = p.color,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
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
