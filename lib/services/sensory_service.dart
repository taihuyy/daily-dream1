import 'package:flutter/services.dart';

class SensoryService {
  const SensoryService._();

  static Future<void> softTap() async {
    await HapticFeedback.selectionClick();
    await SystemSound.play(SystemSoundType.click);
  }

  static Future<void> action() async {
    await HapticFeedback.lightImpact();
    await SystemSound.play(SystemSoundType.click);
  }

  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await SystemSound.play(SystemSoundType.alert);
  }

  static Future<void> warning() async {
    await HapticFeedback.heavyImpact();
    await SystemSound.play(SystemSoundType.alert);
  }
}
