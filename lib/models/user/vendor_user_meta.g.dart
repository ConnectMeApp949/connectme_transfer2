// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorUserMeta _$VendorUserMetaFromJson(Map<String, dynamic> json) =>
    _VendorUserMeta(
      userName: json['userName'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      geoHash: json['geoHash'] as String?,
      address: json['address'] as String?,
      location: json['location'] as Map<String, dynamic>?,
      businessName: json['businessName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VendorUserMetaToJson(_VendorUserMeta instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'geoHash': instance.geoHash,
      'address': instance.address,
      'location': instance.location,
      'businessName': instance.businessName,
      'email': instance.email,
      'phone': instance.phone,
      'website': instance.website,
      'bio': instance.bio,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
    };

const _$UserTypeEnumMap = {
  UserType.vendor: 'vendor',
  UserType.client: 'client',
  UserType.guest: 'guest',
};
