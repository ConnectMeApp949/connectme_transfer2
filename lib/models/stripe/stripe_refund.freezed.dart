// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_refund.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripeRefund {
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @JsonKey(name: 'client_user_id')
  String get clientUserId;
  @JsonKey(name: 'createTime')
  DateTime get createTime;
  @JsonKey(name: 'payment_amount_original_cents')
  int get paymentAmountCents;
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId;
  @JsonKey(name: 'refund_amount_cents')
  int get refundAmountCents;
  @JsonKey(name: 'refund_charge_id')
  String get refundChargeId;
  @JsonKey(name: 'refund_id')
  String get refundId;
  @JsonKey(name: 'refund_initiator')
  String get refundInitiator;
  @JsonKey(name: 'service_id')
  String get serviceId;
  @JsonKey(name: 'service_name')
  String get serviceName;
  @JsonKey(name: 'transfer_reversal')
  String get transferReversal;
  @JsonKey(name: 'vendor_business_name')
  String get vendorBusinessName;
  @JsonKey(name: 'vendor_user_id')
  String get vendorUserId;

  /// Create a copy of StripeRefund
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StripeRefundCopyWith<StripeRefund> get copyWith =>
      _$StripeRefundCopyWithImpl<StripeRefund>(
          this as StripeRefund, _$identity);

  /// Serializes this StripeRefund to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StripeRefund &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.paymentAmountCents, paymentAmountCents) ||
                other.paymentAmountCents == paymentAmountCents) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.refundAmountCents, refundAmountCents) ||
                other.refundAmountCents == refundAmountCents) &&
            (identical(other.refundChargeId, refundChargeId) ||
                other.refundChargeId == refundChargeId) &&
            (identical(other.refundId, refundId) ||
                other.refundId == refundId) &&
            (identical(other.refundInitiator, refundInitiator) ||
                other.refundInitiator == refundInitiator) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.transferReversal, transferReversal) ||
                other.transferReversal == transferReversal) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookingId,
      clientUserId,
      createTime,
      paymentAmountCents,
      paymentIntentId,
      refundAmountCents,
      refundChargeId,
      refundId,
      refundInitiator,
      serviceId,
      serviceName,
      transferReversal,
      vendorBusinessName,
      vendorUserId);

  @override
  String toString() {
    return 'StripeRefund(bookingId: $bookingId, clientUserId: $clientUserId, createTime: $createTime, paymentAmountCents: $paymentAmountCents, paymentIntentId: $paymentIntentId, refundAmountCents: $refundAmountCents, refundChargeId: $refundChargeId, refundId: $refundId, refundInitiator: $refundInitiator, serviceId: $serviceId, serviceName: $serviceName, transferReversal: $transferReversal, vendorBusinessName: $vendorBusinessName, vendorUserId: $vendorUserId)';
  }
}

/// @nodoc
abstract mixin class $StripeRefundCopyWith<$Res> {
  factory $StripeRefundCopyWith(
          StripeRefund value, $Res Function(StripeRefund) _then) =
      _$StripeRefundCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'client_user_id') String clientUserId,
      @JsonKey(name: 'createTime') DateTime createTime,
      @JsonKey(name: 'payment_amount_original_cents') int paymentAmountCents,
      @JsonKey(name: 'payment_intent_id') String paymentIntentId,
      @JsonKey(name: 'refund_amount_cents') int refundAmountCents,
      @JsonKey(name: 'refund_charge_id') String refundChargeId,
      @JsonKey(name: 'refund_id') String refundId,
      @JsonKey(name: 'refund_initiator') String refundInitiator,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'service_name') String serviceName,
      @JsonKey(name: 'transfer_reversal') String transferReversal,
      @JsonKey(name: 'vendor_business_name') String vendorBusinessName,
      @JsonKey(name: 'vendor_user_id') String vendorUserId});
}

/// @nodoc
class _$StripeRefundCopyWithImpl<$Res> implements $StripeRefundCopyWith<$Res> {
  _$StripeRefundCopyWithImpl(this._self, this._then);

  final StripeRefund _self;
  final $Res Function(StripeRefund) _then;

  /// Create a copy of StripeRefund
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? clientUserId = null,
    Object? createTime = null,
    Object? paymentAmountCents = null,
    Object? paymentIntentId = null,
    Object? refundAmountCents = null,
    Object? refundChargeId = null,
    Object? refundId = null,
    Object? refundInitiator = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? transferReversal = null,
    Object? vendorBusinessName = null,
    Object? vendorUserId = null,
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
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentAmountCents: null == paymentAmountCents
          ? _self.paymentAmountCents
          : paymentAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      paymentIntentId: null == paymentIntentId
          ? _self.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      refundAmountCents: null == refundAmountCents
          ? _self.refundAmountCents
          : refundAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      refundChargeId: null == refundChargeId
          ? _self.refundChargeId
          : refundChargeId // ignore: cast_nullable_to_non_nullable
              as String,
      refundId: null == refundId
          ? _self.refundId
          : refundId // ignore: cast_nullable_to_non_nullable
              as String,
      refundInitiator: null == refundInitiator
          ? _self.refundInitiator
          : refundInitiator // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      transferReversal: null == transferReversal
          ? _self.transferReversal
          : transferReversal // ignore: cast_nullable_to_non_nullable
              as String,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _StripeRefund implements StripeRefund {
  const _StripeRefund(
      {@JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'client_user_id') required this.clientUserId,
      @JsonKey(name: 'createTime') required this.createTime,
      @JsonKey(name: 'payment_amount_original_cents')
      required this.paymentAmountCents,
      @JsonKey(name: 'payment_intent_id') required this.paymentIntentId,
      @JsonKey(name: 'refund_amount_cents') required this.refundAmountCents,
      @JsonKey(name: 'refund_charge_id') required this.refundChargeId,
      @JsonKey(name: 'refund_id') required this.refundId,
      @JsonKey(name: 'refund_initiator') required this.refundInitiator,
      @JsonKey(name: 'service_id') required this.serviceId,
      @JsonKey(name: 'service_name') required this.serviceName,
      @JsonKey(name: 'transfer_reversal') required this.transferReversal,
      @JsonKey(name: 'vendor_business_name') required this.vendorBusinessName,
      @JsonKey(name: 'vendor_user_id') required this.vendorUserId});
  factory _StripeRefund.fromJson(Map<String, dynamic> json) =>
      _$StripeRefundFromJson(json);

  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'client_user_id')
  final String clientUserId;
  @override
  @JsonKey(name: 'createTime')
  final DateTime createTime;
  @override
  @JsonKey(name: 'payment_amount_original_cents')
  final int paymentAmountCents;
  @override
  @JsonKey(name: 'payment_intent_id')
  final String paymentIntentId;
  @override
  @JsonKey(name: 'refund_amount_cents')
  final int refundAmountCents;
  @override
  @JsonKey(name: 'refund_charge_id')
  final String refundChargeId;
  @override
  @JsonKey(name: 'refund_id')
  final String refundId;
  @override
  @JsonKey(name: 'refund_initiator')
  final String refundInitiator;
  @override
  @JsonKey(name: 'service_id')
  final String serviceId;
  @override
  @JsonKey(name: 'service_name')
  final String serviceName;
  @override
  @JsonKey(name: 'transfer_reversal')
  final String transferReversal;
  @override
  @JsonKey(name: 'vendor_business_name')
  final String vendorBusinessName;
  @override
  @JsonKey(name: 'vendor_user_id')
  final String vendorUserId;

  /// Create a copy of StripeRefund
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StripeRefundCopyWith<_StripeRefund> get copyWith =>
      __$StripeRefundCopyWithImpl<_StripeRefund>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StripeRefundToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StripeRefund &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.paymentAmountCents, paymentAmountCents) ||
                other.paymentAmountCents == paymentAmountCents) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.refundAmountCents, refundAmountCents) ||
                other.refundAmountCents == refundAmountCents) &&
            (identical(other.refundChargeId, refundChargeId) ||
                other.refundChargeId == refundChargeId) &&
            (identical(other.refundId, refundId) ||
                other.refundId == refundId) &&
            (identical(other.refundInitiator, refundInitiator) ||
                other.refundInitiator == refundInitiator) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.transferReversal, transferReversal) ||
                other.transferReversal == transferReversal) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookingId,
      clientUserId,
      createTime,
      paymentAmountCents,
      paymentIntentId,
      refundAmountCents,
      refundChargeId,
      refundId,
      refundInitiator,
      serviceId,
      serviceName,
      transferReversal,
      vendorBusinessName,
      vendorUserId);

  @override
  String toString() {
    return 'StripeRefund(bookingId: $bookingId, clientUserId: $clientUserId, createTime: $createTime, paymentAmountCents: $paymentAmountCents, paymentIntentId: $paymentIntentId, refundAmountCents: $refundAmountCents, refundChargeId: $refundChargeId, refundId: $refundId, refundInitiator: $refundInitiator, serviceId: $serviceId, serviceName: $serviceName, transferReversal: $transferReversal, vendorBusinessName: $vendorBusinessName, vendorUserId: $vendorUserId)';
  }
}

/// @nodoc
abstract mixin class _$StripeRefundCopyWith<$Res>
    implements $StripeRefundCopyWith<$Res> {
  factory _$StripeRefundCopyWith(
          _StripeRefund value, $Res Function(_StripeRefund) _then) =
      __$StripeRefundCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'client_user_id') String clientUserId,
      @JsonKey(name: 'createTime') DateTime createTime,
      @JsonKey(name: 'payment_amount_original_cents') int paymentAmountCents,
      @JsonKey(name: 'payment_intent_id') String paymentIntentId,
      @JsonKey(name: 'refund_amount_cents') int refundAmountCents,
      @JsonKey(name: 'refund_charge_id') String refundChargeId,
      @JsonKey(name: 'refund_id') String refundId,
      @JsonKey(name: 'refund_initiator') String refundInitiator,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'service_name') String serviceName,
      @JsonKey(name: 'transfer_reversal') String transferReversal,
      @JsonKey(name: 'vendor_business_name') String vendorBusinessName,
      @JsonKey(name: 'vendor_user_id') String vendorUserId});
}

/// @nodoc
class __$StripeRefundCopyWithImpl<$Res>
    implements _$StripeRefundCopyWith<$Res> {
  __$StripeRefundCopyWithImpl(this._self, this._then);

  final _StripeRefund _self;
  final $Res Function(_StripeRefund) _then;

  /// Create a copy of StripeRefund
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bookingId = null,
    Object? clientUserId = null,
    Object? createTime = null,
    Object? paymentAmountCents = null,
    Object? paymentIntentId = null,
    Object? refundAmountCents = null,
    Object? refundChargeId = null,
    Object? refundId = null,
    Object? refundInitiator = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? transferReversal = null,
    Object? vendorBusinessName = null,
    Object? vendorUserId = null,
  }) {
    return _then(_StripeRefund(
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserId: null == clientUserId
          ? _self.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentAmountCents: null == paymentAmountCents
          ? _self.paymentAmountCents
          : paymentAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      paymentIntentId: null == paymentIntentId
          ? _self.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      refundAmountCents: null == refundAmountCents
          ? _self.refundAmountCents
          : refundAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      refundChargeId: null == refundChargeId
          ? _self.refundChargeId
          : refundChargeId // ignore: cast_nullable_to_non_nullable
              as String,
      refundId: null == refundId
          ? _self.refundId
          : refundId // ignore: cast_nullable_to_non_nullable
              as String,
      refundInitiator: null == refundInitiator
          ? _self.refundInitiator
          : refundInitiator // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      transferReversal: null == transferReversal
          ? _self.transferReversal
          : transferReversal // ignore: cast_nullable_to_non_nullable
              as String,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
