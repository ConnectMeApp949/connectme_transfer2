
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// This is basically a payment request, important that userId is authenticated
Future cancelBooking(
    String userToken,
    String userId,
    String userType,
    String bookingId,
    ) async {
  lg.d("[cancelBooking] called");

  Map pdata = {};

  pdata = {
    'userId': userId,
    "authToken": userToken,
    "userType": userType,
    "bookingId": bookingId,
  };

  final response = await http.post(Uri.parse(cancel_booking_url),
    headers: {'Content-Type': 'application/json'
    },
    body: json.encode(pdata),
  );

  lg.t("cancel response ~ " + jsonDecode(response.body).toString());
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    lg.e("error cancel booking ~ " + jsonDecode(response.body).toString());
    // throw Exception('Failed to load');
    return jsonDecode(response.body);
  }
}