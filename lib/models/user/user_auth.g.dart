// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAuth _$UserAuthFromJson(Map<String, dynamic> json) => _UserAuth(
      userName: json['userName'] as String,
      userId: json['userId'] as String,
      userToken: json['userToken'] as String,
      email: json['email'] as String,
      accountLevel: json['accountLevel'] as String,
      purchaseEver: json['purchaseEver'] as bool,
    );

Map<String, dynamic> _$UserAuthToJson(_UserAuth instance) => <String, dynamic>{
      'userName': instance.userName,
      'userId': instance.userId,
      'userToken': instance.userToken,
      'email': instance.email,
      'accountLevel': instance.accountLevel,
      'purchaseEver': instance.purchaseEver,
    };
