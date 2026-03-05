// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceOffered _$ServiceOfferedFromJson(Map<String, dynamic> json) =>
    _ServiceOffered(
      address: json['address'] as String?,
      category: json['category'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      description: json['description'] as String,
      email: json['email'] as String?,
      featureImageId: json['featureImageId'] as String,
      geoHash: json['geoHash'] as String?,
      imageIds: json['imageIds'] as List<dynamic>,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      location: json['location'] as Map<String, dynamic>?,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      priceCents: (json['priceCents'] as num).toInt(),
      radius: (json['radius'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      serviceId: json['serviceId'] as String,
      site: json['site'] as String,
      timeLength: (json['timeLength'] as num?)?.toInt(),
      vendorUserId: json['vendorUserId'] as String,
      vendorBusinessName: json['vendorBusinessName'] as String,
      vendorUserName: json['vendorUserName'] as String,
    );

Map<String, dynamic> _$ServiceOfferedToJson(_ServiceOffered instance) =>
    <String, dynamic>{
      'address': instance.address,
      'category': instance.category,
      'createTime': instance.createTime.toIso8601String(),
      'description': instance.description,
      'email': instance.email,
      'featureImageId': instance.featureImageId,
      'geoHash': instance.geoHash,
      'imageIds': instance.imageIds,
      'keywords': instance.keywords,
      'location': instance.location,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'priceCents': instance.priceCents,
      'radius': instance.radius,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'serviceId': instance.serviceId,
      'site': instance.site,
      'timeLength': instance.timeLength,
      'vendorUserId': instance.vendorUserId,
      'vendorBusinessName': instance.vendorBusinessName,
      'vendorUserName': instance.vendorUserName,
    };
