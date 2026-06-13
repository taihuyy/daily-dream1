import 'package:flutter/foundation.dart';
import '../services/tongyi_wanxiang_service.dart';

class ImageVideoProvider extends ChangeNotifier {
  final TongyiWanxiangService _service;

  bool _isLoading = false;
  String? _currentTaskId;
  String? _error;
  String? _resultUrl;

  bool get isLoading => _isLoading;
  String? get currentTaskId => _currentTaskId;
  String? get error => _error;
  String? get resultUrl => _resultUrl;

  ImageVideoProvider(this._service);

  Future<String?> generateImage(String prompt, {String? style, String? size}) async {
    _isLoading = true;
    _error = null;
    _resultUrl = null;
    notifyListeners();

    try {
      _currentTaskId = await _service.generateImage(prompt, style: style, size: size);
      if (_currentTaskId == null || _currentTaskId!.isEmpty) {
        _error = '生成图像失败，请检查 API Key 是否配置正确';
      }
    } catch (e) {
      _error = '生成图像时出错: $e';
    }

    _isLoading = false;
    notifyListeners();
    return _currentTaskId;
  }

  Future<String?> generateVideo(String prompt, {int duration = 4}) async {
    _isLoading = true;
    _error = null;
    _resultUrl = null;
    notifyListeners();

    try {
      _currentTaskId = await _service.generateVideo(prompt, duration: duration);
      if (_currentTaskId == null || _currentTaskId!.isEmpty) {
        _error = '生成视频失败，请检查 API Key 是否配置正确';
      }
    } catch (e) {
      _error = '生成视频时出错: $e';
    }

    _isLoading = false;
    notifyListeners();
    return _currentTaskId;
  }

  Future<Map<String, dynamic>?> pollTaskResult() async {
    if (_currentTaskId == null) return null;

    try {
      final result = await _service.getTaskResult(_currentTaskId!);
      final status = result['output']?['task_status'];

      if (status == 'SUCCEEDED') {
        final results = result['output']?['results'];
        if (results != null && results.isNotEmpty) {
          _resultUrl = results[0];
        }
      } else if (status == 'FAILED') {
        _error = '生成失败: ${result['output']?['message'] ?? "未知错误"}';
      }

      notifyListeners();
      return result;
    } catch (e) {
      _error = '获取结果时出错: $e';
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _currentTaskId = null;
    _error = null;
    _resultUrl = null;
    notifyListeners();
  }
}
