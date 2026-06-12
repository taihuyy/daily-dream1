import '../models/dream.dart';

class MockData {
  static final List<Dream> dreams = [
    Dream(
      title: '雨夜列车上的旧同学',
      rawText:
          '我坐在一列很旧的火车上，车厢里坐着小时候的同学，但大家都不说话。窗外一直在下暴雨，车好像永远也到不了站。',
      fullText:
          '我坐在一列很旧的火车上，车厢里全是小时候的同学。大家都认识我，却没有一个人愿意开口，好像所有人都在等什么事情发生。窗外一直在下暴雨，最奇怪的是风景始终没有变，像整列车被困在同一段夜里，永远到不了终点。我知道自己应该下车，但又隐约觉得，只要下车就会失去什么。',
      tags: ['火车', '童年', '暴雨', '循环', '悬疑'],
      isPublished: true,
      isAnonymous: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      likes: 248,
      comments: 41,
      shares: 19,
    ),
    Dream(
      title: '沉到海底的图书馆',
      rawText: '我发现自己在一个沉入海底的图书馆里看书，水在周围但不会湿。',
      fullText:
          '我发现自己站在一座沉入海底的图书馆里，书架高耸入顶，四周是幽蓝的海水，但奇怪的是我完全不会被淹没。我随手抽出一本书，翻开的每一页都是空白的，但手指触碰纸面时会浮现出文字，像是书在对我说话。',
      tags: ['海底', '图书馆', '奇幻'],
      isPublished: true,
      isAnonymous: false,
      feeling: '像在跟过去的某段记忆擦肩而过。',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 132,
      comments: 18,
      shares: 7,
    ),
    Dream(
      title: '会发光的鲸鱼来敲门',
      rawText: '梦里我把一只迷路的小鲸鱼抱回岸上，它像月光一样会自己发亮。',
      fullText:
          '梦里我在海边发现了一只迷路的小鲸鱼，它浑身散发着柔和的蓝光，像月光凝成的一样。我小心翼翼地把它抱回岸上，它在我怀里轻轻哼着歌，所有人都惊叹地看着这只发光的鲸鱼，但只有我知道，它只在我面前才会亮。',
      tags: ['治愈', '鲸鱼', '海洋', '光'],
      isPublished: true,
      isAnonymous: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      likes: 89,
      comments: 12,
      shares: 5,
    ),
    Dream(
      title: '飞不起来的风筝',
      rawText: '我拿着风筝跑了很久，但风筝就是飞不起来，后来发现线断了。',
      fullText:
          '我拿着一只巨大的风筝在空旷的草地上奔跑，风明明很大，风筝却怎么也飞不起来。我跑了很久很久，直到筋疲力尽，才发现风筝的线早就断了。断掉的线飘在空中，像一条细细的银蛇，越飘越高，最后消失在云层里。',
      tags: ['童年', '风筝', '遗憾'],
      isPublished: false,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      likes: 0,
      comments: 0,
      shares: 0,
    ),
    Dream(
      title: '空无一人的考场',
      rawText: '考试的时候发现卷子上的题都不会，但旁边的人都在奋笔疾书。',
      fullText:
          '我坐在一间宽敞的考场里，面前的试卷上密密麻麻写满了题目，但我一道也看不懂。旁边的同学们都在奋笔疾书，笔尖沙沙作响。我翻开第二页，题目突然变成了小时候的照片，每一张都是我记不起来的瞬间。',
      tags: ['考试', '焦虑', '童年'],
      isPublished: true,
      isAnonymous: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      likes: 67,
      comments: 8,
      shares: 3,
    ),
  ];

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
