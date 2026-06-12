class ChatMessage {
  final String id;
  final String role; // 'user' | 'ai'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
