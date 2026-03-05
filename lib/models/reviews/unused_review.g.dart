// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unused_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnusedReview _$UnusedReviewFromJson(Map<String, dynamic> json) =>
    _UnusedReview(
      bookingId: json['bookingId'] as String,
      clientUserId: json['clientUserId'] as String,
      clientUserName: json['clientUserName'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      ratingId: json['ratingId'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      bookingTime: DateTime.parse(json['bookingTime'] as String),
      vendorUserId: json['vendorUserId'] as String,
      vendorUserName: json['vendorUserName'] as String,
    );

Map<String, dynamic> _$UnusedReviewToJson(_UnusedReview instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'clientUserId': instance.clientUserId,
      'clientUserName': instance.clientUserName,
      'createTime': instance.createTime.toIso8601String(),
      'ratingId': instance.ratingId,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'bookingTime': instance.bookingTime.toIso8601String(),
      'vendorUserId': instance.vendorUserId,
      'vendorUserName': instance.vendorUserName,
    };
