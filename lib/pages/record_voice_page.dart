import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/dream_provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class RecordVoicePage extends StatefulWidget {
  const RecordVoicePage({super.key});

  @override
  State<RecordVoicePage> createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> {
  bool _isRecording = false;
  double _orbScale = 1.0;
  Timer? _pulseTimer;
  final _transcript = TextEditingController();
  stt.SpeechToText? _speech;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _transcript.addListener(() => setState(() {}));
    _initSpeech();
  }

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    _speechAvailable = await _speech!.initialize(
      onError: (_) => setState(() => _isRecording = false),
      onStatus: (s) {
        if (s == 'notListening' || s == 'done') {
          setState(() => _isRecording = false);
        }
      },
    );
    setState(() {});
  }

  void _startPulse() {
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (_isRecording) {
        setState(() => _orbScale = _orbScale == 1.0 ? 1.08 : 1.0);
      }
    });
  }

  void _toggleRecording() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('语音识别不可用，请检查麦克风权限')),
      );
      return;
    }

    if (_isRecording) {
      _speech!.stop();
      _pulseTimer?.cancel();
      setState(() => _isRecording = false);
    } else {
      setState(() => _isRecording = true);
      _startPulse();
      _speech!.listen(
        onResult: (result) {
          setState(() {
            _transcript.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _speech?.cancel();
    _transcript.dispose();
    super.dispose();
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
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              const SizedBox(height: 8),
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
                      child: Text('语音记录', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 12),

              Column(
                children: [
                  Text('把你记得的梦先说出来', style: TextStyle(fontSize: 14, color: AppTheme.muted)),
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: AnimatedScale(
                      scale: _orbScale,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 160, height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _isRecording ? AppTheme.primary2.withOpacity(0.75) : AppTheme.muted.withOpacity(0.4),
                              AppTheme.primary.withOpacity(0.22),
                              AppTheme.primary.withOpacity(0.08),
                            ],
                          ),
                          boxShadow: _isRecording ? [
                            BoxShadow(color: AppTheme.primary2.withOpacity(0.12), blurRadius: 60),
                          ] : [],
                        ),
                        child: Center(
                          child: Text(
                            _isRecording ? '◉' : '▶',
                            style: TextStyle(fontSize: 44, color: _isRecording ? Colors.white : AppTheme.muted),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _isRecording ? '正在录音...' : '点击开始录音',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '醒来后的第一分钟最珍贵，先说，不用整理。',
                    style: TextStyle(fontSize: 14, color: AppTheme.muted),
                  ),
                ],
              ),
              const SizedBox(height: 24),

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
                    const Text('实时转写', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _transcript,
                      maxLines: 6,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _isRecording ? '正在听你说...' : '点击上方按钮开始录音，或直接在此输入...',
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          _transcript.clear();
                          setState(() => _isRecording = false);
                          _speech?.stop();
                          _pulseTimer?.cancel();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.line),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('重新录制'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _transcript.text.trim().isEmpty ? null : () {
                          final dp = context.read<DreamProvider>();
                          final cp = context.read<ChatProvider>();
                          final text = _transcript.text.trim();
                          dp.createNewDream(rawText: text);
                          cp.startChat(text);
                          Navigator.pushNamed(context, '/ai-chat');
                        },
                        child: const Text('继续下一步'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
