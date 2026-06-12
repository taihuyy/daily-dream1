import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatProvider>().sendReply(text);
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<ChatProvider>();

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
                        child: Text('AI 帮你还原梦境', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x0FFFFFFF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('已补全 ${cp.progressPercent}%', style: const TextStyle(fontSize: 14)),
                          Text(
                            cp.progressPercent < 80 ? '再补充 1-2 个细节更完整' : '差不多了！',
                            style: TextStyle(fontSize: 13, color: AppTheme.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: cp.progressPercent / 100,
                          minHeight: 8,
                          backgroundColor: const Color(0x14FFFFFF),
                          valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: cp.messages.length,
                  itemBuilder: (_, i) {
                    final msg = cp.messages[i];
                    final isUser = msg.role == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.84),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isUser
                              ? LinearGradient(
                                  colors: [AppTheme.primary.withOpacity(0.75), AppTheme.primary2.withOpacity(0.45)],
                                ).colors.first
                              : const Color(0x0FFFFFFF),
                          borderRadius: BorderRadius.circular(18),
                          border: isUser ? null : Border.all(color: AppTheme.line),
                        ),
                        child: Text(msg.text, style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
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
                child: Column(
                  children: [
                    TextField(
                      controller: _inputController,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '补充梦境细节...',
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _miniBtn('语音补充', Icons.mic, () {}),
                        const SizedBox(width: 8),
                        _miniBtn('换个问题', Icons.refresh, () => cp.skipQuestion()),
                        const SizedBox(width: 8),
                        _miniBtn('跳过', Icons.skip_next, () => cp.skipQuestion()),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE60A1020)],
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      cp.finalizeChat();
                      Navigator.pushNamed(context, '/result');
                    },
                    child: const Text('生成整理结果'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _miniBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
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
