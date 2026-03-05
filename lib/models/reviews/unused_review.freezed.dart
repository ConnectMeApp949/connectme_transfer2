// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unused_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnusedReview {
  String get bookingId;
  String get clientUserId;
  String get clientUserName;
  DateTime get createTime;
  String get ratingId;
  String get serviceId;
  String get serviceName;
  DateTime get bookingTime;
  String get vendorUserId;
  String get vendorUserName;

  /// Create a copy of UnusedReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnusedReviewCopyWith<UnusedReview> get copyWith =>
      _$UnusedReviewCopyWithImpl<UnusedReview>(
          this as UnusedReview, _$identity);

  /// Serializes this UnusedReview to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnusedReview &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.clientUserName, clientUserName) ||
                other.clientUserName == clientUserName) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.ratingId, ratingId) ||
                other.ratingId == ratingId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.bookingTime, bookingTime) ||
                other.bookingTime == bookingTime) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.vendorUserName, vendorUserName) ||
                other.vendorUserName == vendorUserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookingId,
      clientUserId,
      clientUserName,
      createTime,
      ratingId,
      serviceId,
      serviceName,
      bookingTime,
      vendorUserId,
      vendorUserName);

  @override
  String toString() {
    return 'UnusedReview(bookingId: $bookingId, clientUserId: $clientUserId, clientUserName: $clientUserName, createTime: $createTime, ratingId: $ratingId, serviceId: $serviceId, serviceName: $serviceName, bookingTime: $bookingTime, vendorUserId: $vendorUserId, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class $UnusedReviewCopyWith<$Res> {
  factory $UnusedReviewCopyWith(
          UnusedReview value, $Res Function(UnusedReview) _then) =
      _$UnusedReviewCopyWithImpl;
  @useResult
  $Res call(
      {String bookingId,
      String clientUserId,
      String clientUserName,
      DateTime createTime,
      String ratingId,
      String serviceId,
      String serviceName,
      DateTime bookingTime,
      String vendorUserId,
      String vendorUserName});
}

/// @nodoc
class _$UnusedReviewCopyWithImpl<$Res> implements $UnusedReviewCopyWith<$Res> {
  _$UnusedReviewCopyWithImpl(this._self, this._then);

  final UnusedReview _self;
  final $Res Function(UnusedReview) _then;

  /// Create a copy of UnusedReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? clientUserId = null,
    Object? clientUserName = null,
    Object? createTime = null,
    Object? ratingId = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? bookingTime = null,
    Object? vendorUserId = null,
    Object? vendorUserName = null,
  }) {
    return _then(_self.copyWith(
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
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
      ratingId: null == ratingId
          ? _self.ratingId
          : ratingId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      bookingTime: null == bookingTime
          ? _self.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
class _UnusedReview implements UnusedReview {
  const _UnusedReview(
      {required this.bookingId,
      required this.clientUserId,
      required this.clientUserName,
      required this.createTime,
      required this.ratingId,
      required this.serviceId,
      required this.serviceName,
      required this.bookingTime,
      required this.vendorUserId,
      required this.vendorUserName});
  factory _UnusedReview.fromJson(Map<String, dynamic> json) =>
      _$UnusedReviewFromJson(json);

  @override
  final String bookingId;
  @override
  final String clientUserId;
  @override
  final String clientUserName;
  @override
  final DateTime createTime;
  @override
  final String ratingId;
  @override
  final String serviceId;
  @override
  final String serviceName;
  @override
  final DateTime bookingTime;
  @override
  final String vendorUserId;
  @override
  final String vendorUserName;

  /// Create a copy of UnusedReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UnusedReviewCopyWith<_UnusedReview> get copyWith =>
      __$UnusedReviewCopyWithImpl<_UnusedReview>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UnusedReviewToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UnusedReview &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.clientUserName, clientUserName) ||
                other.clientUserName == clientUserName) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.ratingId, ratingId) ||
                other.ratingId == ratingId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.bookingTime, bookingTime) ||
                other.bookingTime == bookingTime) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.vendorUserName, vendorUserName) ||
                other.vendorUserName == vendorUserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookingId,
      clientUserId,
      clientUserName,
      createTime,
      ratingId,
      serviceId,
      serviceName,
      bookingTime,
      vendorUserId,
      vendorUserName);

  @override
  String toString() {
    return 'UnusedReview(bookingId: $bookingId, clientUserId: $clientUserId, clientUserName: $clientUserName, createTime: $createTime, ratingId: $ratingId, serviceId: $serviceId, serviceName: $serviceName, bookingTime: $bookingTime, vendorUserId: $vendorUserId, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class _$UnusedReviewCopyWith<$Res>
    implements $UnusedReviewCopyWith<$Res> {
  factory _$UnusedReviewCopyWith(
          _UnusedReview value, $Res Function(_UnusedReview) _then) =
      __$UnusedReviewCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String bookingId,
      String clientUserId,
      String clientUserName,
      DateTime createTime,
      String ratingId,
      String serviceId,
      String serviceName,
      DateTime bookingTime,
      String vendorUserId,
      String vendorUserName});
}

/// @nodoc
class __$UnusedReviewCopyWithImpl<$Res>
    implements _$UnusedReviewCopyWith<$Res> {
  __$UnusedReviewCopyWithImpl(this._self, this._then);

  final _UnusedReview _self;
  final $Res Function(_UnusedReview) _then;

  /// Create a copy of UnusedReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bookingId = null,
    Object? clientUserId = null,
    Object? clientUserName = null,
    Object? createTime = null,
    Object? ratingId = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? bookingTime = null,
    Object? vendorUserId = null,
    Object? vendorUserName = null,
  }) {
    return _then(_UnusedReview(
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
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
      ratingId: null == ratingId
          ? _self.ratingId
          : ratingId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      bookingTime: null == bookingTime
          ? _self.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
