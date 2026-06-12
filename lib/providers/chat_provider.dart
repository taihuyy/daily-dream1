import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/settings_service.dart';

class ChatProvider extends ChangeNotifier {
  final AiService _ai;
  final SettingsService _settings;
  List<ChatMessage> _messages = [];
  int _progressPercent = 0;
  bool _isGenerating = false;
  bool _isAiReplying = false;

  ChatProvider(this._settings) : _ai = AiService(_settings);

  List<ChatMessage> get messages => _messages;
  int get progressPercent => _progressPercent;
  bool get isGenerating => _isGenerating;
  bool get isAiReplying => _isAiReplying;

  void startChat(String initialDream) {
    _messages = [];
    _progressPercent = 10;

    _messages.add(ChatMessage(
      id: const Uuid().v4(),
      role: 'user',
      text: initialDream,
    ));

    _isAiReplying = true;
    notifyListeners();

    _ai.chat([AiMessage(role: 'user', content: initialDream)]).then((reply) {
      _messages.add(ChatMessage(
        id: const Uuid().v4(),
        role: 'ai',
        text: reply,
      ));
      _progressPercent = 25;
      _isAiReplying = false;
      notifyListeners();
    });
  }

  void sendReply(String text) async {
    _messages.add(ChatMessage(
      id: const Uuid().v4(),
      role: 'user',
      text: text,
    ));
    _isAiReplying = true;
    notifyListeners();

    final aiMessages = _messages.map((m) => AiMessage(role: m.role == 'user' ? 'user' : 'assistant', content: m.text)).toList();
    final reply = await _ai.chat(aiMessages);

    _messages.add(ChatMessage(
      id: const Uuid().v4(),
      role: 'ai',
      text: reply,
    ));

    _progressPercent = (_progressPercent + 18).clamp(0, 85);
    _isAiReplying = false;
    notifyListeners();
  }

  void skipQuestion() async {
    _isAiReplying = true;
    notifyListeners();

    final aiMessages = _messages.map((m) => AiMessage(role: m.role == 'user' ? 'user' : 'assistant', content: m.text)).toList();
    aiMessages.add(AiMessage(role: 'user', content: '跳过这个问题，换一个角度问我吧'));
    final reply = await _ai.chat(aiMessages);

    _messages.add(ChatMessage(
      id: const Uuid().v4(),
      role: 'ai',
      text: reply,
    ));

    _progressPercent = (_progressPercent + 12).clamp(0, 95);
    _isAiReplying = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> finalizeAndSummarize() async {
    _progressPercent = 100;
    _isGenerating = true;
    notifyListeners();

    final conversation = _messages
        .where((m) => m.role == 'user')
        .map((m) => m.text)
        .join('\n');

    final result = await _ai.summarizeDream(conversation);

    _isGenerating = false;
    notifyListeners();

    try {
      final parsed = _parseJson(result);
      return parsed;
    } catch (_) {
      return {
        'title': '一场值得记住的梦',
        'fullText': conversation,
        'tags': ['梦境'],
        'summary': conversation.substring(0, (conversation.length).clamp(0, 50)),
      };
    }
  }

  Map<String, dynamic> _parseJson(String text) {
    text = text.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```\w*\n?'), '').replaceFirst(RegExp(r'\n?```$'), '');
    }
    return Map<String, dynamic>.from(
      (const JsonDecoder().convert(text) as Map).map((k, v) => MapEntry(k.toString(), v)),
    );
  }

  void reset() {
    _messages = [];
    _progressPercent = 0;
    _isGenerating = false;
    _isAiReplying = false;
    notifyListeners();
  }
}
