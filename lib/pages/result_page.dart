import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isProcessing = true;
  String _title = '';
  String _fullText = '';
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  void _loadResult() async {
    final cp = context.read<ChatProvider>();
    final dp = context.read<DreamProvider>();
    final dream = dp.latestDream;

    if (dream != null && dream.fullText.isNotEmpty && dream.title.isNotEmpty) {
      setState(() {
        _title = dream.title;
        _fullText = dream.fullText;
        _tags = dream.tags;
        _isProcessing = false;
      });
    } else {
      final result = await cp.finalizeAndSummarize();
      if (mounted) {
        setState(() {
          _title = result['title'] ?? '一场值得记住的梦';
          _fullText = result['fullText'] ?? dream?.rawText ?? '';
          _tags = List<String>.from(result['tags'] ?? ['梦境']);
          _isProcessing = false;
        });
        if (dream != null) {
          dream.title = _title;
          dream.fullText = _fullText;
          dream.tags = _tags;
          dp.updateDream(dream);
        }
      }
    }
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
          child: _isProcessing ? _loadingView() : _resultView(),
        ),
      ),
    );
  }

  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60, height: 60,
            child: CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 3),
          ),
          const SizedBox(height: 20),
          Text('AI 正在整理你的梦境...', style: TextStyle(fontSize: 16, color: AppTheme.muted)),
          const SizedBox(height: 8),
          Text('把碎片拼成完整的画面', style: TextStyle(fontSize: 14, color: AppTheme.muted)),
        ],
      ),
    );
  }

  Widget _resultView() {
    return ListView(
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
                child: Text('整理结果', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 36),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.success, AppTheme.primary2]),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text('整理完成', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF08101C))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('这场差点消失的梦，已经被留下来了', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _card(
          Text(_title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 14),

        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('完整梦境文本', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text(_fullText, style: TextStyle(fontSize: 14, height: 1.8, color: AppTheme.muted)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('梦境标签', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _tags.map((tag) =>
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
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/image-video'),
                  child: const Text('生成图像/视频'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.text,
                    side: const BorderSide(color: AppTheme.line),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('调整描述'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.text,
                    side: const BorderSide(color: AppTheme.line),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('保存'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/publish'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.text,
                    side: const BorderSide(color: AppTheme.line),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('公开分享'),
                ),
              ),
            ),
          ],
        ),
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
