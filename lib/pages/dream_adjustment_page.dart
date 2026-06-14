import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class DreamAdjustmentPage extends StatefulWidget {
  final String initialDreamText;

  const DreamAdjustmentPage({super.key, required this.initialDreamText});

  @override
  State<DreamAdjustmentPage> createState() => _DreamAdjustmentPageState();
}

class _DreamAdjustmentPageState extends State<DreamAdjustmentPage> {
  final _messageController = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cp = context.read<ChatProvider>();
      cp.startChat(widget.initialDreamText);
      cp.addListener(_onChatUpdate);
    });
  }

  void _onChatUpdate() {
    final cp = context.read<ChatProvider>();
    if (cp.messages.isNotEmpty) _scrollToBottom();
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatProvider>().sendReply(text);
    _messageController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<ChatProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF060914), AppTheme.bg, Color(0xFF11193A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Row(
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
                        child: Text('调整梦境描述', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final lastAiMsg = cp.messages
                            .where((m) => m.role == 'ai')
                            .lastOrNull;
                        Navigator.pop(context, lastAiMsg?.text ?? widget.initialDreamText);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
                        ),
                        child: const Text('确认', style: TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(18),
                  itemCount: cp.messages.length + (cp.isAiReplying ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == cp.messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0x0FFFFFFF),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.line),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary)),
                              const SizedBox(width: 10),
                              Text('AI 思考中...', style: TextStyle(color: AppTheme.muted, fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    }
                    final msg = cp.messages[i];
                    final isUser = msg.role == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.84),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isUser ? AppTheme.primary.withOpacity(0.75) : const Color(0x0FFFFFFF),
                          borderRadius: BorderRadius.circular(18),
                          border: isUser ? null : Border.all(color: AppTheme.line),
                        ),
                        child: Text(msg.text, style: TextStyle(
                          fontSize: 14, height: 1.6,
                          color: isUser ? Colors.white : AppTheme.text,
                        )),
                      ),
                    );
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.panelStrong,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.line),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '补充细节或调整描述...',
                    fillColor: Colors.transparent,
                    filled: false,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, size: 20, color: AppTheme.primary),
                      onPressed: _send,
                    ),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
