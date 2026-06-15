import 'package:flutter/material.dart';
import '../services/sensory_service.dart';
import '../widgets/dream_animations.dart';
import '../theme/app_theme.dart';

class RecordChoicePage extends StatelessWidget {
  const RecordChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DreamBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              const DreamTopBar(title: '记录梦境'),
              const SizedBox(height: 22),
              DreamFadeIn(
                child: GlassPanel(
                  padding: const EdgeInsets.all(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.mint.withValues(alpha: 0.12),
                      AppTheme.primary.withValues(alpha: 0.14),
                      AppTheme.panelStrong,
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '选择一条进入梦的路径',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '刚醒来的碎片最容易散开。先留下声音、地点、人物或情绪，完整度可以慢慢补。',
                        style: TextStyle(fontSize: 14, height: 1.65, color: AppTheme.text.withValues(alpha: 0.76)),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          DreamChip(label: '碎片', icon: Icons.blur_on_rounded, accent: AppTheme.moon),
                          DreamChip(label: '情绪', icon: Icons.water_drop_rounded, accent: AppTheme.primary2),
                          DreamChip(label: '画面', icon: Icons.panorama_rounded, accent: AppTheme.rose),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DreamFadeIn(
                delay: const Duration(milliseconds: 120),
                child: _choiceCard(
                  context,
                  icon: Icons.edit_note_rounded,
                  accent: AppTheme.moon,
                  title: '文字记录',
                  desc: '适合已经抓住了几个关键画面，想安静地把梦写下来。',
                  route: '/record-text',
                ),
              ),
              const SizedBox(height: 14),
              DreamFadeIn(
                delay: const Duration(milliseconds: 220),
                child: _choiceCard(
                  context,
                  icon: Icons.mic_rounded,
                  accent: AppTheme.primary2,
                  title: '语音记录',
                  desc: '适合刚醒来不想组织语言，直接把梦说出来。',
                  route: '/record-voice',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _choiceCard(
    BuildContext context, {
    required IconData icon,
    required Color accent,
    required String title,
    required String desc,
    required String route,
  }) {
    return GlassPanel(
      onTap: () {
        SensoryService.action();
        Navigator.pushNamed(context, route);
      },
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: accent.withValues(alpha: 0.15),
              border: Border.all(color: accent.withValues(alpha: 0.34)),
            ),
            child: Icon(icon, color: accent, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(fontSize: 14, height: 1.5, color: AppTheme.muted)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.chevron_right_rounded, color: AppTheme.muted.withValues(alpha: 0.72)),
        ],
      ),
    );
  }
}
