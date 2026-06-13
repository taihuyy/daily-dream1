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
  late final TextEditingController _mimoKeyCtrl;
  late final TextEditingController _mimoBaseUrlCtrl;
  late final TextEditingController _mimoModelCtrl;
  late final TextEditingController _dsKeyCtrl;
  late final TextEditingController _dsHostCtrl;
  late final TextEditingController _imageModelCtrl;
  late final TextEditingController _promptCtrl;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _mimoKeyCtrl = TextEditingController(text: widget.settings.mimoApiKey);
    _mimoBaseUrlCtrl = TextEditingController(text: widget.settings.mimoBaseUrl);
    _mimoModelCtrl = TextEditingController(text: widget.settings.mimoModel);
    _dsKeyCtrl = TextEditingController(text: widget.settings.dashscopeApiKey);
    _dsHostCtrl = TextEditingController(text: widget.settings.dashscopeHost);
    _imageModelCtrl = TextEditingController(text: widget.settings.imageModel);
    _promptCtrl = TextEditingController(text: widget.settings.systemPrompt);
  }

  @override
  void dispose() {
    _mimoKeyCtrl.dispose();
    _mimoBaseUrlCtrl.dispose();
    _mimoModelCtrl.dispose();
    _dsKeyCtrl.dispose();
    _dsHostCtrl.dispose();
    _imageModelCtrl.dispose();
    _promptCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    await widget.settings.setMiMoApiKey(_mimoKeyCtrl.text.trim());
    await widget.settings.setMiMoBaseUrl(_mimoBaseUrlCtrl.text.trim());
    await widget.settings.setMiMoModel(_mimoModelCtrl.text.trim());
    await widget.settings.setDashscopeApiKey(_dsKeyCtrl.text.trim());
    await widget.settings.setDashscopeHost(_dsHostCtrl.text.trim());
    await widget.settings.setImageModel(_imageModelCtrl.text.trim());
    await widget.settings.setSystemPrompt(_promptCtrl.text.trim());
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
            begin: Alignment.topLeft, end: Alignment.bottomRight,
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
                    child: Center(child: Text('AI 设置', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 20),

              _sectionHeader('MiMo AI 对话', '用于梦境追问和润色'),
              const SizedBox(height: 14),
              _section('MiMo API Key', _mimoKeyCtrl, obscure: _obscure,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20, color: AppTheme.muted),
                ),
              ),
              const SizedBox(height: 14),
              _section('MiMo Base URL', _mimoBaseUrlCtrl),
              const SizedBox(height: 14),
              _section('MiMo 模型', _mimoModelCtrl),
              const SizedBox(height: 20),

              _sectionHeader('通义万相图像生成', '用于生成梦境画面'),
              const SizedBox(height: 14),
              _section('DashScope API Key', _dsKeyCtrl, obscure: _obscure),
              const SizedBox(height: 14),
              _section('DashScope Host', _dsHostCtrl),
              const SizedBox(height: 14),
              _section('图像模型', _imageModelCtrl),
              const SizedBox(height: 20),

              _sectionHeader('System Prompt', 'AI 助手的系统提示词'),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xEE121934),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.line),
                ),
                child: TextField(
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
                          widget.settings.isConfigured ? 'MiMo 已配置' : '未配置 API Key',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('MiMo: ${widget.settings.mimoModel}', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
                    Text('图像: ${widget.settings.imageModel}', style: TextStyle(fontSize: 13, color: AppTheme.muted)),
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
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xE60A1020)],
          ),
        ),
        child: SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(onPressed: _save, child: const Text('保存设置')),
        ),
      ),
    );
  }

  static Widget _sectionHeader(String title, String subtitle) {
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
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 13, color: AppTheme.muted)),
        ],
      ),
    );
  }

  static Widget _section(String label, TextEditingController ctrl,
      {bool obscure = false, Widget? suffix}) {
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
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            obscureText: obscure,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
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
