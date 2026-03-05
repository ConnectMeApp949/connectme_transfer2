import 'dart:async';
import 'package:connectme_app/providers/stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectme_app/requests/urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Future getStripeClientAccountStatus(WidgetRef ref, String userToken, String clientUserId) async {
  final response = await http.post(
    Uri.parse(get_stripe_client_setup_status_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': clientUserId,
      "authToken": userToken,
      // 'client_user_id': clientUserId // cannot do, need auth by userId
    }),
  );

  if (response.statusCode == 200) {
    var dec_resp = json.decode(response.body);
    ref.read(stripeCustomerIdProv.notifier).state = dec_resp["stripe_customer_id"];
    return dec_resp;
  }
  else if (response.statusCode == 404){ /// expect on not set up yet
    return json.decode(response.body);
  }
  else {
    return {"error": "error getting account status"};
  }
}