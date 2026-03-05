// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientUserMeta _$ClientUserMetaFromJson(Map<String, dynamic> json) =>
    _ClientUserMeta(
      userName: json['userName'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      geoHash: json['geoHash'] as String?,
      location: json['location'] as Map<String, dynamic>?,
      address: json['address'] as String?,
      addressGeoHash: json['addressGeoHash'] as String?,
      addressLocation: json['addressLocation'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ClientUserMetaToJson(_ClientUserMeta instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'geoHash': instance.geoHash,
      'location': instance.location,
      'address': instance.address,
      'addressGeoHash': instance.addressGeoHash,
      'addressLocation': instance.addressLocation,
    };

const _$UserTypeEnumMap = {
  UserType.vendor: 'vendor',
  UserType.client: 'client',
  UserType.guest: 'guest',
};
