import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

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
                      child: Text('梦境图像', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.line),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withOpacity(0.55),
                      AppTheme.primary2.withOpacity(0.2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 40, right: 40,
                      child: Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary2.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, const Color(0xFF050814).withOpacity(0.8)],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(Icons.train, size: 80, color: Colors.white.withOpacity(0.2)),
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
                    const Text('雨夜列车上的旧同学', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                      '旧火车在暴雨夜穿过无人的城市，沉默的童年同学坐在车厢里，所有窗外风景像卡住的胶片一样不断重复。',
                      style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                children: ['朦胧', '超现实', '电影感'].map((tag) =>
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

              Row(
                children: [
                  Expanded(child: _outlineBtn('重新生成')),
                  const SizedBox(width: 10),
                  Expanded(child: _outlineBtn('换种风格')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _outlineBtn('保存图片')),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/publish'),
                        child: const Text('去分享'),
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

  static Widget _outlineBtn(String label) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.text,
          side: const BorderSide(color: AppTheme.line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(label),
      ),
    );
  }
}
