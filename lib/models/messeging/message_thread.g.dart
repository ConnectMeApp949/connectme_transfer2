// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageThread _$MessageThreadFromJson(Map<String, dynamic> json) =>
    _MessageThread(
      threadId: json['threadId'] as String,
      lastMessage: json['lastMessage'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      userNames:
          (json['userNames'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MessageThreadToJson(_MessageThread instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'lastMessage': instance.lastMessage,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'userIds': instance.userIds,
      'userNames': instance.userNames,
    };
