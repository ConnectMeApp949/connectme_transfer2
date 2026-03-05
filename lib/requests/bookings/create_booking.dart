
import 'package:connectme_app/models/services/services.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// This is basically a payment request, important that userId is authenticated
Future createBooking(
    String userToken,
    String? address, /// null for remote
    ServiceOffered service,
    DateTime bookingTime,
    String clientUserId,
    String clientUserName,
    String createBookingId,
    ) async {
  lg.d("[createBooking] called");

  Map pdata = {};

  pdata = {
        'userId': clientUserId,
        "authToken": userToken,
        "address": address,
        "bookingTime": bookingTime.toIso8601String(),
        "bookingId": createBookingId,
        // "clientUserId": clientUserId,
        "clientUserName": clientUserName,
        "priceCents": service.priceCents,
        "serviceId": service.serviceId,
        "serviceName": service.name,
        "site": service.site,
        "timeLength": service.timeLength ?? 720,
        "vendorBusinessName": service.vendorBusinessName,
        "vendorUserId": service.vendorUserId,
        "vendorUserName": service.vendorUserName
  };

  lg.t("createBooking with pdata ~ " + pdata.toString());

  final response = await http.post(Uri.parse(create_booking_url),
    headers: {'Content-Type': 'application/json'
    },
    body: json.encode(pdata),
  );

  if (response.statusCode == 200) {
    // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
    // final List data = jsonDecode(response.body)["services"];
    // return data.map((e) => ServiceOffered.fromJson(e)).toList();
    return jsonDecode(response.body);
  } else {
    // throw Exception('Failed to load');
    return {"success":false};
  }
}