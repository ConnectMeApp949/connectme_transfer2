// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
      messageId: json['messageId'] as String,
      receiverId: json['receiverId'] as String,
      senderName: json['senderName'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      threadId: json['threadId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
      'messageId': instance.messageId,
      'receiverId': instance.receiverId,
      'senderName': instance.senderName,
      'senderId': instance.senderId,
      'text': instance.text,
      'threadId': instance.threadId,
      'timestamp': instance.timestamp.toIso8601String(),
    };
