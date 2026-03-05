// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompletedReview _$CompletedReviewFromJson(Map<String, dynamic> json) =>
    _CompletedReview(
      createTime: DateTime.parse(json['createTime'] as String),
      bookingId: json['bookingId'] as String,
      clientUserId: json['clientUserId'] as String,
      clientUserName: json['clientUserName'] as String,
      rating: (json['rating'] as num).toDouble(),
      ratingComment: json['ratingComment'] as String,
      ratingId: json['ratingId'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      bookingTime: DateTime.parse(json['bookingTime'] as String),
      vendorUserId: json['vendorUserId'] as String,
      vendorUserName: json['vendorUserName'] as String,
    );

Map<String, dynamic> _$CompletedReviewToJson(_CompletedReview instance) =>
    <String, dynamic>{
      'createTime': instance.createTime.toIso8601String(),
      'bookingId': instance.bookingId,
      'clientUserId': instance.clientUserId,
      'clientUserName': instance.clientUserName,
      'rating': instance.rating,
      'ratingComment': instance.ratingComment,
      'ratingId': instance.ratingId,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'bookingTime': instance.bookingTime.toIso8601String(),
      'vendorUserId': instance.vendorUserId,
      'vendorUserName': instance.vendorUserName,
    };
