import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../data/mock_data.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  int _progressPercent = 0;
  bool _isGenerating = false;

  List<ChatMessage> get messages => _messages;
  int get progressPercent => _progressPercent;
  bool get isGenerating => _isGenerating;

  void startChat(String initialDream) {
    _messages = [];
    _progressPercent = 15;

    _messages.add(ChatMessage(
      id: '1',
      role: 'user',
      text: initialDream,
    ));

    _messages.add(ChatMessage(
      id: '2',
      role: 'ai',
      text: '梦里还有谁和你在一起？他们给你的感觉是熟悉、陌生，还是有点压迫？',
    ));

    notifyListeners();
  }

  void sendReply(String text) {
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      text: text,
    ));

    _progressPercent = (_progressPercent + 18).clamp(0, 85);
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 800), () {
      final reply = MockData.getNextAiReply(_messages.length);
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'ai',
        text: reply,
      ));
      _progressPercent = (_progressPercent + 5).clamp(0, 95);
      notifyListeners();
    });
  }

  void skipQuestion() {
    final reply = MockData.getNextAiReply(_messages.length);
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'ai',
      text: reply,
    ));
    _progressPercent = (_progressPercent + 12).clamp(0, 95);
    notifyListeners();
  }

  void finalizeChat() {
    _progressPercent = 100;
    _isGenerating = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1500), () {
      _isGenerating = false;
      notifyListeners();
    });
  }

  void reset() {
    _messages = [];
    _progressPercent = 0;
    _isGenerating = false;
    notifyListeners();
  }
}
