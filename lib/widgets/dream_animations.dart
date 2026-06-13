import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Floating particles that drift slowly upward like dream fragments
class DreamParticles extends StatefulWidget {
  final int count;
  final Color color;
  const DreamParticles({super.key, this.count = 20, this.color = AppTheme.primary});

  @override
  State<DreamParticles> createState() => _DreamParticlesState();
}

class _DreamParticlesState extends State<DreamParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particles = List.generate(widget.count, (_) => _Particle(rng));
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        size: Size.infinite,
        painter: _ParticlePainter(_particles, _controller.value, widget.color),
      ),
    );
  }
}

class _Particle {
  double x, y, size, speed, opacity, drift;
  _Particle(Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        size = 1.5 + rng.nextDouble() * 3,
        speed = 0.0003 + rng.nextDouble() * 0.0008,
        opacity = 0.15 + rng.nextDouble() * 0.35,
        drift = (rng.nextDouble() - 0.5) * 0.0002;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;
  _ParticlePainter(this.particles, this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y - progress * p.speed * 100) % 1.0;
      final x = p.x + sin(progress * 6.28 + p.x * 10) * p.drift * 50;
      final paint = Paint()
        ..color = color.withOpacity(p.opacity * (0.5 + 0.5 * sin(progress * 6.28 + p.x * 5)))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(x * size.width, y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.progress != progress;
}

/// Breathing glow effect - a soft pulsing orb
class BreathingGlow extends StatefulWidget {
  final double size;
  final Color color;
  final Widget? child;
  const BreathingGlow({super.key, this.size = 200, this.color = AppTheme.primary, this.child});

  @override
  State<BreathingGlow> createState() => _BreathingGlowState();
}

class _BreathingGlowState extends State<BreathingGlow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final scale = 0.85 + _controller.value * 0.15;
        final opacity = 0.3 + _controller.value * 0.4;
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withOpacity(opacity),
                widget.color.withOpacity(opacity * 0.3),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(opacity * 0.4),
                blurRadius: 40 * scale,
                spreadRadius: 10 * scale,
              ),
            ],
          ),
          child: Transform.scale(scale: scale, child: widget.child),
        );
      },
    );
  }
}

/// Dreamy gradient background that slowly shifts
class DreamBackground extends StatefulWidget {
  final Widget child;
  const DreamBackground({super.key, required this.child});

  @override
  State<DreamBackground> createState() => _DreamBackgroundState();
}

class _DreamBackgroundState extends State<DreamBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -0.5 + sin(t * 2 * pi) * 0.3,
                -0.8 + cos(t * 2 * pi) * 0.2,
              ),
              end: Alignment(
                0.5 + cos(t * 2 * pi) * 0.3,
                0.8 + sin(t * 2 * pi) * 0.2,
              ),
              colors: const [
                Color(0xFF060914),
                Color(0xFF0A1020),
                Color(0xFF11193A),
                Color(0xFF0D1530),
              ],
            ),
          ),
          child: child,
        );
      },
    );
  }
}

/// Fade-in with upward slide animation
class DreamFadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  const DreamFadeIn({super.key, required this.child, this.delay = Duration.zero, this.duration = const Duration(milliseconds: 600)});

  @override
  State<DreamFadeIn> createState() => _DreamFadeInState();
}

class _DreamFadeInState extends State<DreamFadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _offset = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
