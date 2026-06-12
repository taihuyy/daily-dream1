import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_theme.dart';

class SquarePage extends StatelessWidget {
  const SquarePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dreams = context.watch<DreamProvider>().dreams;

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
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('梦境广场', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                      const SizedBox(height: 4),
                      const Text('今天大家都梦见了什么', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: AppTheme.muted),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['推荐', '治愈', '悬疑', '童年', '重复梦'].map((tag) =>
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: tag == '推荐' ? AppTheme.primary.withOpacity(0.3) : AppTheme.chip,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: tag == '推荐' ? AppTheme.primary : AppTheme.line),
                      ),
                      child: Text(tag, style: TextStyle(
                        fontSize: 13,
                        color: tag == '推荐' ? AppTheme.primary : AppTheme.muted,
                      )),
                    ),
                  ).toList(),
                ),
              ),
              const SizedBox(height: 14),

              ...dreams.where((d) => d.isPublished).map((dream) =>
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/dream-detail'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xEE121934),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                  child: Center(
                                    child: Text(
                                      dream.title.characters.first,
                                      style: const TextStyle(color: Color(0xFF08101C), fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dream.isAnonymous ? '匿名做梦者' : '用户${dream.id.substring(0, 4)}',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${dream.createdAt.hour}:${dream.createdAt.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(fontSize: 13, color: AppTheme.muted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (dream.isAnonymous)
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
                        const SizedBox(height: 12),
                        Container(
                          height: 156,
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
                        const SizedBox(height: 12),
                        Text(dream.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(
                          dream.rawText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: AppTheme.muted),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _actionStat(Icons.favorite_border, '${dream.likes}'),
                            const SizedBox(width: 20),
                            _actionStat(Icons.chat_bubble_outline, '${dream.comments}'),
                            const SizedBox(width: 20),
                            _actionStat(Icons.share, '${dream.shares}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(current: 'square'),
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
}
