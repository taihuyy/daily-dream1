import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_video_provider.dart';
import '../theme/app_theme.dart';

class ImageVideoPage extends StatefulWidget {
  const ImageVideoPage({super.key});

  @override
  State<ImageVideoPage> createState() => _ImageVideoPageState();
}

class _ImageVideoPageState extends State<ImageVideoPage> {
  final _promptController = TextEditingController();
  String _selectedType = 'image';
  Timer? _pollTimer;

  @override
  void dispose() {
    _promptController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  void _generate() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    final provider = context.read<ImageVideoProvider>();

    if (_selectedType == 'image') {
      provider.generateImage(prompt);
    } else {
      provider.generateVideo(prompt);
    }

    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final provider = context.read<ImageVideoProvider>();
      final result = await provider.pollTaskResult();
      if (result != null) {
        final status = result['output']?['task_status'];
        if (status == 'SUCCEEDED' || status == 'FAILED') {
          _pollTimer?.cancel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
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
                      child: Text('生成图像/视频', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 20),

              _buildTypeSelector(),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.panelStrong,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.line),
                ),
                child: TextField(
                  controller: _promptController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _selectedType == 'image'
                        ? '描述你想要生成的梦境画面...\n比如：一列旧火车在暴雨夜穿过无人的城市'
                        : '描述你想要生成的梦境视频...\n比如：沉默的童年同学坐在车厢里，窗外暴雨不断',
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  if (provider.error != null) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(provider.error!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  if (provider.resultUrl != null) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            provider.resultUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color(0x0AFFFFFF),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.line),
                              ),
                              child: const Center(child: Text('图片加载失败', style: TextStyle(color: AppTheme.muted))),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  if (provider.isLoading) {
                    return Column(
                      children: [
                        SizedBox(
                          width: 60, height: 60,
                          child: CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedType == 'image' ? '正在生成梦境画面...' : '正在生成梦境视频...',
                          style: TextStyle(color: AppTheme.muted, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _generate,
                      child: Text(_selectedType == 'image' ? '生成图像' : '生成视频'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = 'image'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedType == 'image' ? AppTheme.primary.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: _selectedType == 'image' ? Border.all(color: AppTheme.primary.withOpacity(0.4)) : null,
                ),
                child: Center(
                  child: Text(
                    '图像',
                    style: TextStyle(
                      color: _selectedType == 'image' ? AppTheme.primary : AppTheme.muted,
                      fontWeight: _selectedType == 'image' ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = 'video'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedType == 'video' ? AppTheme.primary.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: _selectedType == 'video' ? Border.all(color: AppTheme.primary.withOpacity(0.4)) : null,
                ),
                child: Center(
                  child: Text(
                    '视频',
                    style: TextStyle(
                      color: _selectedType == 'video' ? AppTheme.primary : AppTheme.muted,
                      fontWeight: _selectedType == 'video' ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
