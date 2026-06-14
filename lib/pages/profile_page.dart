import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_theme.dart';
import 'dream_detail_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DreamProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
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
                  Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primary2]),
                        ),
                        child: const Center(
                          child: Text('你', style: TextStyle(color: Color(0xFF08101C), fontWeight: FontWeight.w800, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('我的梦境', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          Text('已记录 ${dp.totalDreams} 场梦', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    icon: const Icon(Icons.settings, color: AppTheme.muted),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _statBox('梦境总数', '${dp.totalDreams}'),
                  const SizedBox(width: 12),
                  _statBox('已分享', '${dp.totalShares}'),
                ],
              ),
              const SizedBox(height: 20),

              _menuCard([
                _menuItem(Icons.tune, 'AI 设置', '配置 API Key 和模型', () => Navigator.pushNamed(context, '/settings')),
                _menuItem(Icons.info_outline, '关于', '每日梦境 v1.0', () {}),
              ]),
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
                    const Text('我的梦境库', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    if (dp.dreams.isEmpty)
                      Text('还没有记录，去记录第一场梦吧', style: TextStyle(fontSize: 14, color: AppTheme.muted)),
                    ...dp.dreams.map((dream) =>
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DreamDetailPage(dreamId: dream.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dream.fullText.isNotEmpty ? AppTheme.success : AppTheme.muted,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${dream.createdAt.month.toString().padLeft(2, '0')}/${dream.createdAt.day.toString().padLeft(2, '0')} ',
                                style: TextStyle(fontSize: 13, color: AppTheme.muted),
                              ),
                              Expanded(
                                child: Text(
                                  dream.title.isEmpty ? '未命名的梦' : dream.title,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.chevron_right, size: 16, color: AppTheme.muted),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(current: 'profile'),
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

  static Widget _menuCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xEE121934),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(children: children),
    );
  }

  static Widget _menuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppTheme.muted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }
}
