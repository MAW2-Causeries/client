class ChatMessage {
  final String id;
  final String authorId;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });
}
