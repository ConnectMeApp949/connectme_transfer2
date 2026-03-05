// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripeReceipt {
  @JsonKey(name: 'createTime')
  DateTime get createTime;
  @JsonKey(name: 'client_stripe_customer_id')
  String get clientStripeCustomerId;
  @JsonKey(name: 'client_payment_method_id')
  String get clientPaymentMethodId;
  @JsonKey(name: 'client_user_id')
  String get clientUserId;
  @JsonKey(name: 'vendor_stripe_account_id')
  String get vendorStripeAccountId;
  @JsonKey(name: 'vendor_user_id')
  String get vendorUserId;
  @JsonKey(name: 'payment_amount_cents')
  int get paymentAmountCents;
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId;
  @JsonKey(name: 'service_id')
  String get serviceId;
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @JsonKey(name: 'service_name')
  String get serviceName;
  @JsonKey(name: 'vendor_business_name')
  String get vendorBusinessName;

  /// Create a copy of StripeReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StripeReceiptCopyWith<StripeReceipt> get copyWith =>
      _$StripeReceiptCopyWithImpl<StripeReceipt>(
          this as StripeReceipt, _$identity);

  /// Serializes this StripeReceipt to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StripeReceipt &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.clientStripeCustomerId, clientStripeCustomerId) ||
                other.clientStripeCustomerId == clientStripeCustomerId) &&
            (identical(other.clientPaymentMethodId, clientPaymentMethodId) ||
                other.clientPaymentMethodId == clientPaymentMethodId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.vendorStripeAccountId, vendorStripeAccountId) ||
                other.vendorStripeAccountId == vendorStripeAccountId) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.paymentAmountCents, paymentAmountCents) ||
                other.paymentAmountCents == paymentAmountCents) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      createTime,
      clientStripeCustomerId,
      clientPaymentMethodId,
      clientUserId,
      vendorStripeAccountId,
      vendorUserId,
      paymentAmountCents,
      paymentIntentId,
      serviceId,
      bookingId,
      serviceName,
      vendorBusinessName);

  @override
  String toString() {
    return 'StripeReceipt(createTime: $createTime, clientStripeCustomerId: $clientStripeCustomerId, clientPaymentMethodId: $clientPaymentMethodId, clientUserId: $clientUserId, vendorStripeAccountId: $vendorStripeAccountId, vendorUserId: $vendorUserId, paymentAmountCents: $paymentAmountCents, paymentIntentId: $paymentIntentId, serviceId: $serviceId, bookingId: $bookingId, serviceName: $serviceName, vendorBusinessName: $vendorBusinessName)';
  }
}

/// @nodoc
abstract mixin class $StripeReceiptCopyWith<$Res> {
  factory $StripeReceiptCopyWith(
          StripeReceipt value, $Res Function(StripeReceipt) _then) =
      _$StripeReceiptCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'createTime') DateTime createTime,
      @JsonKey(name: 'client_stripe_customer_id') String clientStripeCustomerId,
      @JsonKey(name: 'client_payment_method_id') String clientPaymentMethodId,
      @JsonKey(name: 'client_user_id') String clientUserId,
      @JsonKey(name: 'vendor_stripe_account_id') String vendorStripeAccountId,
      @JsonKey(name: 'vendor_user_id') String vendorUserId,
      @JsonKey(name: 'payment_amount_cents') int paymentAmountCents,
      @JsonKey(name: 'payment_intent_id') String paymentIntentId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'service_name') String serviceName,
      @JsonKey(name: 'vendor_business_name') String vendorBusinessName});
}

/// @nodoc
class _$StripeReceiptCopyWithImpl<$Res>
    implements $StripeReceiptCopyWith<$Res> {
  _$StripeReceiptCopyWithImpl(this._self, this._then);

  final StripeReceipt _self;
  final $Res Function(StripeReceipt) _then;

  /// Create a copy of StripeReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createTime = null,
    Object? clientStripeCustomerId = null,
    Object? clientPaymentMethodId = null,
    Object? clientUserId = null,
    Object? vendorStripeAccountId = null,
    Object? vendorUserId = null,
    Object? paymentAmountCents = null,
    Object? paymentIntentId = null,
    Object? serviceId = null,
    Object? bookingId = null,
    Object? serviceName = null,
    Object? vendorBusinessName = null,
  }) {
    return _then(_self.copyWith(
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      clientStripeCustomerId: null == clientStripeCustomerId
          ? _self.clientStripeCustomerId
          : clientStripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String,
      clientPaymentMethodId: null == clientPaymentMethodId
          ? _self.clientPaymentMethodId
          : clientPaymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserId: null == clientUserId
          ? _self.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorStripeAccountId: null == vendorStripeAccountId
          ? _self.vendorStripeAccountId
          : vendorStripeAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentAmountCents: null == paymentAmountCents
          ? _self.paymentAmountCents
          : paymentAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      paymentIntentId: null == paymentIntentId
          ? _self.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _StripeReceipt implements StripeReceipt {
  const _StripeReceipt(
      {@JsonKey(name: 'createTime') required this.createTime,
      @JsonKey(name: 'client_stripe_customer_id')
      required this.clientStripeCustomerId,
      @JsonKey(name: 'client_payment_method_id')
      required this.clientPaymentMethodId,
      @JsonKey(name: 'client_user_id') required this.clientUserId,
      @JsonKey(name: 'vendor_stripe_account_id')
      required this.vendorStripeAccountId,
      @JsonKey(name: 'vendor_user_id') required this.vendorUserId,
      @JsonKey(name: 'payment_amount_cents') required this.paymentAmountCents,
      @JsonKey(name: 'payment_intent_id') required this.paymentIntentId,
      @JsonKey(name: 'service_id') required this.serviceId,
      @JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'service_name') required this.serviceName,
      @JsonKey(name: 'vendor_business_name') required this.vendorBusinessName});
  factory _StripeReceipt.fromJson(Map<String, dynamic> json) =>
      _$StripeReceiptFromJson(json);

  @override
  @JsonKey(name: 'createTime')
  final DateTime createTime;
  @override
  @JsonKey(name: 'client_stripe_customer_id')
  final String clientStripeCustomerId;
  @override
  @JsonKey(name: 'client_payment_method_id')
  final String clientPaymentMethodId;
  @override
  @JsonKey(name: 'client_user_id')
  final String clientUserId;
  @override
  @JsonKey(name: 'vendor_stripe_account_id')
  final String vendorStripeAccountId;
  @override
  @JsonKey(name: 'vendor_user_id')
  final String vendorUserId;
  @override
  @JsonKey(name: 'payment_amount_cents')
  final int paymentAmountCents;
  @override
  @JsonKey(name: 'payment_intent_id')
  final String paymentIntentId;
  @override
  @JsonKey(name: 'service_id')
  final String serviceId;
  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'service_name')
  final String serviceName;
  @override
  @JsonKey(name: 'vendor_business_name')
  final String vendorBusinessName;

  /// Create a copy of StripeReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StripeReceiptCopyWith<_StripeReceipt> get copyWith =>
      __$StripeReceiptCopyWithImpl<_StripeReceipt>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StripeReceiptToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StripeReceipt &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.clientStripeCustomerId, clientStripeCustomerId) ||
                other.clientStripeCustomerId == clientStripeCustomerId) &&
            (identical(other.clientPaymentMethodId, clientPaymentMethodId) ||
                other.clientPaymentMethodId == clientPaymentMethodId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.vendorStripeAccountId, vendorStripeAccountId) ||
                other.vendorStripeAccountId == vendorStripeAccountId) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.paymentAmountCents, paymentAmountCents) ||
                other.paymentAmountCents == paymentAmountCents) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      createTime,
      clientStripeCustomerId,
      clientPaymentMethodId,
      clientUserId,
      vendorStripeAccountId,
      vendorUserId,
      paymentAmountCents,
      paymentIntentId,
      serviceId,
      bookingId,
      serviceName,
      vendorBusinessName);

  @override
  String toString() {
    return 'StripeReceipt(createTime: $createTime, clientStripeCustomerId: $clientStripeCustomerId, clientPaymentMethodId: $clientPaymentMethodId, clientUserId: $clientUserId, vendorStripeAccountId: $vendorStripeAccountId, vendorUserId: $vendorUserId, paymentAmountCents: $paymentAmountCents, paymentIntentId: $paymentIntentId, serviceId: $serviceId, bookingId: $bookingId, serviceName: $serviceName, vendorBusinessName: $vendorBusinessName)';
  }
}

/// @nodoc
abstract mixin class _$StripeReceiptCopyWith<$Res>
    implements $StripeReceiptCopyWith<$Res> {
  factory _$StripeReceiptCopyWith(
          _StripeReceipt value, $Res Function(_StripeReceipt) _then) =
      __$StripeReceiptCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'createTime') DateTime createTime,
      @JsonKey(name: 'client_stripe_customer_id') String clientStripeCustomerId,
      @JsonKey(name: 'client_payment_method_id') String clientPaymentMethodId,
      @JsonKey(name: 'client_user_id') String clientUserId,
      @JsonKey(name: 'vendor_stripe_account_id') String vendorStripeAccountId,
      @JsonKey(name: 'vendor_user_id') String vendorUserId,
      @JsonKey(name: 'payment_amount_cents') int paymentAmountCents,
      @JsonKey(name: 'payment_intent_id') String paymentIntentId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'service_name') String serviceName,
      @JsonKey(name: 'vendor_business_name') String vendorBusinessName});
}

/// @nodoc
class __$StripeReceiptCopyWithImpl<$Res>
    implements _$StripeReceiptCopyWith<$Res> {
  __$StripeReceiptCopyWithImpl(this._self, this._then);

  final _StripeReceipt _self;
  final $Res Function(_StripeReceipt) _then;

  /// Create a copy of StripeReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? createTime = null,
    Object? clientStripeCustomerId = null,
    Object? clientPaymentMethodId = null,
    Object? clientUserId = null,
    Object? vendorStripeAccountId = null,
    Object? vendorUserId = null,
    Object? paymentAmountCents = null,
    Object? paymentIntentId = null,
    Object? serviceId = null,
    Object? bookingId = null,
    Object? serviceName = null,
    Object? vendorBusinessName = null,
  }) {
    return _then(_StripeReceipt(
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      clientStripeCustomerId: null == clientStripeCustomerId
          ? _self.clientStripeCustomerId
          : clientStripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String,
      clientPaymentMethodId: null == clientPaymentMethodId
          ? _self.clientPaymentMethodId
          : clientPaymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserId: null == clientUserId
          ? _self.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorStripeAccountId: null == vendorStripeAccountId
          ? _self.vendorStripeAccountId
          : vendorStripeAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentAmountCents: null == paymentAmountCents
          ? _self.paymentAmountCents
          : paymentAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      paymentIntentId: null == paymentIntentId
          ? _self.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
