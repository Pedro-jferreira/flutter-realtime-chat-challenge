part of 'gen.dart';

@freezed
abstract class ChatUser with _$ChatUser {
  const ChatUser._();
  const factory ChatUser({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
  }) = _ChatUser;

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required String senderId,
    required String senderName,
    @EpochDateTimeConverter() required DateTime timestamp,
    @Default({}) Map<String, bool> readBy,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

enum MessageStatus { sent, delivered, read }

class ReadReceipt {
  final String userId;
  final String userName;
  final DateTime timestamp;

  ReadReceipt({
    required this.userId,
    required this.userName,
    required this.timestamp,
  });

  factory ReadReceipt.fromMap(Map<String, dynamic> map, String userId) {
    return ReadReceipt(
      userId: userId,
      userName: map['userName'] ?? 'Desconhecido',
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : DateTime.now(),
    );
  }
}