import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/dream_provider.dart';
import '../providers/chat_provider.dart';
import '../services/sensory_service.dart';
import '../widgets/dream_animations.dart';
import '../theme/app_theme.dart';

class RecordVoicePage extends StatefulWidget {
  const RecordVoicePage({super.key});

  @override
  State<RecordVoicePage> createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  final _transcript = TextEditingController();
  stt.SpeechToText? _speech;
  bool _isRecording = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0,
      upperBound: 1,
    )..repeat(reverse: true);
    _transcript.addListener(_onTranscriptChanged);
    _initSpeech();
  }

  void _onTranscriptChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    final available = await _speech!.initialize(
      onError: (_) {
        if (mounted) setState(() => _isRecording = false);
      },
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'notListening' || status == 'done') {
          setState(() => _isRecording = false);
        }
      },
    );
    if (mounted) setState(() => _speechAvailable = available);
  }

  Future<void> _toggleRecording() async {
    if (!_speechAvailable) {
      SensoryService.warning();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('语音识别不可用，请检查麦克风权限')),
      );
      return;
    }

    if (_isRecording) {
      SensoryService.action();
      await _speech?.stop();
      if (mounted) setState(() => _isRecording = false);
      return;
    }

    SensoryService.action();
    setState(() => _isRecording = true);
    await _speech?.listen(
      onResult: (result) {
        _transcript.text = result.recognizedWords;
      },
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 3),
      localeId: 'zh_CN',
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech?.cancel();
    _transcript.removeListener(_onTranscriptChanged);
    _transcript.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _transcript.text.trim();

    return Scaffold(
      body: DreamBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              const DreamTopBar(title: '语音记录'),
              const SizedBox(height: 18),
              DreamFadeIn(child: _voiceStage()),
              const SizedBox(height: 18),
              DreamFadeIn(
                delay: const Duration(milliseconds: 120),
                child: _transcriptPanel(),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          SensoryService.softTap();
                          _transcript.clear();
                          await _speech?.stop();
                          if (mounted) setState(() => _isRecording = false);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.line),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.replay_rounded, size: 18),
                        label: const Text('重新录制'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: text.isEmpty ? null : () {
                          SensoryService.success();
                          final dp = context.read<DreamProvider>();
                          final cp = context.read<ChatProvider>();
                          dp.createNewDream(rawText: text);
                          cp.startChat(text);
                          Navigator.pushNamed(context, '/ai-chat');
                        },
                        icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                        label: const Text('继续下一步'),
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

  Widget _voiceStage() {
    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          (_isRecording ? AppTheme.primary2 : AppTheme.primary).withValues(alpha: 0.15),
          AppTheme.panelStrong,
        ],
      ),
      child: Column(
        children: [
          Text(
            _isRecording ? '梦正在被听见' : '把梦先说出来',
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            '醒来后的第一分钟最珍贵，先说，不用整理。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.55, color: AppTheme.muted),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) {
                final pulse = _isRecording ? _pulseController.value : 0.18;
                final accent = _isRecording ? AppTheme.primary2 : AppTheme.moon;
                return Container(
                  width: 164 + pulse * 10,
                  height: 164 + pulse * 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.12 + pulse * 0.08),
                    border: Border.all(color: accent.withValues(alpha: 0.35 + pulse * 0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.16 + pulse * 0.12),
                        blurRadius: 34 + pulse * 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.bgDeep.withValues(alpha: 0.58),
                        border: Border.all(color: AppTheme.line),
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        size: 42,
                        color: accent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _soundBars(),
          const SizedBox(height: 14),
          Text(
            _isRecording ? '正在录音...' : (_speechAvailable ? '点击开始录音' : '正在准备麦克风'),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _soundBars() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(13, (index) {
            final wave = (_isRecording ? _pulseController.value : 0.18);
            final height = 8 + ((index % 5) + 1) * 4 * wave;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 4,
              height: height,
              decoration: BoxDecoration(
                color: (_isRecording ? AppTheme.primary2 : AppTheme.muted).withValues(alpha: 0.35 + wave * 0.35),
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _transcriptPanel() {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.graphic_eq_rounded, size: 18, color: AppTheme.primary2),
              const SizedBox(width: 8),
              const Expanded(child: Text('实时转写', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
              Text('${_transcript.text.trim().length} 字', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _transcript,
            maxLines: 7,
            minLines: 5,
            style: const TextStyle(fontSize: 14, height: 1.65),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _isRecording ? '正在听你说...' : '点击上方按钮开始录音，或直接在这里补充...',
              fillColor: Colors.transparent,
              filled: false,
            ),
          ),
        ],
      ),
    );
  }
}
