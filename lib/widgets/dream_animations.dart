import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Breathing glow effect - a soft pulsing orb
class BreathingGlow extends StatefulWidget {
  final double size;
  final Color color;
  const BreathingGlow({super.key, this.size = 200, this.color = AppTheme.primary});

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
                widget.color.withValues(alpha: opacity),
                widget.color.withValues(alpha: opacity * 0.3),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: opacity * 0.4),
                blurRadius: 40 * scale,
                spreadRadius: 10 * scale,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Static dreamy gradient background (no animation controller = no GPU strain)
class DreamBackground extends StatelessWidget {
  final Widget child;
  const DreamBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF060914),
            Color(0xFF0A1020),
            Color(0xFF11193A),
            Color(0xFF0D1530),
          ],
        ),
      ),
      child: child,
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
