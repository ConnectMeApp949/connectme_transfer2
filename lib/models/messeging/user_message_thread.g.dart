// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_message_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserMessageThread _$UserMessageThreadFromJson(Map<String, dynamic> json) =>
    _UserMessageThread(
      lastMessage: json['lastMessage'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      otherUserId: json['otherUserId'] as String,
      otherUserName: json['otherUserName'] as String,
      threadId: json['threadId'] as String,
      unread: json['unread'] as List<dynamic>?,
      wantBlock: json['wantBlock'] as List<dynamic>?,
    );

Map<String, dynamic> _$UserMessageThreadToJson(_UserMessageThread instance) =>
    <String, dynamic>{
      'lastMessage': instance.lastMessage,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'otherUserId': instance.otherUserId,
      'otherUserName': instance.otherUserName,
      'threadId': instance.threadId,
      'unread': instance.unread,
      'wantBlock': instance.wantBlock,
    };
