import 'dart:convert';
import 'package:http/http.dart' as http;

class TongyiWanxiangService {
  final String apiKey;
  final String baseUrl;

  TongyiWanxiangService({
    required this.apiKey,
    this.baseUrl = 'https://dashscope.aliyuncs.com/api/v1',
  });

  Future<String> generateImage(String prompt, {String? style, String? size}) async {
    if (apiKey.isEmpty) return '';
    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/services/aigc/text2image/image-synthesis'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'X-DashScope-Async': 'enable',
        },
        body: jsonEncode({
          'model': 'wanx-v1',
          'input': {'prompt': prompt},
          'parameters': {
            'style': style ?? '<auto>',
            'size': size ?? '1024*1024',
          },
        }),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['output']?['task_id'] ?? '';
      }
    } catch (_) {}
    return '';
  }

  Future<String> generateVideo(String prompt, {int duration = 4}) async {
    if (apiKey.isEmpty) return '';
    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/services/aigc/video-generation/generation'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'X-DashScope-Async': 'enable',
        },
        body: jsonEncode({
          'model': 'wanx-video-v1',
          'input': {'prompt': prompt},
          'parameters': {
            'duration': duration,
          },
        }),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['output']?['task_id'] ?? '';
      }
    } catch (_) {}
    return '';
  }

  Future<Map<String, dynamic>> getTaskResult(String taskId) async {
    if (apiKey.isEmpty || taskId.isEmpty) return {};
    try {
      final resp = await http.get(
        Uri.parse('$baseUrl/tasks/$taskId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (resp.statusCode == 200) {
        return jsonDecode(resp.body);
      }
    } catch (_) {}
    return {};
  }
}
