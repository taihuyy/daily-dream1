import 'package:flutter/foundation.dart';
import '../services/tongyi_wanxiang_service.dart';
import '../services/settings_service.dart';

class ImageVideoProvider extends ChangeNotifier {
  final SettingsService _settings;

  bool _isLoading = false;
  String? _localImagePath;
  String? _error;

  bool get isLoading => _isLoading;
  String? get localImagePath => _localImagePath;
  String? get error => _error;

  ImageVideoProvider(this._settings);

  /// Create a fresh service each time to pick up config changes
  TongyiWanxiangService get _service => TongyiWanxiangService(
        apiKey: _settings.dashscopeApiKey,
        host: _settings.dashscopeHost,
        model: _settings.imageModel,
      );

  Future<void> generateImage(String prompt, {String? size}) async {
    _isLoading = true;
    _error = null;
    _localImagePath = null;
    notifyListeners();

    try {
      final path = await _service.generateImage(prompt, size: size);
      if (path.isNotEmpty) {
        _localImagePath = path;
      } else {
        _error = '生成图像失败，请检查 DashScope API Key 配置';
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
