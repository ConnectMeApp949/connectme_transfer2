
import 'dart:async';

import 'package:connectme_app/components/calendar_view_fork/src/calendar_controller_provider.dart';
import 'package:connectme_app/components/calendar_view_fork/src/calendar_event_data.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/views/client_app/bookings/bookings_tab.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:connectme_app/models/bookings/booking.dart';
import 'dart:convert';

// enum BookingOwnerType{
//   client,
//   vendor
// }


Future fetchBookingById(
    String userToken,
    String userId,
    String bookingId
    ) async {
  lg.d("[fetchBookingById] called");

    try {
      Map pdata = {
        'userId': userId,
        "authToken": userToken,
        "bookingId": bookingId
      };

      lg.t("fetchBookingById calling pdata ~ " + pdata.toString());

      final response = await http.post(Uri.parse(get_booking_by_id_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pdata),
      );

      if (response.statusCode == 200) {
        lg.t("fetchBookingById response body ~ " + response.body.toString());
        return Booking.fromJson(jsonDecode(response.body)["bookings"][0]);
      } else {
        lg.e("[fetchBookingById] not 200 probably booking not found");
      }
    }
    catch(e){
      lg.e("[fetchBookingById] error caught");
      lg.e("Exp ~ " + e.toString());
      }
    }


Future fetchBookings(
    String userToken,
    String userId,
    String ownerType,
    DateTime lastBookingTime,
    BookingTimeType upcomingOrPast) async {
  lg.d("[fetchBookings] called");

  final lastBookingTimeStr = lastBookingTime.toUtc().toIso8601String();

  Map pdata = {
    "userId": userId,
    "authToken": userToken,
    "lastBookingTime": lastBookingTimeStr,
    "ownerType": ownerType,
    "upcomingOrPast": upcomingOrPast.name,
  };

  lg.t("fetchBookings calling pdata ~ " + pdata.toString());

  final response = await http.post(Uri.parse(bookings_url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(pdata),
  );

  if (response.statusCode == 200) {
    lg.t("fetchBookings response body ~ " + response.body.toString());
    final List data = jsonDecode(response.body)["bookings"];
    return data.map((e) => Booking.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load');
  // return {"success":false};
  }
}


Future fetchBookingsForCalendar(
    String userToken,
    String userId,
    String ownerType,
    DateTime startDate,
    DateTime endDate,
    ) async {
  lg.d("[fetchBookingsForCalendar] called");

  final startDateStr = startDate.toUtc().toIso8601String();
  final endDateStr = endDate.toUtc().toIso8601String();

  Map pdata = {
    "userId": userId,
    "authToken": userToken,
    "ownerType": ownerType,
    "startDate" : startDateStr,
    "endDate": endDateStr,
  };

  lg.t("fetchBookingsForCalendar calling url ~ " + bookings_url);
  lg.t("fetchBookingsForCalendar calling pdata ~ " + pdata.toString());

  final response = await http.post(Uri.parse(bookings_url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(pdata),
  );

  if (response.statusCode == 200) {
    lg.t("fetchBookingsForCalendar response body ~ " + response.body.toString());
    final List data = jsonDecode(response.body)["bookings"];
    // debugPrint("fetchBookings data ~ " + data.toString());
    return data.map((e) => Booking.fromJson(e)).toList();
  } else {
    lg.e("fetchBookingsForCalendar error ~ " + response.body.toString());
    throw Exception('Failed to load');
  }
}

updateCalendarEventsItems(BuildContext context, WidgetRef ref, DateTime fetchDate, UserType userType){

  DateTime firstDayOfMonth = DateTime(fetchDate.year, fetchDate.month, 1);
  DateTime lastDayOfMonth = DateTime(fetchDate.year, fetchDate.month + 1, 0);

  scheduleMicrotask(() async {
    try{
      var resp = await fetchBookingsForCalendar(ref.watch(userAuthProv)!.userToken,ref.watch(userAuthProv)!.userId,
          userType.name, firstDayOfMonth, lastDayOfMonth);

      /// for no time limit events make 15 for calendar view only hopefully

      List<CalendarEventData> convBookingsToCalendarEvents = resp
          .where((bi) => bi.status == "confirmed")
          .map<CalendarEventData>((Booking bi){

        DateTime conditional_endTime =bi.bookingTime.toLocal().add(Duration(minutes: bi.timeLength));
            if (bi.timeLength == 0 ){
          conditional_endTime = bi.bookingTime.toLocal().add(Duration(minutes: 15));
        }
        return CalendarEventData(
          booking: bi,
          date:bi.bookingTime.toLocal(),
          title: bi.serviceName,
          description: bi.serviceName,
          startTime: bi.bookingTime.toLocal(),
          endTime: conditional_endTime,
        ) ;}).toList();

      CalendarControllerProvider
          .of(gNavigatorKey.currentContext!)
          .controller
          .addAll(convBookingsToCalendarEvents);
    }catch(e){
      lg.e("error fetching calnedar bookings");
      showErrorDialog(gNavigatorKey.currentContext!, default_error_message);
    }

  });
}