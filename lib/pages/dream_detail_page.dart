import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';

class DreamDetailPage extends StatefulWidget {
  final String? dreamId;
  const DreamDetailPage({super.key, this.dreamId});

  @override
  State<DreamDetailPage> createState() => _DreamDetailPageState();
}

class _DreamDetailPageState extends State<DreamDetailPage> {
  late TextEditingController _userFeelingCtrl;
  bool _isEditingFeeling = false;

  @override
  void initState() {
    super.initState();
    final dp = context.read<DreamProvider>();
    final dream = _getDream(dp);
    _userFeelingCtrl = TextEditingController(
      text: (dream?.feelingSource == 'user') ? dream?.feeling ?? '' : '',
    );
  }

  Dream? _getDream(DreamProvider dp) {
    if (widget.dreamId != null) {
      return dp.dreams.where((d) => d.id == widget.dreamId).firstOrNull;
    }
    return dp.latestDream;
  }

  @override
  void dispose() {
    _userFeelingCtrl.dispose();
    super.dispose();
  }

  void _saveUserFeeling() {
    final dp = context.read<DreamProvider>();
    final dream = _getDream(dp);
    if (dream != null) {
      dp.updateFeeling(dream, _userFeelingCtrl.text.trim());
      setState(() => _isEditingFeeling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DreamProvider>();
    final dream = _getDream(dp);

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

                    // Image
                    if (dream.imageUrl != null && dream.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          File(dream.imageUrl!),
                          width: double.infinity, height: 220, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        ),
                      )
                    else
                      _placeholderImage(),
                    const SizedBox(height: 14),

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

                    // AI polished text
                    if (dream.fullText.isNotEmpty && dream.fullText != dream.rawText) ...[
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('AI 整理', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                _badge('散文', AppTheme.primary, AppTheme.primary2),
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
                              _badge('原文', null, null, chipColor: AppTheme.chip, textColor: AppTheme.primary),
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

                    // Feeling section - two columns
                    _buildFeelingSection(dream),
                    const SizedBox(height: 14),

                    // Meta info
                    _card(
                      Text(
                        '记录于 ${dream.createdAt.month}月${dream.createdAt.day}日 ${dream.createdAt.hour.toString().padLeft(2, '0')}:${dream.createdAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 13, color: AppTheme.muted),
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

  Widget _buildFeelingSection(Dream dream) {
    // Collect feelings from both sources
    final hasAiFeeling = dream.feelingSource == 'ai' && dream.feeling != null && dream.feeling!.isNotEmpty;
    final hasUserFeeling = dream.feelingSource == 'user' && dream.feeling != null && dream.feeling!.isNotEmpty;
    final hasAnyFeeling = hasAiFeeling || hasUserFeeling || _userFeelingCtrl.text.isNotEmpty;

    if (!hasAnyFeeling && !_isEditingFeeling) {
      // No feelings yet - show add button
      return _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('感受', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => _isEditingFeeling = true),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.line, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, size: 18, color: AppTheme.muted),
                    const SizedBox(width: 8),
                    Text('添加你的感受', style: TextStyle(fontSize: 14, color: AppTheme.muted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('感受', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          // AI feeling
          if (hasAiFeeling) ...[
            Row(
              children: [
                _badge('AI', AppTheme.primary, AppTheme.primary2),
                const SizedBox(width: 8),
                const Text('AI 感受', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Text(dream.feeling!, style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted)),
            const SizedBox(height: 14),
          ],

          // User feeling
          if (hasUserFeeling && !_isEditingFeeling) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _badge('我', AppTheme.success, null, chipColor: AppTheme.success, textColor: Colors.white),
                    const SizedBox(width: 8),
                    const Text('我的感受', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => _isEditingFeeling = true),
                  child: Icon(Icons.edit, size: 16, color: AppTheme.muted),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(dream.feeling!, style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted)),
          ],

          // Edit user feeling
          if (_isEditingFeeling) ...[
            if (hasAiFeeling) ...[
              Row(
                children: [
                  _badge('我', AppTheme.success, null, chipColor: AppTheme.success, textColor: Colors.white),
                  const SizedBox(width: 8),
                  const Text('我的感受', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),
            ],
            TextField(
              controller: _userFeelingCtrl,
              maxLines: 3,
              style: const TextStyle(fontSize: 14, height: 1.6),
              decoration: InputDecoration(
                hintText: '写下你对这场梦的感受...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _isEditingFeeling = false),
                  child: Text('取消', style: TextStyle(color: AppTheme.muted)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveUserFeeling,
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ],
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

  Widget _placeholderImage() {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppTheme.primary.withOpacity(0.55), AppTheme.primary2.withOpacity(0.2)],
        ),
        border: Border.all(color: AppTheme.line),
      ),
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

  static Widget _badge(String label, Color? gradientStart, Color? gradientEnd, {Color? chipColor, Color? textColor}) {
    if (gradientStart != null && gradientEnd != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [gradientStart, gradientEnd]),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textColor ?? const Color(0xFF08101C))),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor ?? AppTheme.chip,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: textColor ?? AppTheme.primary)),
    );
  }
}
