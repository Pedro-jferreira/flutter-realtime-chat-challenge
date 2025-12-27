// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => _ChatUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$ChatUserToJson(_ChatUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'photoUrl': instance.photoUrl,
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  text: json['text'] as String,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  timestamp: const EpochDateTimeConverter().fromJson(
    json['timestamp'] as Object,
  ),
  readBy:
      (json['readBy'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const {},
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'timestamp': const EpochDateTimeConverter().toJson(instance.timestamp),
      'readBy': instance.readBy,
    };
