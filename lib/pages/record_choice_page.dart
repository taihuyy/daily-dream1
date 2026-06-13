import 'package:flutter/material.dart';
import '../widgets/dream_animations.dart';
import '../theme/app_theme.dart';

class RecordChoicePage extends StatelessWidget {
  const RecordChoicePage({super.key});

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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.line),
                        color: const Color(0x0AFFFFFF),
                      ),
                      child: const Icon(Icons.chevron_left, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('记录梦境', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 20),
              _infoCard(
                '你想怎么记录这场梦？',
                '先把最先想起来的碎片留下，AI 会在后续继续追问并整理。',
              ),
              const SizedBox(height: 16),
              _choiceCard(
                context,
                title: '文字记录',
                desc: '适合已经记得主要内容，想快速把场景、人物和情绪写下来。',
                onTap: () => Navigator.pushNamed(context, '/record-text'),
              ),
              const SizedBox(height: 14),
              _choiceCard(
                context,
                title: '语音记录',
                desc: '适合刚醒来来不及整理，只想先把梦说出来。',
                onTap: () => Navigator.pushNamed(context, '/record-voice'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEE121934),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted)),
        ],
      ),
    );
  }

  static Widget _choiceCard(BuildContext context, {required String title, required String desc, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xEE121934),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(desc, style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}
