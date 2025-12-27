
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
  factory ChatUser.fromJson(Map<String, dynamic> json) => _$ChatUserFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required String senderId,
    required String senderName,
    required DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}


enum MessageStatus { sent, delivered, read }
