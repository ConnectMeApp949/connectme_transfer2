// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_refund.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripeRefund _$StripeRefundFromJson(Map<String, dynamic> json) =>
    _StripeRefund(
      bookingId: json['booking_id'] as String,
      clientUserId: json['client_user_id'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      paymentAmountCents:
          (json['payment_amount_original_cents'] as num).toInt(),
      paymentIntentId: json['payment_intent_id'] as String,
      refundAmountCents: (json['refund_amount_cents'] as num).toInt(),
      refundChargeId: json['refund_charge_id'] as String,
      refundId: json['refund_id'] as String,
      refundInitiator: json['refund_initiator'] as String,
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String,
      transferReversal: json['transfer_reversal'] as String,
      vendorBusinessName: json['vendor_business_name'] as String,
      vendorUserId: json['vendor_user_id'] as String,
    );

Map<String, dynamic> _$StripeRefundToJson(_StripeRefund instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'client_user_id': instance.clientUserId,
      'createTime': instance.createTime.toIso8601String(),
      'payment_amount_original_cents': instance.paymentAmountCents,
      'payment_intent_id': instance.paymentIntentId,
      'refund_amount_cents': instance.refundAmountCents,
      'refund_charge_id': instance.refundChargeId,
      'refund_id': instance.refundId,
      'refund_initiator': instance.refundInitiator,
      'service_id': instance.serviceId,
      'service_name': instance.serviceName,
      'transfer_reversal': instance.transferReversal,
      'vendor_business_name': instance.vendorBusinessName,
      'vendor_user_id': instance.vendorUserId,
    };
