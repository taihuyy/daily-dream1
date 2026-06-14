import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';

class DreamDetailPage extends StatelessWidget {
  final String? dreamId;
  const DreamDetailPage({super.key, this.dreamId});

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DreamProvider>();
    final dream = dreamId != null
        ? dp.dreams.where((d) => d.id == dreamId).firstOrNull
        : dp.latestDream;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF060914), AppTheme.bg, Color(0xFF11193A)],
          ),
        ),
        child: SafeArea(
          child: dream == null
              ? Center(child: Text('梦境不存在', style: TextStyle(color: AppTheme.muted)))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
                  children: [
                    const SizedBox(height: 8),
                    _buildTopBar(context),
                    const SizedBox(height: 16),

                    // Dream image (if exists)
                    if (dream.imageUrl != null && dream.imageUrl!.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          File(dream.imageUrl!),
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft, end: Alignment.bottomRight,
                                colors: [AppTheme.primary.withOpacity(0.55), AppTheme.primary2.withOpacity(0.2)],
                              ),
                              border: Border.all(color: AppTheme.line),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ] else ...[
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                            colors: [AppTheme.primary.withOpacity(0.55), AppTheme.primary2.withOpacity(0.2)],
                          ),
                          border: Border.all(color: AppTheme.line),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Title + Tags
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dream.title.isEmpty ? '未命名的梦' : dream.title,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                          if (dream.tags.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: dream.tags.map((tag) =>
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // AI polished text (if exists)
                    if (dream.fullText.isNotEmpty && dream.fullText != dream.rawText) ...[
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('AI 整理', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primary2]),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text('散文', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF08101C))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(dream.fullText, style: TextStyle(fontSize: 14, height: 1.8, color: AppTheme.muted)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Original record
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('原始记录', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.chip,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text('原文', style: TextStyle(fontSize: 10, color: AppTheme.primary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            dream.rawText.isEmpty ? '（无原始记录）' : dream.rawText,
                            style: TextStyle(fontSize: 14, height: 1.8, color: AppTheme.text.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Meta info
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '记录于 ${dream.createdAt.month}月${dream.createdAt.day}日 ${dream.createdAt.hour.toString().padLeft(2, '0')}:${dream.createdAt.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 13, color: AppTheme.muted),
                          ),
                          if (dream.feeling != null && dream.feeling!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text('感受：${dream.feeling}', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                          ],
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
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xE60A1020)],
          ),
        ),
        child: SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/record-choice'),
            child: const Text('我也记录一场'),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
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
          child: Center(child: Text('梦境详情', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        ),
        const SizedBox(width: 36),
      ],
    );
  }

  static Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEE121934),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.line),
      ),
      child: child,
    );
  }
}
