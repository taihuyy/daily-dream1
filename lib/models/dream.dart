import 'package:uuid/uuid.dart';

class Dream {
  final String id;
  String title;
  String rawText;
  String fullText;
  List<String> tags;
  String? imageUrl;
  DateTime createdAt;
  bool isPublished;
  bool isAnonymous;
  String? feeling;
  int likes;
  int comments;
  int shares;

  Dream({
    String? id,
    this.title = '',
    this.rawText = '',
    this.fullText = '',
    List<String>? tags,
    this.imageUrl,
    DateTime? createdAt,
    this.isPublished = false,
    this.isAnonymous = true,
    this.feeling,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  })  : id = id ?? const Uuid().v4(),
        tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'rawText': rawText,
        'fullText': fullText,
        'tags': tags,
        'imageUrl': imageUrl,
        'createdAt': createdAt.toIso8601String(),
        'isPublished': isPublished,
        'isAnonymous': isAnonymous,
        'feeling': feeling,
        'likes': likes,
        'comments': comments,
        'shares': shares,
      };

  factory Dream.fromMap(Map<String, dynamic> m) => Dream(
        id: m['id'],
        title: m['title'] ?? '',
        rawText: m['rawText'] ?? '',
        fullText: m['fullText'] ?? '',
        tags: List<String>.from(m['tags'] ?? []),
        imageUrl: m['imageUrl'],
        createdAt: DateTime.parse(m['createdAt']),
        isPublished: m['isPublished'] ?? false,
        isAnonymous: m['isAnonymous'] ?? true,
        feeling: m['feeling'],
        likes: m['likes'] ?? 0,
        comments: m['comments'] ?? 0,
        shares: m['shares'] ?? 0,
      );
}
