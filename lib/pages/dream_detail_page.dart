import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../theme/app_theme.dart';

class DreamDetailPage extends StatelessWidget {
  const DreamDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dream = context.watch<DreamProvider>().latestDream;

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
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
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
                      child: Text('梦境详情', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xEE121934),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primary2]),
                          ),
                          child: const Center(
                            child: Text('M', style: TextStyle(color: Color(0xFF08101C), fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('匿名做梦者', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text('今天 06:28', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.chip,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('匿名', style: TextStyle(fontSize: 11, color: AppTheme.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withOpacity(0.55),
                      AppTheme.primary2.withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(color: AppTheme.line),
                ),
              ),
              const SizedBox(height: 14),

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
                    Text(dream?.title ?? '雨夜列车上的旧同学',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: (dream?.tags ?? ['悬疑', '童年', '暴雨']).map((tag) =>
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.chip,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppTheme.line),
                          ),
                          child: Text(tag, style: const TextStyle(fontSize: 13)),
                        ),
                      ).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dream?.fullText ?? '我坐在一列很旧的火车上，车厢里全是小时候的同学...',
                      style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _actionStat(Icons.favorite_border, '${dream?.likes ?? 248}'),
                        const SizedBox(width: 20),
                        _actionStat(Icons.chat_bubble_outline, '${dream?.comments ?? 41}'),
                        const SizedBox(width: 20),
                        _actionStat(Icons.share, '${dream?.shares ?? 19}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

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
                    const Text('评论', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    _comment('雾中的猫', '3 分钟前', '"永远到不了站"这个意象太有梦的感觉了，像被困在记忆里。'),
                    const SizedBox(height: 12),
                    _comment('月亮邮局', '刚刚', '这种沉默的童年同学真的很诡异，但画面感非常强。'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xE60A1020)],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/record-choice'),
            child: const Text('我也记录一场'),
          ),
        ),
      ),
    );
  }

  static Widget _actionStat(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.muted),
        const SizedBox(width: 6),
        Text(count, style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
      ],
    );
  }

  static Widget _comment(String name, String time, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(time, style: TextStyle(fontSize: 13, color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted)),
        ],
      ),
    );
  }
}
