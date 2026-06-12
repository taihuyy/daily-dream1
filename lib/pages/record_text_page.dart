import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class RecordTextPage extends StatefulWidget {
  const RecordTextPage({super.key});

  @override
  State<RecordTextPage> createState() => _RecordTextPageState();
}

class _RecordTextPageState extends State<RecordTextPage> {
  final _controller = TextEditingController(
    text: '我梦到自己在一列很旧的火车上，车厢里坐着小时候的同学，但大家都不说话。窗外一直在下暴雨，车好像永远也到不了站。',
  );
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                      child: Text('文字记录', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 20),
              _infoCard(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.panelStrong,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      maxLines: 8,
                      style: const TextStyle(fontSize: 15, height: 1.6),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '写下你记得的梦...',
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: ['人物', '地点', '情绪', '结尾'].map((tag) {
                        final selected = _selectedTags.contains(tag);
                        return GestureDetector(
                          onTap: () => setState(() {
                            selected ? _selectedTags.remove(tag) : _selectedTags.add(tag);
                          }),
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
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/record-voice'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.line, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.transparent,
                        ),
                        child: Text(
                          '切换语音输入',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.muted, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final dp = context.read<DreamProvider>();
                    final cp = context.read<ChatProvider>();
                    final dream = dp.createNewDream(rawText: _controller.text);
                    cp.startChat(_controller.text);
                    Navigator.pushNamed(context, '/ai-chat');
                  },
                  child: const Text('交给 AI 整理'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEE121934),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('先写下你还记得的部分', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('不用一次写完整，先把最模糊但最重要的片段留下来。',
              style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted)),
        ],
      ),
    );
  }
}
