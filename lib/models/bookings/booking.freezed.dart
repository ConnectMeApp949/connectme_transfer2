// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Booking {
  String? get address;

  /// null for remote
  String get bookingId;
  DateTime get bookingTime;
  String get clientUserId;
  String get clientUserName;
  DateTime get createTime;
  int get priceCents;
  String get serviceId;
  String get serviceName;
  String get site;

  /// on-site, client-site, remote, delivery
  String get status;

  /// pending, confirmed, complete
  int get timeLength;
  String get vendorBusinessName;
  String get vendorUserId;
  String get vendorUserName;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookingCopyWith<Booking> get copyWith =>
      _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Booking &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.bookingTime, bookingTime) ||
                other.bookingTime == bookingTime) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.clientUserName, clientUserName) ||
                other.clientUserName == clientUserName) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timeLength, timeLength) ||
                other.timeLength == timeLength) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.vendorUserName, vendorUserName) ||
                other.vendorUserName == vendorUserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      address,
      bookingId,
      bookingTime,
      clientUserId,
      clientUserName,
      createTime,
      priceCents,
      serviceId,
      serviceName,
      site,
      status,
      timeLength,
      vendorBusinessName,
      vendorUserId,
      vendorUserName);

  @override
  String toString() {
    return 'Booking(address: $address, bookingId: $bookingId, bookingTime: $bookingTime, clientUserId: $clientUserId, clientUserName: $clientUserName, createTime: $createTime, priceCents: $priceCents, serviceId: $serviceId, serviceName: $serviceName, site: $site, status: $status, timeLength: $timeLength, vendorBusinessName: $vendorBusinessName, vendorUserId: $vendorUserId, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) =
      _$BookingCopyWithImpl;
  @useResult
  $Res call(
      {String? address,
      String bookingId,
      DateTime bookingTime,
      String clientUserId,
      String clientUserName,
      DateTime createTime,
      int priceCents,
      String serviceId,
      String serviceName,
      String site,
      String status,
      int timeLength,
      String vendorBusinessName,
      String vendorUserId,
      String vendorUserName});
}

/// @nodoc
class _$BookingCopyWithImpl<$Res> implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? bookingId = null,
    Object? bookingTime = null,
    Object? clientUserId = null,
    Object? clientUserName = null,
    Object? createTime = null,
    Object? priceCents = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? site = null,
    Object? status = null,
    Object? timeLength = null,
    Object? vendorBusinessName = null,
    Object? vendorUserId = null,
    Object? vendorUserName = null,
  }) {
    return _then(_self.copyWith(
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingTime: null == bookingTime
          ? _self.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      clientUserId: null == clientUserId
          ? _self.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserName: null == clientUserName
          ? _self.clientUserName
          : clientUserName // ignore: cast_nullable_to_non_nullable
              as String,
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priceCents: null == priceCents
          ? _self.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _self.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      timeLength: null == timeLength
          ? _self.timeLength
          : timeLength // ignore: cast_nullable_to_non_nullable
              as int,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserName: null == vendorUserName
          ? _self.vendorUserName
          : vendorUserName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Booking implements Booking {
  const _Booking(
      {this.address,
      required this.bookingId,
      required this.bookingTime,
      required this.clientUserId,
      required this.clientUserName,
      required this.createTime,
      required this.priceCents,
      required this.serviceId,
      required this.serviceName,
      required this.site,
      required this.status,
      required this.timeLength,
      required this.vendorBusinessName,
      required this.vendorUserId,
      required this.vendorUserName});
  factory _Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  @override
  final String? address;

  /// null for remote
  @override
  final String bookingId;
  @override
  final DateTime bookingTime;
  @override
  final String clientUserId;
  @override
  final String clientUserName;
  @override
  final DateTime createTime;
  @override
  final int priceCents;
  @override
  final String serviceId;
  @override
  final String serviceName;
  @override
  final String site;

  /// on-site, client-site, remote, delivery
  @override
  final String status;

  /// pending, confirmed, complete
  @override
  final int timeLength;
  @override
  final String vendorBusinessName;
  @override
  final String vendorUserId;
  @override
  final String vendorUserName;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookingCopyWith<_Booking> get copyWith =>
      __$BookingCopyWithImpl<_Booking>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Booking &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.bookingTime, bookingTime) ||
                other.bookingTime == bookingTime) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.clientUserName, clientUserName) ||
                other.clientUserName == clientUserName) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timeLength, timeLength) ||
                other.timeLength == timeLength) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.vendorUserName, vendorUserName) ||
                other.vendorUserName == vendorUserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      address,
      bookingId,
      bookingTime,
      clientUserId,
      clientUserName,
      createTime,
      priceCents,
      serviceId,
      serviceName,
      site,
      status,
      timeLength,
      vendorBusinessName,
      vendorUserId,
      vendorUserName);

  @override
  String toString() {
    return 'Booking(address: $address, bookingId: $bookingId, bookingTime: $bookingTime, clientUserId: $clientUserId, clientUserName: $clientUserName, createTime: $createTime, priceCents: $priceCents, serviceId: $serviceId, serviceName: $serviceName, site: $site, status: $status, timeLength: $timeLength, vendorBusinessName: $vendorBusinessName, vendorUserId: $vendorUserId, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) =
      __$BookingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? address,
      String bookingId,
      DateTime bookingTime,
      String clientUserId,
      String clientUserName,
      DateTime createTime,
      int priceCents,
      String serviceId,
      String serviceName,
      String site,
      String status,
      int timeLength,
      String vendorBusinessName,
      String vendorUserId,
      String vendorUserName});
}

/// @nodoc
class __$BookingCopyWithImpl<$Res> implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? address = freezed,
    Object? bookingId = null,
    Object? bookingTime = null,
    Object? clientUserId = null,
    Object? clientUserName = null,
    Object? createTime = null,
    Object? priceCents = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? site = null,
    Object? status = null,
    Object? timeLength = null,
    Object? vendorBusinessName = null,
    Object? vendorUserId = null,
    Object? vendorUserName = null,
  }) {
    return _then(_Booking(
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingTime: null == bookingTime
          ? _self.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      clientUserId: null == clientUserId
          ? _self.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserName: null == clientUserName
          ? _self.clientUserName
          : clientUserName // ignore: cast_nullable_to_non_nullable
              as String,
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priceCents: null == priceCents
          ? _self.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _self.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      timeLength: null == timeLength
          ? _self.timeLength
          : timeLength // ignore: cast_nullable_to_non_nullable
              as int,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserName: null == vendorUserName
          ? _self.vendorUserName
          : vendorUserName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
