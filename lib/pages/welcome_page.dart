import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF060914), AppTheme.bg, Color(0xFF11193A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.chip,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('BETA', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
                const SizedBox(height: 24),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primary2],
                  ).createShader(bounds),
                  child: const Text(
                    '每日梦境',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '醒来后，别让梦悄悄消失。\n用 AI 帮你把模糊的碎片回忆、整理、生成并留下来。',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white.withOpacity(0.76)),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text('进入梦境'),
                  ),
                ),
                const Spacer(flex: 2),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xEE121934),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('这个原型能演示什么', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(
                        '包含记录、AI 追问、整理结果、图片生成、广场浏览和详情互动，\n适合先拿去讲思路和确认页面结构。',
                        style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
