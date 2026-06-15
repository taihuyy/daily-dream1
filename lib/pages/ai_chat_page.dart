import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';
import '../providers/dream_provider.dart';
import '../services/sensory_service.dart';
import '../widgets/dream_animations.dart';
import '../theme/app_theme.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _inputController = TextEditingController();
  final _scrollCtrl = ScrollController();
  ChatProvider? _chatProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<ChatProvider>();
    if (_chatProvider != provider) {
      _chatProvider?.removeListener(_onChatUpdate);
      _chatProvider = provider;
      _chatProvider?.addListener(_onChatUpdate);
    }
  }

  void _onChatUpdate() {
    final cp = _chatProvider;
    if (cp != null && cp.messages.isNotEmpty) _scrollToBottom();
  }

  @override
  void dispose() {
    _chatProvider?.removeListener(_onChatUpdate);
    _inputController.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    SensoryService.softTap();
    context.read<ChatProvider>().sendReply(text);
    _inputController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<ChatProvider>();

    return Scaffold(
      body: DreamBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: const DreamTopBar(title: 'AI 帮你还原梦境'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: _progressPanel(cp),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                  itemCount: cp.messages.length + (cp.isAiReplying ? 1 : 0),
                  itemBuilder: (_, index) {
                    if (index == cp.messages.length) return _thinkingBubble();
                    return _messageBubble(cp.messages[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: _inputPanel(cp),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: cp.messages.isEmpty || cp.isGenerating ? null : () async {
                      SensoryService.action();
                      final dp = context.read<DreamProvider>();
                      final dream = dp.latestDream;
                      if (dream == null) return;

                      final result = await cp.finalizeAndSummarize();
                      dream.title = result['title'] ?? dream.title;
                      dream.fullText = result['fullText'] ?? dream.fullText;
                      dream.tags = List<String>.from(result['tags'] ?? dream.tags);
                      dp.updateDream(dream);

                      SensoryService.success();
                      if (mounted) Navigator.pushNamed(context, '/result');
                    },
                    icon: Icon(cp.isGenerating ? Icons.hourglass_top_rounded : Icons.auto_awesome_rounded, size: 19),
                    label: Text(cp.isGenerating ? '正在整理梦境' : '生成整理结果'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressPanel(ChatProvider cp) {
    final stage = cp.progressPercent < 35
        ? '正在寻找梦的入口'
        : cp.progressPercent < 70
            ? '正在补全场景和情绪'
            : cp.progressPercent < 100
                ? '快可以整理成篇了'
                : '准备显影成完整梦境';

    return GlassPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 18, color: AppTheme.moon),
              const SizedBox(width: 8),
              Expanded(child: Text(stage, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
              Text('${cp.progressPercent}%', style: const TextStyle(fontSize: 13, color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: cp.progressPercent / 100,
              minHeight: 7,
              backgroundColor: AppTheme.glass,
              valueColor: const AlwaysStoppedAnimation(AppTheme.moon),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(ChatMessage msg) {
    final isUser = msg.role == 'user';
    final accent = isUser ? AppTheme.moon : AppTheme.primary2;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? accent.withValues(alpha: 0.18) : AppTheme.panel,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 6),
            bottomRight: Radius.circular(isUser ? 6 : 18),
          ),
          border: Border.all(color: isUser ? accent.withValues(alpha: 0.34) : AppTheme.line),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: 14,
            height: 1.65,
            color: isUser ? AppTheme.text : AppTheme.text.withValues(alpha: 0.88),
          ),
        ),
      ),
    );
  }

  Widget _thinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primary2,
                backgroundColor: AppTheme.glass,
              ),
            ),
            const SizedBox(width: 10),
            const Text('AI 正在听梦...', style: TextStyle(color: AppTheme.muted, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _inputPanel(ChatProvider cp) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      color: AppTheme.panelStrong,
      child: Column(
        children: [
          TextField(
            controller: _inputController,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '补充一个画面、人物或感受...',
              fillColor: Colors.transparent,
              filled: false,
              suffixIcon: IconButton(
                icon: const Icon(Icons.send_rounded, size: 20, color: AppTheme.moon),
                onPressed: _send,
              ),
            ),
            onSubmitted: (_) => _send(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _miniBtn('换个问题', Icons.refresh_rounded, () {
                SensoryService.softTap();
                cp.skipQuestion();
              }),
              const SizedBox(width: 8),
              _miniBtn('先跳过', Icons.skip_next_rounded, () {
                SensoryService.softTap();
                cp.skipQuestion();
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: AppTheme.glass,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppTheme.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTheme.muted),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}
