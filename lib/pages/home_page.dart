import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
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
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
                children: [
                  DreamFadeIn(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('早安，昨夜做梦了吗', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                            const SizedBox(height: 4),
                            const Text('今天的梦，还记得多少？', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pushNamed(context, '/settings'),
                          icon: const Icon(Icons.settings, color: AppTheme.muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  DreamFadeIn(
                    delay: const Duration(milliseconds: 200),
                    child: _heroCard(context),
                  ),
                  const SizedBox(height: 20),

                  if (latest != null)
                    DreamFadeIn(
                      delay: const Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('最近一次梦境', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                              Text(
                                '${latest.createdAt.month.toString().padLeft(2, '0')}/${latest.createdAt.day.toString().padLeft(2, '0')} ${latest.createdAt.hour.toString().padLeft(2, '0')}:${latest.createdAt.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 13, color: AppTheme.muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/dream-detail'),
                            child: _latestDreamCard(latest),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  DreamFadeIn(
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('梦境记录', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            Text('连续 ${dp.totalDreams > 0 ? 3 : 0} 天', style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _statBox('已保存', '${dp.totalDreams}'),
                            const SizedBox(width: 12),
                            _statBox('已分享', '${dp.totalShares}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Positioned(
              left: 14, right: 14, bottom: 14,
              child: AppBottomNav(current: 'home'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _heroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppTheme.primary.withOpacity(0.28), const Color(0xFF0E142C).withOpacity(0.92)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('记录今天的梦', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            '用文字或语音，先把还记得的碎片留下。\n剩下的，让 AI 帮你慢慢拼完整。',
            style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white.withOpacity(0.76)),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/record-choice'),
              child: const Text('开始记录'),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _latestDreamCard(dynamic dream) {
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
          Text(dream.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            dream.rawText,
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  static Widget _statBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
