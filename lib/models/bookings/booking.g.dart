// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
      address: json['address'] as String?,
      bookingId: json['bookingId'] as String,
      bookingTime: DateTime.parse(json['bookingTime'] as String),
      clientUserId: json['clientUserId'] as String,
      clientUserName: json['clientUserName'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      priceCents: (json['priceCents'] as num).toInt(),
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      site: json['site'] as String,
      status: json['status'] as String,
      timeLength: (json['timeLength'] as num).toInt(),
      vendorBusinessName: json['vendorBusinessName'] as String,
      vendorUserId: json['vendorUserId'] as String,
      vendorUserName: json['vendorUserName'] as String,
    );

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
      'address': instance.address,
      'bookingId': instance.bookingId,
      'bookingTime': instance.bookingTime.toIso8601String(),
      'clientUserId': instance.clientUserId,
      'clientUserName': instance.clientUserName,
      'createTime': instance.createTime.toIso8601String(),
      'priceCents': instance.priceCents,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'site': instance.site,
      'status': instance.status,
      'timeLength': instance.timeLength,
      'vendorBusinessName': instance.vendorBusinessName,
      'vendorUserId': instance.vendorUserId,
      'vendorUserName': instance.vendorUserName,
    };
