import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/dream_animations.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DreamBackground(
        child: Stack(
          children: [
            // Floating particles
            const DreamParticles(count: 25, color: AppTheme.primary),

            // Breathing glow orbs
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.1,
              child: const BreathingGlow(size: 180, color: AppTheme.primary2),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              right: MediaQuery.of(context).size.width * 0.05,
              child: const BreathingGlow(size: 140, color: AppTheme.primary),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    DreamFadeIn(
                      delay: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.chip,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text('BETA', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    DreamFadeIn(
                      delay: const Duration(milliseconds: 500),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primary2],
                        ).createShader(bounds),
                        child: const Text(
                          '每日梦境',
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    DreamFadeIn(
                      delay: const Duration(milliseconds: 800),
                      child: Text(
                        '醒来后，别让梦悄悄消失。\n用 AI 帮你把模糊的碎片回忆、整理、生成并留下来。',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white.withOpacity(0.76)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    DreamFadeIn(
                      delay: const Duration(milliseconds: 1100),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                          child: const Text('进入梦境'),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    DreamFadeIn(
                      delay: const Duration(milliseconds: 1400),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xEE121934),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AI 梦境助手', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                              '记录 → AI 追问 → 散文润色 → 梦境画面生成\n每一次醒来，都值得被温柔对待。',
                              style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
