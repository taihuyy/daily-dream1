import 'package:hive/hive.dart';

class SettingsService {
  static const _boxName = 'settings';
  static const _keyApiKey = 'api_key';
  static const _keyBaseUrl = 'base_url';
  static const _keyModel = 'model';
  static const _keyImageModel = 'image_model';
  static const _keySystemPrompt = 'system_prompt';
  static const _keyMiMoApiKey = 'mimo_api_key';
  static const _keyMiMoBaseUrl = 'mimo_base_url';
  static const _keyMiMoModel = 'mimo_model';
  static const _keyDashscopeApiKey = 'dashscope_api_key';
  static const _keyDashscopeHost = 'dashscope_host';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    // MiMo defaults (verified working)
    if (_box.get(_keyMiMoApiKey) == null) {
      await _box.put(_keyMiMoApiKey, 'tp-c6a3t7d2ce7ex92jyw2xer8obkp4i2oms7n0jn3sbhmb11yd');
    }
    if (_box.get(_keyMiMoBaseUrl) == null) {
      await _box.put(_keyMiMoBaseUrl, 'https://token-plan-cn.xiaomimimo.com/v1');
    }
    if (_box.get(_keyMiMoModel) == null) {
      await _box.put(_keyMiMoModel, 'mimo-v2.5');
    }
    if (_box.get(_keySystemPrompt) == null) {
      await _box.put(_keySystemPrompt, _defaultPrompt);
    }
    // DashScope defaults (verified working)
    if (_box.get(_keyDashscopeApiKey) == null) {
      await _box.put(_keyDashscopeApiKey, 'sk-ws-H.IRREIM.o7EL.MEUCIDUSIjlmET2w_QkXBWQYAlxyrFkqkTWRkRYmFWImYWMPAiEApwLdMEGA_ycV1l9ri_KcbWyA2Ee3ST4sr9lhS-EGmqs');
    }
    if (_box.get(_keyDashscopeHost) == null) {
      await _box.put(_keyDashscopeHost, 'https://dashscope-intl.aliyuncs.com');
    }
    if (_box.get(_keyImageModel) == null) {
      await _box.put(_keyImageModel, 'qwen-image-2.0-pro');
    }
  }

  // MiMo config
  String get mimoApiKey => _box.get(_keyMiMoApiKey, defaultValue: '');
  String get mimoBaseUrl => _box.get(_keyMiMoBaseUrl, defaultValue: 'https://token-plan-cn.xiaomimimo.com/v1');
  String get mimoModel => _box.get(_keyMiMoModel, defaultValue: 'mimo-v2.5');
  String get systemPrompt => _box.get(_keySystemPrompt, defaultValue: _defaultPrompt);

  // DashScope config
  String get dashscopeApiKey => _box.get(_keyDashscopeApiKey, defaultValue: '');
  String get dashscopeHost => _box.get(_keyDashscopeHost, defaultValue: 'https://dashscope-intl.aliyuncs.com');
  String get imageModel => _box.get(_keyImageModel, defaultValue: 'qwen-image-2.0-pro');

  // Legacy aliases
  String get apiKey => mimoApiKey;
  String get baseUrl => mimoBaseUrl;
  String get model => mimoModel;
  String get wanxiangApiKey => dashscopeApiKey;

  bool get isConfigured => mimoApiKey.isNotEmpty;

  Future<void> setMiMoApiKey(String v) => _box.put(_keyMiMoApiKey, v);
  Future<void> setMiMoBaseUrl(String v) => _box.put(_keyMiMoBaseUrl, v);
  Future<void> setMiMoModel(String v) => _box.put(_keyMiMoModel, v);
  Future<void> setSystemPrompt(String v) => _box.put(_keySystemPrompt, v);
  Future<void> setDashscopeApiKey(String v) => _box.put(_keyDashscopeApiKey, v);
  Future<void> setDashscopeHost(String v) => _box.put(_keyDashscopeHost, v);
  Future<void> setImageModel(String v) => _box.put(_keyImageModel, v);

  // Legacy setters
  Future<void> setApiKey(String v) => setMiMoApiKey(v);
  Future<void> setBaseUrl(String v) => setMiMoBaseUrl(v);
  Future<void> setModel(String v) => setMiMoModel(v);
  Future<void> setWanxiangApiKey(String v) => setDashscopeApiKey(v);

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
