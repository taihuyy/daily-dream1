import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_video_provider.dart';
import '../providers/dream_provider.dart';
import '../services/sensory_service.dart';
import '../widgets/dream_animations.dart';
import '../theme/app_theme.dart';

class ImageVideoPage extends StatefulWidget {
  final String? initialPrompt;
  const ImageVideoPage({super.key, this.initialPrompt});

  @override
  State<ImageVideoPage> createState() => _ImageVideoPageState();
}

class _ImageVideoPageState extends State<ImageVideoPage> with SingleTickerProviderStateMixin {
  late final TextEditingController _promptController;
  late final AnimationController _pulseController;
  ImageVideoProvider? _imageProvider;
  String? _lastSavedPath;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(text: widget.initialPrompt ?? '');
    _promptController.addListener(_onPromptChanged);
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<ImageVideoProvider>();
    if (_imageProvider != provider) {
      _imageProvider?.removeListener(_onImageProviderUpdate);
      _imageProvider = provider;
      _imageProvider?.addListener(_onImageProviderUpdate);
    }
  }

  void _onPromptChanged() {
    if (mounted) setState(() {});
  }

  void _onImageProviderUpdate() {
    final path = _imageProvider?.localImagePath;
    if (!mounted || path == null || path.isEmpty || path == _lastSavedPath) return;

    final dp = context.read<DreamProvider>();
    final dream = dp.latestDream;
    if (dream != null && dream.imageUrl != path) {
      dream.imageUrl = path;
      dp.updateDream(dream);
    }
    _lastSavedPath = path;
    SensoryService.success();
  }

  @override
  void dispose() {
    _imageProvider?.removeListener(_onImageProviderUpdate);
    _promptController.removeListener(_onPromptChanged);
    _promptController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _generate() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      SensoryService.warning();
      return;
    }
    SensoryService.action();
    context.read<ImageVideoProvider>().generateImage(prompt);
  }

  @override
  Widget build(BuildContext context) {
    final promptReady = _promptController.text.trim().isNotEmpty;

    return Scaffold(
      body: DreamBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              const DreamTopBar(title: '生成梦境画面'),
              const SizedBox(height: 18),
              DreamFadeIn(child: _promptPanel()),
              const SizedBox(height: 16),
              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  return Column(
                    children: [
                      if (provider.error != null) ...[
                        _errorPanel(provider.error!),
                        const SizedBox(height: 16),
                      ],
                      if (provider.isLoading) ...[
                        _loadingPanel(),
                        const SizedBox(height: 16),
                      ],
                      if (provider.localImagePath != null && provider.localImagePath!.isNotEmpty) ...[
                        _imageResult(provider.localImagePath!),
                        const SizedBox(height: 16),
                      ],
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: provider.isLoading || !promptReady ? null : _generate,
                          icon: Icon(provider.isLoading ? Icons.hourglass_top_rounded : Icons.auto_awesome_rounded, size: 19),
                          label: Text(provider.isLoading ? '正在显影' : '生成图像'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _promptPanel() {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primary2.withValues(alpha: 0.12),
          AppTheme.moon.withValues(alpha: 0.08),
          AppTheme.panelStrong,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.panorama_rounded, size: 18, color: AppTheme.primary2),
              const SizedBox(width: 8),
              const Expanded(child: Text('画面提示词', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
              Text('${_promptController.text.trim().length} 字', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _promptController,
            maxLines: 5,
            minLines: 4,
            style: const TextStyle(fontSize: 15, height: 1.6),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '描述你想显影的梦境画面...\n比如：一列旧火车在暴雨夜穿过无人的城市，车窗里倒映着金色月亮',
              fillColor: Colors.transparent,
              filled: false,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              DreamChip(label: '胶片感', icon: Icons.camera_rounded, accent: AppTheme.moon),
              DreamChip(label: '雾气', icon: Icons.blur_on_rounded, accent: AppTheme.primary2),
              DreamChip(label: '低饱和', icon: Icons.tonality_rounded, accent: AppTheme.mint),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loadingPanel() {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) {
              final value = _pulseController.value;
              return Container(
                width: 78 + value * 8,
                height: 78 + value * 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: AppTheme.primary2.withValues(alpha: 0.12 + value * 0.08),
                  border: Border.all(color: AppTheme.primary2.withValues(alpha: 0.26 + value * 0.22)),
                ),
                child: const Icon(Icons.auto_awesome_rounded, size: 34, color: AppTheme.primary2),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text('正在让梦境显影', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const DreamProcessSteps(
            activeIndex: 1,
            framed: false,
            steps: [
              '解析梦里的场景和情绪',
              '扩展光线、质感与构图',
              '下载并保存到梦境记录',
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageResult(String path) {
    return DreamFadeIn(
      child: GlassPanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(path),
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppTheme.glass,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: const Center(child: Text('图片加载失败', style: TextStyle(color: AppTheme.muted))),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const DreamChip(label: '显影完成', icon: Icons.check_rounded, selected: true, accent: AppTheme.success),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '已保存到当前梦境',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 13, color: AppTheme.text.withValues(alpha: 0.68)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorPanel(String message) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      color: Colors.red.withValues(alpha: 0.10),
      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.32)),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.redAccent, fontSize: 14))),
        ],
      ),
    );
  }
}
