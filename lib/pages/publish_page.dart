import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../theme/app_theme.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final _feelingController = TextEditingController();
  bool _anonymous = true;
  bool _public = true;
  bool _allowShare = true;
  String _selectedTag = '悬疑';

  @override
  void dispose() {
    _feelingController.dispose();
    super.dispose();
  }

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
                      child: Text('分享这场梦', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('发布预览', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('会以梦境卡片形式出现在广场', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.chip,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text('匿名可开', style: TextStyle(fontSize: 11, color: AppTheme.primary)),
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
                    Text(dream?.title ?? '雨夜列车上的旧同学',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      dream?.fullText?.substring(0, (dream.fullText.length).clamp(0, 40)) ?? '一列永远到不了站的旧火车...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: AppTheme.muted),
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
                    const Text('补充一句感受', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _feelingController,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '写下你的感受...',
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
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
                    const Text('选择标签', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: ['悬疑', '童年', '重复梦', '超现实'].map((tag) {
                        final selected = _selectedTag == tag;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTag = tag),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppTheme.primary.withOpacity(0.3) : AppTheme.chip,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: selected ? AppTheme.primary : AppTheme.line),
                            ),
                            child: Text(tag, style: TextStyle(
                              fontSize: 13,
                              color: selected ? AppTheme.primary : AppTheme.text,
                            )),
                          ),
                        );
                      }).toList(),
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
                  children: [
                    _toggleRow('匿名发布', _anonymous, (v) => setState(() => _anonymous = v)),
                    const SizedBox(height: 16),
                    _toggleRow('公开可见', _public, (v) => setState(() => _public = v)),
                    const SizedBox(height: 16),
                    _toggleRow('允许他人转发', _allowShare, (v) => setState(() => _allowShare = v)),
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
            onPressed: () {
              final dp = context.read<DreamProvider>();
              final dream = dp.latestDream;
              if (dream != null) {
                dp.publishDream(dream, feeling: _feelingController.text, feelingSource: 'user', anonymous: _anonymous);
              }
              Navigator.pushNamedAndRemoveUntil(context, '/square', (r) => false);
            },
            child: const Text('发布到广场'),
          ),
        ),
      ),
    );
  }

  static Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44, height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: value
                  ? const LinearGradient(colors: [AppTheme.primary, AppTheme.success])
                  : const LinearGradient(colors: [Color(0xFF2A2A3A), Color(0xFF3A3A4A)]),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20, height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
