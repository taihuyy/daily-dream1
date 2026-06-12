import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dream_provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class RecordVoicePage extends StatefulWidget {
  const RecordVoicePage({super.key});

  @override
  State<RecordVoicePage> createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> {
  bool _isRecording = true;
  double _orbScale = 1.0;
  Timer? _pulseTimer;
  final _transcript = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _startPulse();
    _simulateTranscript();
  }

  void _startPulse() {
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (_isRecording) {
        setState(() => _orbScale = _orbScale == 1.0 ? 1.08 : 1.0);
      }
    });
  }

  void _simulateTranscript() {
    final texts = [
      '我在一个旧火车上，外面下很大的雨，',
      '好像有小学同学坐在对面，',
      '但他们都不看我……',
      '车好像永远到不了站。',
    ];
    int idx = 0;
    Timer.periodic(const Duration(milliseconds: 1500), (t) {
      if (idx < texts.length && _isRecording) {
        _transcript.value += texts[idx];
        idx++;
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _transcript.dispose();
    super.dispose();
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
                  AnimatedScale(
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
                          BoxShadow(
                            color: AppTheme.primary2.withOpacity(0.12),
                            blurRadius: 60,
                          ),
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
                  const SizedBox(height: 18),
                  Text(
                    _isRecording ? '正在记录梦境碎片...' : '录音已暂停',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '醒来后的第一分钟最珍贵，先说，不用整理。',
                    style: TextStyle(fontSize: 14, color: AppTheme.muted),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0x0FFFFFFF),
                ),
                child: CustomPaint(painter: _WavePainter()),
              ),
              const SizedBox(height: 16),

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
                    const SizedBox(height: 8),
                    ValueListenableBuilder<String>(
                      valueListenable: _transcript,
                      builder: (_, text, __) => Text(
                        '"${text.isEmpty ? '等待中...' : text}"',
                        style: TextStyle(fontSize: 14, height: 1.6, color: AppTheme.muted),
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
                        onPressed: () => setState(() {
                          _isRecording = !_isRecording;
                          _transcript.value = '';
                          if (_isRecording) _simulateTranscript();
                        }),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.line),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(_isRecording ? '暂停' : '重新录制'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final dp = context.read<DreamProvider>();
                          final cp = context.read<ChatProvider>();
                          dp.createNewDream(rawText: _transcript.value.isNotEmpty ? _transcript.value : '我在一个旧火车上...');
                          cp.startChat(_transcript.value.isNotEmpty ? _transcript.value : '我在一个旧火车上...');
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

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rng = Random(42);
    for (int i = 0; i < 60; i++) {
      final x = size.width * i / 60;
      final h = rng.nextDouble() * size.height * 0.6 + size.height * 0.2;
      canvas.drawLine(Offset(x, h - 4), Offset(x, h + 4), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
