// import 'dart:html' as html;
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:googleapis_auth/auth_browser.dart';
// import 'package:http/http.dart' as http;
//
// final clientId = ClientId(
//   'YOUR_CLIENT_ID.apps.googleusercontent.com',
//   '',
// );
//
// final scopes = [calendar.CalendarApi.calendarScope];
//
// void loginAndFetchCalendars() {
//   createImplicitBrowserFlow(clientId, scopes).then((flow) {
//     flow.clientViaUserConsent().then((AutoRefreshingAuthClient client) async {
//       final calendarApi = calendar.CalendarApi(client);
//       var calendarList = await calendarApi.calendarList.list();
//       for (var entry in calendarList.items ?? []) {
//         print('Calendar: ${entry.summary}');
//       }
//       client.close();
//     });
//   });
// }