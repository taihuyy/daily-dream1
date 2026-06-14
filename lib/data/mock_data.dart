import '../models/dream.dart';

class MockData {
  static final List<Dream> dreams = [];

  static final List<String> _aiReplies = [
    '你当时最强烈的感受是什么？害怕、困惑，还是像在等什么事情发生？',
    '窗外或者车厢里，有没有特别不真实的画面？这会帮助我还原梦的氛围。',
    '那个场景里有没有声音？雨声、风声，还是某种你熟悉的旋律？',
    '如果用一种颜色来形容这个梦，你觉得是什么颜色？',
    '梦的最后你是怎么醒来的？是突然惊醒，还是慢慢淡出？',
  ];

  static int _replyIndex = 0;

  static String getNextAiReply(int messageCount) {
    final idx = _replyIndex % _aiReplies.length;
    _replyIndex++;
    return _aiReplies[idx];
  }
}
