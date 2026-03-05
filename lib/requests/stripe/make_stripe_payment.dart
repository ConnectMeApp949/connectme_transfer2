// import 'dart:async';
// import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
// import 'package:connectme_app/config/globals.dart';
// import 'package:connectme_app/providers/auth.dart';
// import 'package:connectme_app/requests/urls.dart';
// import 'package:connectme_app/util/screen_util.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';


// Future getTransactionDetails(
//     String clientUserId,
//     String clientAuthToken,
//     String vendorUserId
//     )async{
//   final response = await http.post(
//       Uri.parse(get_transaction_details_url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "userId": clientUserId,
//         "authToken": clientAuthToken,
//         "client_user_id": clientUserId,
//         "vendor_user_id": vendorUserId
//       })
//   );
//
//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   }
//   else if (response.statusCode == 404){ /// expect on not set up yet
//     return json.decode(response.body);
//   }
//   else {
//     return {"error": "error getting account status"};
//   }
//
// }

// client_user_id = data.get("client_user_id")
// client_stripe_customer_id = data.get("client_stripe_customer_id")
// client_payment_method_id = data.get("client_payment_method_id")
//
// vendor_stripe_account_id = data.get("vendor_stripe_account_id")
// vendor_user_id = data.get("vendor_user_id")
// payment_amount_cents = data.get("payment_amount_cents")
// Future makeStripePayment(
//     String clientUserId,
//     String clientAuthToken,
//     String clientStripeCustomerId,
//     String clientPaymentMethodId,
//     String vendorStripeAccountId,
//     String vendorUserId,
//     int paymentAmountCents,
//     String serviceId,
//     String createBookingId,
//     String serviceName,
//     String vendorBusinessName,
//
//     ) async {
//   final response = await http.post(
//     Uri.parse(make_client_stripe_payment_url),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'userId': clientUserId,
//       'authToken': clientAuthToken,
//       'client_user_id': clientUserId,
//       'client_stripe_customer_id': clientStripeCustomerId,
//       'client_payment_method_id': clientPaymentMethodId,
//       'vendor_stripe_account_id': vendorStripeAccountId,
//       'vendor_user_id': vendorUserId,
//       'payment_amount_cents': paymentAmountCents,
//       'service_id': serviceId,
//       "booking_id": createBookingId,
//       "service_name": serviceName,
//       "vendor_business_name": vendorBusinessName,
//     }),
//   );
//
//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   }
//   else if (response.statusCode == 404){ /// expect on not set up yet
//     return json.decode(response.body);
//   }
//   else {
//     return {"error": "error getting account status"};
//   }
// }