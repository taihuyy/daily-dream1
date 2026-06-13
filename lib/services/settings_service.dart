import 'package:hive/hive.dart';

class SettingsService {
  static const _boxName = 'settings';
  static const _keyApiKey = 'api_key';
  static const _keyBaseUrl = 'base_url';
  static const _keyModel = 'model';
  static const _keyImageModel = 'image_model';
  static const _keySystemPrompt = 'system_prompt';
  static const _keyMiMoBaseUrl = 'mimo_base_url';
  static const _keyMiMoModel = 'mimo_model';
  static const _keyWanxiangApiKey = 'wanxiang_api_key';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    if (_box.get(_keyBaseUrl) == null) {
      await _box.put(_keyBaseUrl, 'https://api.moonshot.cn/v1');
    }
    if (_box.get(_keyModel) == null) {
      await _box.put(_keyModel, 'kimi-k2.5');
    }
    if (_box.get(_keySystemPrompt) == null) {
      await _box.put(_keySystemPrompt, _defaultPrompt);
    }
    if (_box.get(_keyMiMoBaseUrl) == null) {
      await _box.put(_keyMiMoBaseUrl, 'https://api.mimo.com/v1');
    }
    if (_box.get(_keyMiMoModel) == null) {
      await _box.put(_keyMiMoModel, 'mimo-7b');
    }
  }

  String get apiKey => _box.get(_keyApiKey, defaultValue: '');
  String get baseUrl => _box.get(_keyBaseUrl, defaultValue: 'https://api.moonshot.cn/v1');
  String get model => _box.get(_keyModel, defaultValue: 'kimi-k2.5');
  String get imageModel => _box.get(_keyImageModel, defaultValue: '');
  String get systemPrompt => _box.get(_keySystemPrompt, defaultValue: _defaultPrompt);
  String get mimoBaseUrl => _box.get(_keyMiMoBaseUrl, defaultValue: 'https://api.mimo.com/v1');
  String get mimoModel => _box.get(_keyMiMoModel, defaultValue: 'mimo-7b');
  String get wanxiangApiKey => _box.get(_keyWanxiangApiKey, defaultValue: '');

  bool get isConfigured => apiKey.isNotEmpty;

  Future<void> setApiKey(String v) => _box.put(_keyApiKey, v);
  Future<void> setBaseUrl(String v) => _box.put(_keyBaseUrl, v);
  Future<void> setModel(String v) => _box.put(_keyModel, v);
  Future<void> setImageModel(String v) => _box.put(_keyImageModel, v);
  Future<void> setSystemPrompt(String v) => _box.put(_keySystemPrompt, v);
  Future<void> setMiMoBaseUrl(String v) => _box.put(_keyMiMoBaseUrl, v);
  Future<void> setMiMoModel(String v) => _box.put(_keyMiMoModel, v);
  Future<void> setWanxiangApiKey(String v) => _box.put(_keyWanxiangApiKey, v);

  static const _defaultPrompt = '''你是一个梦境记录助手。用户会告诉你他们做的梦，你的任务是：
1. 通过追问帮助用户回忆更多细节（人物、地点、情绪、画面）
2. 根据用户的碎片描述，补全并整理成一段完整的梦境文本
3. 为梦境提取关键标签
4. 用诗意但真实的方式描述梦境氛围

回复要求：
- 追问时一次只问一个问题，不要一次问太多
- 用温和、好奇的语气
- 整理结果时保留用户的原始感受
- 标签用简短的关键词''';
}
