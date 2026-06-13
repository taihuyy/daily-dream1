import 'dart:convert';
import 'package:http/http.dart' as http;
import 'settings_service.dart';

class AiMessage {
  final String role;
  final String content;
  AiMessage({required this.role, required this.content});

  Map<String, dynamic> toMap() => {'role': role, 'content': content};
}

class AiService {
  final SettingsService _settings;

  AiService(this._settings);

  String get _chatUrl => '${_settings.mimoBaseUrl}/chat/completions';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_settings.mimoApiKey}',
      };

  Future<String> chat(List<AiMessage> messages) async {
    if (!_settings.isConfigured) {
      return _fallbackReply(messages);
    }

    try {
      final systemMsg = AiMessage(role: 'system', content: _settings.systemPrompt);
      final allMessages = [systemMsg, ...messages].map((m) => m.toMap()).toList();

      final resp = await http.post(
        Uri.parse(_chatUrl),
        headers: _headers,
        body: jsonEncode({
          'model': _settings.mimoModel,
          'messages': allMessages,
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['choices'][0]['message']['content'] ?? '抱歉，我暂时无法回复。';
      } else {
        return 'API 错误 (${resp.statusCode})';
      }
    } catch (e) {
      return '网络错误: $e';
    }
  }

  Future<String> summarizeDream(String fullConversation) async {
    if (!_settings.isConfigured) {
      return _fallbackSummarize(fullConversation);
    }

    try {
      // Use user message for prompt (verified with mini-dream)
      final prompt = '''请将以下梦境描述改写成优美的散文，用"我"第一人称，加入感官细节和比喻，不要重复原文。

梦境内容：$fullConversation

请直接返回JSON：{"title":"标题","fullText":"改写后的散文","tags":["标签"],"summary":"一句话"}''';

      final resp = await http.post(
        Uri.parse(_chatUrl),
        headers: _headers,
        body: jsonEncode({
          'model': _settings.mimoModel,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.8,
          'max_tokens': 1500,
        }),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['choices'][0]['message']['content'] ?? '{}';
      }
    } catch (_) {}
    return _fallbackSummarize(fullConversation);
  }

  String _fallbackReply(List<AiMessage> messages) {
    final lastUserMsg = messages.where((m) => m.role == 'user').lastOrNull;
    if (lastUserMsg == null) return '请先描述你的梦境。';

    final text = lastUserMsg.content.toLowerCase();
    if (text.contains('火车') || text.contains('列车')) {
      return '梦里的火车让你想到什么？是旅途、等待，还是被困住的感觉？';
    }
    if (text.contains('水') || text.contains('海') || text.contains('雨')) {
      return '水在梦里往往代表情绪。你当时是平静的，还是不安的？';
    }
    if (text.contains('飞') || text.contains('天空')) {
      return '飞翔的梦通常和自由或压力有关。你在梦里是享受还是害怕？';
    }
    return '这个画面很有意思。当时你最强烈的感受是什么？试着回忆一下身体的感觉。';
  }

  String _fallbackSummarize(String text) {
    return jsonEncode({
      'title': '一场值得记住的梦',
      'fullText': text,
      'tags': ['梦境', '回忆'],
      'summary': '这是一段值得珍藏的梦境记忆。'
    });
  }
}
