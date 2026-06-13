import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TongyiWanxiangService {
  final String apiKey;
  final String host;
  final String model;

  TongyiWanxiangService({
    required this.apiKey,
    this.host = 'https://dashscope-intl.aliyuncs.com',
    this.model = 'qwen-image-2.0-pro',
  });

  /// Generate image synchronously using qwen-image-2.0-pro
  /// Returns local file path on success, empty string on failure
  Future<String> generateImage(String prompt, {String? size}) async {
    if (apiKey.isEmpty) return '';

    try {
      final resp = await http.post(
        Uri.parse('$host/api/v1/services/aigc/multimodal-generation/generation'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'input': {
            'messages': [
              {
                'role': 'user',
                'content': [
                  {'text': prompt}
                ]
              }
            ]
          },
          'parameters': {
            'result_format': 'message',
            'watermark': false,
            'prompt_extend': true,
            'size': size ?? '1024*1024',
          },
        }),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final imageUrl = data['output']?['choices']?[0]?['message']?['content']?[0]?['image'];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return await _downloadAndSave(imageUrl);
        }
      }
    } catch (_) {}
    return '';
  }

  /// Download image from URL and save to local app directory
  Future<String> _downloadAndSave(String imageUrl) async {
    try {
      final resp = await http.get(Uri.parse(imageUrl));
      if (resp.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final dreamDir = Directory('${dir.path}/dream_images');
        if (!await dreamDir.exists()) {
          await dreamDir.create(recursive: true);
        }
        final fileName = 'dream_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${dreamDir.path}/$fileName');
        await file.writeAsBytes(resp.bodyBytes);
        return file.path;
      }
    } catch (_) {}
    return '';
  }
}
