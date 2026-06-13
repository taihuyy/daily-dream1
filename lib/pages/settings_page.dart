import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  final SettingsService settings;
  const SettingsPage({super.key, required this.settings});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _apiKeyCtrl;
  late final TextEditingController _baseUrlCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _imageModelCtrl;
  late final TextEditingController _promptCtrl;
  late final TextEditingController _mimoBaseUrlCtrl;
  late final TextEditingController _mimoModelCtrl;
  late final TextEditingController _wanxiangKeyCtrl;
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    _apiKeyCtrl = TextEditingController(text: widget.settings.apiKey);
    _baseUrlCtrl = TextEditingController(text: widget.settings.baseUrl);
    _modelCtrl = TextEditingController(text: widget.settings.model);
    _imageModelCtrl = TextEditingController(text: widget.settings.imageModel);
    _promptCtrl = TextEditingController(text: widget.settings.systemPrompt);
    _mimoBaseUrlCtrl = TextEditingController(text: widget.settings.mimoBaseUrl);
    _mimoModelCtrl = TextEditingController(text: widget.settings.mimoModel);
    _wanxiangKeyCtrl = TextEditingController(text: widget.settings.wanxiangApiKey);
  }

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    _baseUrlCtrl.dispose();
    _modelCtrl.dispose();
    _imageModelCtrl.dispose();
    _promptCtrl.dispose();
    _mimoBaseUrlCtrl.dispose();
    _mimoModelCtrl.dispose();
    _wanxiangKeyCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    await widget.settings.setApiKey(_apiKeyCtrl.text.trim());
    await widget.settings.setBaseUrl(_baseUrlCtrl.text.trim());
    await widget.settings.setModel(_modelCtrl.text.trim());
    await widget.settings.setImageModel(_imageModelCtrl.text.trim());
    await widget.settings.setSystemPrompt(_promptCtrl.text.trim());
    await widget.settings.setMiMoBaseUrl(_mimoBaseUrlCtrl.text.trim());
    await widget.settings.setMiMoModel(_mimoModelCtrl.text.trim());
    await widget.settings.setWanxiangApiKey(_wanxiangKeyCtrl.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存'), backgroundColor: AppTheme.success),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF060914), AppTheme.bg, Color(0xFF11193A)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.line),
                        color: const Color(0x0AFFFFFF),
                      ),
                      child: const Icon(Icons.chevron_left, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('AI 设置', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 20),

              _section('API Key', _apiKeyCtrl, obscure: _obscureKey,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscureKey = !_obscureKey),
                  child: Icon(_obscureKey ? Icons.visibility_off : Icons.visibility, size: 20, color: AppTheme.muted),
                ),
                hint: '输入你的 API Key',
              ),
              const SizedBox(height: 14),

              _section('Base URL', _baseUrlCtrl, hint: 'https://api.moonshot.cn/v1'),
              const SizedBox(height: 14),

              _section('对话模型', _modelCtrl, hint: 'kimi-k2.5'),
              const SizedBox(height: 14),

              _section('图片模型', _imageModelCtrl, hint: '留空则不启用图片生成'),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xEE121934),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('MiMo API 配置', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('小米 MiMo 模型配置（可选）', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              _section('MiMo Base URL', _mimoBaseUrlCtrl, hint: 'https://api.mimo.com/v1'),
              const SizedBox(height: 14),

              _section('MiMo 模型', _mimoModelCtrl, hint: 'mimo-7b'),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xEE121934),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('通义万相 API 配置', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('阿里云通义万相，用于图像/视频生成', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              _section('通义万相 API Key', _wanxiangKeyCtrl, hint: '输入通义万相 API Key'),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xEE121934),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('System Prompt', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('AI 助手的系统提示词', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _promptCtrl,
                      maxLines: 8,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '输入系统提示词...',
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xEE121934),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('连接状态', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.settings.isConfigured ? AppTheme.success : AppTheme.warning,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.settings.isConfigured ? '已配置 API Key' : '未配置 API Key（使用离线模式）',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Base URL: ${widget.settings.baseUrl}',
                      style: TextStyle(fontSize: 13, color: AppTheme.muted),
                    ),
                    Text(
                      '模型: ${widget.settings.model}',
                      style: TextStyle(fontSize: 13, color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xE60A1020)],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(onPressed: _save, child: const Text('保存设置')),
        ),
      ),
    );
  }

  static Widget _section(String label, TextEditingController ctrl,
      {bool obscure = false, Widget? suffix, String? hint}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEE121934),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            obscureText: obscure,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              fillColor: Colors.transparent,
              filled: false,
              suffixIcon: suffix,
            ),
          ),
        ],
      ),
    );
  }
}
