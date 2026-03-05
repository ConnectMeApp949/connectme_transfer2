// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripeReceipt _$StripeReceiptFromJson(Map<String, dynamic> json) =>
    _StripeReceipt(
      createTime: DateTime.parse(json['createTime'] as String),
      clientStripeCustomerId: json['client_stripe_customer_id'] as String,
      clientPaymentMethodId: json['client_payment_method_id'] as String,
      clientUserId: json['client_user_id'] as String,
      vendorStripeAccountId: json['vendor_stripe_account_id'] as String,
      vendorUserId: json['vendor_user_id'] as String,
      paymentAmountCents: (json['payment_amount_cents'] as num).toInt(),
      paymentIntentId: json['payment_intent_id'] as String,
      serviceId: json['service_id'] as String,
      bookingId: json['booking_id'] as String,
      serviceName: json['service_name'] as String,
      vendorBusinessName: json['vendor_business_name'] as String,
    );

Map<String, dynamic> _$StripeReceiptToJson(_StripeReceipt instance) =>
    <String, dynamic>{
      'createTime': instance.createTime.toIso8601String(),
      'client_stripe_customer_id': instance.clientStripeCustomerId,
      'client_payment_method_id': instance.clientPaymentMethodId,
      'client_user_id': instance.clientUserId,
      'vendor_stripe_account_id': instance.vendorStripeAccountId,
      'vendor_user_id': instance.vendorUserId,
      'payment_amount_cents': instance.paymentAmountCents,
      'payment_intent_id': instance.paymentIntentId,
      'service_id': instance.serviceId,
      'booking_id': instance.bookingId,
      'service_name': instance.serviceName,
      'vendor_business_name': instance.vendorBusinessName,
    };
