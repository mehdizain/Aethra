import 'dart:typed_data';

enum MessageType { user, bot }
enum MessageContentType { text, image }

class ChatMessage {
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final MessageContentType contentType;
  final Uint8List? imageBytes;

  ChatMessage({
    required this.text,
    required this.type,
    DateTime? timestamp,
    this.contentType = MessageContentType.text,
    this.imageBytes,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isUser => type == MessageType.user;
  bool get isBot => type == MessageType.bot;
  bool get isImage => contentType == MessageContentType.image;
  bool get isText => contentType == MessageContentType.text;
}
