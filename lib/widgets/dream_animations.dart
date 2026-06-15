import 'dart:math';
import 'dart:ui' show BlurStyle, ImageFilter, MaskFilter;
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

/// Slow aurora background used across the app.
class DreamBackground extends StatefulWidget {
  final Widget child;
  final bool animated;
  const DreamBackground({super.key, required this.child, this.animated = true});

  @override
  State<DreamBackground> createState() => _DreamBackgroundState();
}

class _DreamBackgroundState extends State<DreamBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 26));
    if (widget.animated) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant DreamBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animated && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return CustomPaint(
            painter: _DreamBackdropPainter(_controller.value),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _DreamBackdropPainter extends CustomPainter {
  final double progress;

  _DreamBackdropPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final base = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.bgDeep,
          AppTheme.bg,
          AppTheme.dusk,
          AppTheme.bgSoft,
        ],
        stops: [0, 0.46, 0.72, 1],
      ).createShader(rect);
    canvas.drawRect(rect, base);

    final t = progress * pi * 2;
    _drawRibbon(canvas, size, t, AppTheme.primary2.withValues(alpha: 0.18), 0.16, 54);
    _drawRibbon(canvas, size, t + 1.7, AppTheme.rose.withValues(alpha: 0.10), 0.42, 68);
    _drawRibbon(canvas, size, t + 3.2, AppTheme.mint.withValues(alpha: 0.11), 0.72, 58);
    _drawDust(canvas, size, t);

    final veil = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppTheme.bgDeep.withValues(alpha: 0.22),
          AppTheme.bgDeep.withValues(alpha: 0.76),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, veil);
  }

  void _drawRibbon(Canvas canvas, Size size, double t, Color color, double baseY, double width) {
    final path = Path();
    final y = size.height * baseY;
    path.moveTo(-size.width * 0.12, y);
    for (var i = 0; i <= 5; i++) {
      final x = size.width * (i / 4.6);
      final dy = sin(t + i * 0.9) * 34 + cos(t * 0.7 + i) * 18;
      path.lineTo(x, y + dy);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 34);
    canvas.drawPath(path, paint);
  }

  void _drawDust(Canvas canvas, Size size, double t) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 58; i++) {
      final seed = i * 37.17;
      final x = (sin(seed) * 0.5 + 0.5) * size.width;
      final y = (cos(seed * 1.31) * 0.5 + 0.5) * size.height;
      final twinkle = 0.18 + (sin(t + i * 0.73) + 1) * 0.12;
      final radius = 0.55 + (i % 5) * 0.16;
      paint.color = (i % 7 == 0 ? AppTheme.moon : Colors.white).withValues(alpha: twinkle);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DreamBackdropPainter oldDelegate) => oldDelegate.progress != progress;
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final Border? border;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.radius = 18,
    this.color,
    this.gradient,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppTheme.panel,
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
            border: border ?? Border.all(color: AppTheme.line),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadow.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class DreamTopBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;

  const DreamTopBar({
    super.key,
    required this.title,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundIconButton(
          icon: Icons.chevron_left,
          onTap: onBack ?? () => Navigator.maybePop(context),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        trailing ?? const SizedBox(width: 36, height: 36),
      ],
    );
  }
}

class DreamRoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const DreamRoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppTheme.muted,
  });

  @override
  Widget build(BuildContext context) {
    return _RoundIconButton(icon: icon, onTap: onTap, color: color);
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.color = AppTheme.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.glass,
          border: Border.all(color: AppTheme.line),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class DreamChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final Color accent;

  const DreamChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.accent = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? accent.withValues(alpha: 0.22) : AppTheme.glass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: selected ? accent.withValues(alpha: 0.62) : AppTheme.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: selected ? accent : AppTheme.muted),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? accent : AppTheme.text,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}

class DreamProcessSteps extends StatelessWidget {
  final List<String> steps;
  final int activeIndex;
  final bool framed;

  const DreamProcessSteps({
    super.key,
    required this.steps,
    required this.activeIndex,
    this.framed = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= activeIndex ? AppTheme.moon : AppTheme.glassStrong,
                  boxShadow: i == activeIndex
                      ? [
                          BoxShadow(
                            color: AppTheme.moon.withValues(alpha: 0.35),
                            blurRadius: 14,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  steps[i],
                  style: TextStyle(
                    fontSize: 13,
                    color: i <= activeIndex ? AppTheme.text : AppTheme.muted,
                    fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          if (i != steps.length - 1) const SizedBox(height: 10),
        ],
      ],
    );

    if (!framed) return content;
    return GlassPanel(padding: const EdgeInsets.all(14), child: content);
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
