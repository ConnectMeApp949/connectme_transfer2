

// import 'dart:convert';
//
// import 'package:connectme_app/config/settings.dart';
// import 'package:http/http.dart' as http;
//
// import '../urls.dart';

// Future<void> logLoginTrackMeta() async {
//
//   try {
//     final response = await http.post(
//       Uri.parse(user_login_track_meta),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'action': 'login',
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       print("Logged IP login successfully: ${response.body}");
//     } else {
//       print("Failed to log login: ${response.body}");
//     }
//   } catch (e) {
//     print("Error logging login: $e");
//   }
// }