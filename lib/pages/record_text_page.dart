import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../providers/chat_provider.dart';
import '../services/sensory_service.dart';
import '../widgets/dream_animations.dart';
import '../theme/app_theme.dart';

class RecordTextPage extends StatefulWidget {
  const RecordTextPage({super.key});

  @override
  State<RecordTextPage> createState() => _RecordTextPageState();
}

class _RecordTextPageState extends State<RecordTextPage> {
  final _controller = TextEditingController();
  final Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text.trim();

    return Scaffold(
      body: DreamBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              const DreamTopBar(title: '文字记录'),
              const SizedBox(height: 20),
              DreamFadeIn(child: _guideCard()),
              const SizedBox(height: 16),
              DreamFadeIn(
                delay: const Duration(milliseconds: 120),
                child: _dreamPaper(text),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: text.isEmpty ? null : () {
                    SensoryService.success();
                    final dp = context.read<DreamProvider>();
                    final cp = context.read<ChatProvider>();
                    dp.createNewDream(rawText: text);
                    cp.startChat(text);
                    Navigator.pushNamed(context, '/ai-chat');
                  },
                  icon: const Icon(Icons.auto_awesome_rounded, size: 19),
                  label: const Text('交给 AI 整理'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _guideCard() {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.moon.withValues(alpha: 0.13),
          AppTheme.rose.withValues(alpha: 0.08),
          AppTheme.panel,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('先写下还在发光的部分', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            '不需要完整。一个地点、一个人、一种奇怪的情绪，都可以成为还原梦的入口。',
            style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.text.withValues(alpha: 0.76)),
          ),
        ],
      ),
    );
  }

  Widget _dreamPaper(String text) {
    final hasText = text.isNotEmpty;

    return GlassPanel(
      padding: const EdgeInsets.all(16),
      color: hasText ? AppTheme.panelStrong : AppTheme.panel,
      border: Border.all(
        color: hasText ? AppTheme.moon.withValues(alpha: 0.34) : AppTheme.line,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notes_rounded, size: 18, color: AppTheme.moon),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('梦境碎片', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              Text('${text.length} 字', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            maxLines: 9,
            minLines: 7,
            style: const TextStyle(fontSize: 15, height: 1.68),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '写下你记得的梦...\n\n比如：醒来前我在一座很亮的车站，广播里一直叫我的名字，但没有人回头。',
              fillColor: Colors.transparent,
              filled: false,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tag('人物', Icons.person_outline_rounded, AppTheme.moon),
              _tag('地点', Icons.place_outlined, AppTheme.primary2),
              _tag('情绪', Icons.water_drop_outlined, AppTheme.rose),
              _tag('画面', Icons.panorama_outlined, AppTheme.mint),
              _tag('声音', Icons.graphic_eq_rounded, AppTheme.primary),
              _tag('结尾', Icons.flag_outlined, AppTheme.warning),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              SensoryService.softTap();
              Navigator.pushReplacementNamed(context, '/record-voice');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.text,
              side: const BorderSide(color: AppTheme.line),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.mic_rounded, size: 18),
            label: const Text('切换语音输入'),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, IconData icon, Color accent) {
    final selected = _selectedTags.contains(label);
    return DreamChip(
      label: label,
      icon: icon,
      selected: selected,
      accent: accent,
      onTap: () {
        SensoryService.softTap();
        setState(() {
          selected ? _selectedTags.remove(label) : _selectedTags.add(label);
        });
      },
    );
  }
}
