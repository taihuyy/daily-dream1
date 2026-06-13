import 'package:flutter/foundation.dart';
import '../services/tongyi_wanxiang_service.dart';

class ImageVideoProvider extends ChangeNotifier {
  final TongyiWanxiangService _service;

  bool _isLoading = false;
  String? _localImagePath;
  String? _error;

  bool get isLoading => _isLoading;
  String? get localImagePath => _localImagePath;
  String? get error => _error;

  ImageVideoProvider(this._service);

  Future<void> generateImage(String prompt, {String? size}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final path = await _service.generateImage(prompt, size: size);
      if (path.isNotEmpty) {
        _localImagePath = path;
      } else {
        _error = '生成图像失败，请检查 API Key 配置';
      }
    } catch (e) {
      _error = '生成图像时出错: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _localImagePath = null;
    _error = null;
    notifyListeners();
  }
}
