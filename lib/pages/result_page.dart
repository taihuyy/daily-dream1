import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../theme/app_theme.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

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
                      child: Text('整理结果', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppTheme.success, AppTheme.primary2]),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('整理完成', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF08101C))),
                  ),
                  const SizedBox(width: 12),
                  Text('这场差点消失的梦，已经被留下来了', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                ],
              ),
              const SizedBox(height: 16),

              _resultCard(
                dream?.title ?? '雨夜列车上的旧同学',
                dream?.rawText ?? '你梦见自己困在一列似乎永远不会到站的旧火车上...',
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
                    const Text('完整梦境文本', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Text(
                      dream?.fullText ?? '我坐在一列很旧的火车上，车厢里全是小时候的同学。大家都认识我，却没有一个人愿意开口...',
                      style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted),
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
                    const Text('梦境标签', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (dream?.tags ?? ['火车', '童年', '暴雨', '循环', '悬疑']).map((tag) =>
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
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/image'),
                        child: const Text('生成图片'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.line),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('生成视频'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.line),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('保存'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/publish'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.line),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('公开分享'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _resultCard(String title, String subtitle) {
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
}
