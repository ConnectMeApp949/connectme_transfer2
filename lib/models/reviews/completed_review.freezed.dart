// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completed_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompletedReview {
  DateTime get createTime;
  String get bookingId;
  String get clientUserId;
  String get clientUserName;
  double get rating;
  String get ratingComment;
  String get ratingId;
  String get serviceId;
  String get serviceName;
  DateTime get bookingTime;
  String get vendorUserId;
  String get vendorUserName;

  /// Create a copy of CompletedReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompletedReviewCopyWith<CompletedReview> get copyWith =>
      _$CompletedReviewCopyWithImpl<CompletedReview>(
          this as CompletedReview, _$identity);

  /// Serializes this CompletedReview to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompletedReview &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.clientUserName, clientUserName) ||
                other.clientUserName == clientUserName) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingComment, ratingComment) ||
                other.ratingComment == ratingComment) &&
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
      createTime,
      bookingId,
      clientUserId,
      clientUserName,
      rating,
      ratingComment,
      ratingId,
      serviceId,
      serviceName,
      bookingTime,
      vendorUserId,
      vendorUserName);

  @override
  String toString() {
    return 'CompletedReview(createTime: $createTime, bookingId: $bookingId, clientUserId: $clientUserId, clientUserName: $clientUserName, rating: $rating, ratingComment: $ratingComment, ratingId: $ratingId, serviceId: $serviceId, serviceName: $serviceName, bookingTime: $bookingTime, vendorUserId: $vendorUserId, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class $CompletedReviewCopyWith<$Res> {
  factory $CompletedReviewCopyWith(
          CompletedReview value, $Res Function(CompletedReview) _then) =
      _$CompletedReviewCopyWithImpl;
  @useResult
  $Res call(
      {DateTime createTime,
      String bookingId,
      String clientUserId,
      String clientUserName,
      double rating,
      String ratingComment,
      String ratingId,
      String serviceId,
      String serviceName,
      DateTime bookingTime,
      String vendorUserId,
      String vendorUserName});
}

/// @nodoc
class _$CompletedReviewCopyWithImpl<$Res>
    implements $CompletedReviewCopyWith<$Res> {
  _$CompletedReviewCopyWithImpl(this._self, this._then);

  final CompletedReview _self;
  final $Res Function(CompletedReview) _then;

  /// Create a copy of CompletedReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createTime = null,
    Object? bookingId = null,
    Object? clientUserId = null,
    Object? clientUserName = null,
    Object? rating = null,
    Object? ratingComment = null,
    Object? ratingId = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? bookingTime = null,
    Object? vendorUserId = null,
    Object? vendorUserName = null,
  }) {
    return _then(_self.copyWith(
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingComment: null == ratingComment
          ? _self.ratingComment
          : ratingComment // ignore: cast_nullable_to_non_nullable
              as String,
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
class _CompletedReview implements CompletedReview {
  const _CompletedReview(
      {required this.createTime,
      required this.bookingId,
      required this.clientUserId,
      required this.clientUserName,
      required this.rating,
      required this.ratingComment,
      required this.ratingId,
      required this.serviceId,
      required this.serviceName,
      required this.bookingTime,
      required this.vendorUserId,
      required this.vendorUserName});
  factory _CompletedReview.fromJson(Map<String, dynamic> json) =>
      _$CompletedReviewFromJson(json);

  @override
  final DateTime createTime;
  @override
  final String bookingId;
  @override
  final String clientUserId;
  @override
  final String clientUserName;
  @override
  final double rating;
  @override
  final String ratingComment;
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

  /// Create a copy of CompletedReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompletedReviewCopyWith<_CompletedReview> get copyWith =>
      __$CompletedReviewCopyWithImpl<_CompletedReview>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompletedReviewToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompletedReview &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.clientUserName, clientUserName) ||
                other.clientUserName == clientUserName) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingComment, ratingComment) ||
                other.ratingComment == ratingComment) &&
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
      createTime,
      bookingId,
      clientUserId,
      clientUserName,
      rating,
      ratingComment,
      ratingId,
      serviceId,
      serviceName,
      bookingTime,
      vendorUserId,
      vendorUserName);

  @override
  String toString() {
    return 'CompletedReview(createTime: $createTime, bookingId: $bookingId, clientUserId: $clientUserId, clientUserName: $clientUserName, rating: $rating, ratingComment: $ratingComment, ratingId: $ratingId, serviceId: $serviceId, serviceName: $serviceName, bookingTime: $bookingTime, vendorUserId: $vendorUserId, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class _$CompletedReviewCopyWith<$Res>
    implements $CompletedReviewCopyWith<$Res> {
  factory _$CompletedReviewCopyWith(
          _CompletedReview value, $Res Function(_CompletedReview) _then) =
      __$CompletedReviewCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime createTime,
      String bookingId,
      String clientUserId,
      String clientUserName,
      double rating,
      String ratingComment,
      String ratingId,
      String serviceId,
      String serviceName,
      DateTime bookingTime,
      String vendorUserId,
      String vendorUserName});
}

/// @nodoc
class __$CompletedReviewCopyWithImpl<$Res>
    implements _$CompletedReviewCopyWith<$Res> {
  __$CompletedReviewCopyWithImpl(this._self, this._then);

  final _CompletedReview _self;
  final $Res Function(_CompletedReview) _then;

  /// Create a copy of CompletedReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? createTime = null,
    Object? bookingId = null,
    Object? clientUserId = null,
    Object? clientUserName = null,
    Object? rating = null,
    Object? ratingComment = null,
    Object? ratingId = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? bookingTime = null,
    Object? vendorUserId = null,
    Object? vendorUserName = null,
  }) {
    return _then(_CompletedReview(
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingComment: null == ratingComment
          ? _self.ratingComment
          : ratingComment // ignore: cast_nullable_to_non_nullable
              as String,
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
