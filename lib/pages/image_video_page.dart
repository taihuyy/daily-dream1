import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_video_provider.dart';
import '../theme/app_theme.dart';

class ImageVideoPage extends StatefulWidget {
  const ImageVideoPage({super.key});

  @override
  State<ImageVideoPage> createState() => _ImageVideoPageState();
}

class _ImageVideoPageState extends State<ImageVideoPage> with SingleTickerProviderStateMixin {
  final _promptController = TextEditingController();
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _promptController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _generate() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;
    context.read<ImageVideoProvider>().generateImage(prompt);
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
                    child: Center(child: Text('生成梦境画面', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 20),

              // Dreamy prompt input
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
                    hintText: '描述你想要生成的梦境画面...\n比如：一列旧火车在暴雨夜穿过无人的城市',
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Error display
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

              // Generated image display (local file)
              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  if (provider.localImagePath != null && provider.localImagePath!.isNotEmpty) {
                    return Column(
                      children: [
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (_, child) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(_glowAnimation.value * 0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: child,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(provider.localImagePath!),
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
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Loading indicator with dreamy animation
              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  if (provider.isLoading) {
                    return Column(
                      children: [
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (_, child) => Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.primary.withOpacity(_glowAnimation.value),
                                  AppTheme.primary2.withOpacity(_glowAnimation.value * 0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: child,
                          ),
                          child: const Center(
                            child: Icon(Icons.auto_awesome, size: 32, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '正在生成梦境画面...',
                          style: TextStyle(color: AppTheme.muted, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Generate button
              Consumer<ImageVideoProvider>(
                builder: (_, provider, __) {
                  return SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _generate,
                      child: const Text('生成图像'),
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
}
