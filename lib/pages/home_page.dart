import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dream.dart';
import '../providers/dream_provider.dart';
import '../services/sensory_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/dream_animations.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DreamProvider>();
    final latest = dp.latestDream;

    return Scaffold(
      body: DreamBackground(
        child: Stack(
          children: [
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 122),
                children: [
                  DreamFadeIn(child: _topBar(context)),
                  const SizedBox(height: 18),
                  DreamFadeIn(
                    delay: const Duration(milliseconds: 120),
                    child: _heroCard(context, dp),
                  ),
                  const SizedBox(height: 18),
                  if (latest != null)
                    DreamFadeIn(
                      delay: const Duration(milliseconds: 240),
                      child: _latestDream(context, latest),
                    ),
                  const SizedBox(height: 18),
                  DreamFadeIn(
                    delay: const Duration(milliseconds: 360),
                    child: _dreamSignals(dp),
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNav(current: 'home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 11 ? '早安，昨夜做梦了吗' : hour < 18 ? '今天的梦，还在发光吗' : '今晚，给梦留一个入口';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
              const SizedBox(height: 4),
              const Text('梦境天象台', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        DreamRoundIconButton(
          icon: Icons.tune_rounded,
          onTap: () {
            SensoryService.softTap();
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }

  Widget _heroCard(BuildContext context, DreamProvider dp) {
    return GlassPanel(
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primary.withValues(alpha: 0.20),
          AppTheme.rose.withValues(alpha: 0.10),
          AppTheme.panelStrong,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.moon.withValues(alpha: 0.18),
                  border: Border.all(color: AppTheme.moon.withValues(alpha: 0.34)),
                ),
                child: const Icon(Icons.nights_stay_rounded, color: AppTheme.moon),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '把快要散开的画面收回来',
                  style: TextStyle(fontSize: 20, height: 1.25, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '先记录碎片，再让 AI 帮你追问、润色、显影成图。',
            style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.text.withValues(alpha: 0.78)),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _signalPill(Icons.auto_awesome_rounded, '${dp.totalDreams} 场梦', AppTheme.mint),
              const SizedBox(width: 8),
              _signalPill(Icons.public_rounded, '${dp.totalShares} 次分享', AppTheme.primary2),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                SensoryService.action();
                Navigator.pushNamed(context, '/record-choice');
              },
              icon: const Icon(Icons.edit_note_rounded, size: 20),
              label: const Text('开始记录'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _latestDream(BuildContext context, Dream dream) {
    final title = dream.title.isEmpty ? '未命名的梦' : dream.title;
    final preview = dream.fullText.isNotEmpty ? dream.fullText : dream.rawText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('最近一次梦境', _formatTime(dream.createdAt)),
        const SizedBox(height: 12),
        GlassPanel(
          onTap: () {
            SensoryService.softTap();
            Navigator.pushNamed(context, '/dream-detail');
          },
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bedtime_rounded, size: 18, color: AppTheme.moon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppTheme.muted.withValues(alpha: 0.7)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                preview.isEmpty ? '这场梦还没有整理完成。' : preview,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.65, color: AppTheme.muted),
              ),
              if (dream.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: dream.tags.take(3).map((tag) => DreamChip(label: tag, accent: AppTheme.moon)).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _dreamSignals(DreamProvider dp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('梦境记录', '连续 ${dp.totalDreams > 0 ? 3 : 0} 天'),
        const SizedBox(height: 12),
        Row(
          children: [
            _statBox('已保存', '${dp.totalDreams}', Icons.archive_rounded, AppTheme.primary2),
            const SizedBox(width: 12),
            _statBox('已分享', '${dp.totalShares}', Icons.waves_rounded, AppTheme.rose),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        Text(value, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
      ],
    );
  }

  Widget _statBox(String label, String value, IconData icon, Color accent) {
    return Expanded(
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent, size: 18),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _signalPill(IconData icon, String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.month.toString().padLeft(2, '0')}/${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
