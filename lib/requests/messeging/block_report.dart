import 'dart:async';

import 'package:connectme_app/requests/urls.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/logger.dart';

Future blockUser(
    String userToken,
    String userId,
    String threadId,
    String otherUserID,
    String blockAction

    ) async {
  final uri = Uri.parse(block_message_thread_url);

  Map pdata = {
    'authToken': userToken,
    'userId': userId,
    'threadId': threadId,
    'blockAction': blockAction,
    'otherUserID': otherUserID,
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(pdata),
  );

  if (response.statusCode != 200) {
    lg.e(jsonDecode(response.body).toString());
    return {"success":false};
    // throw Exception('Failed to load threads');
  }
  return jsonDecode(response.body);
}


Future reportUser(
    String userToken,
    String userId,
    String threadId,
    String otherUserID,
    String reportMessage

    ) async {
  final uri = Uri.parse(report_message_user_url);

  Map pdata = {
    'authToken': userToken,
    'userId': userId,
    'threadId': threadId,
    'otherUserId': otherUserID,
    'reportMessage': reportMessage,
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(pdata),
  );

  if (response.statusCode != 200) {
    lg.e(jsonDecode(response.body).toString());
    // throw Exception('Failed to load threads');
    return {"success":false};
  }
  return jsonDecode(response.body);
}

