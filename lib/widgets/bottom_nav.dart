import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final String current;
  const AppBottomNav({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x17FFFFFF)),
        color: const Color(0xE1090D1C),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, '首页', Icons.home_rounded, '/home', current == 'home'),
          _navItem(context, '广场', Icons.explore_rounded, '/square', current == 'square'),
          _centerRecordBtn(context),
          _navItem(context, '我的', Icons.person_rounded, '/profile', current == 'profile'),
        ],
      ),
    );
  }

  static Widget _navItem(BuildContext ctx, String label, IconData icon, String route, bool active) {
    return GestureDetector(
      onTap: () => Navigator.pushNamedAndRemoveUntil(ctx, route, (r) => false),
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: active ? Colors.white : AppTheme.muted),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: active ? Colors.white : AppTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _centerRecordBtn(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(ctx, '/record-choice'),
      child: Container(
        width: 58, height: 58,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9F95FF), Color(0xFF6CE7FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary2.withOpacity(0.24),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 22, color: Color(0xFF08101C)),
            Text('记录', style: TextStyle(fontSize: 10, color: Color(0xFF08101C), fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
