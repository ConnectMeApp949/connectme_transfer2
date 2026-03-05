import 'dart:convert';
import 'package:connectme_app/models/messeging/message.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/messaging.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/views/messaging/chat_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:connectme_app/config/logger.dart';

Future<List<Message>> fetchMessagesForThread(
    WidgetRef ref,{
      required String threadId,
      DateTime? startAfter,
      int limit = 10,
    }) async {
  final uri = Uri.parse(get_messages_url);

  String  pbody = jsonEncode({
    'userId': ref.read(userAuthProv)!.userId,
    "authToken": ref.read(userAuthProv)!.userToken,
    'threadId': threadId,
    'limit': limit,
    if (startAfter != null) 'startAfter': startAfter.toIso8601String(),
  });

  // lg.t("post body ~ " + pbody);

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: pbody,
  );


  if (response.statusCode != 200) {
    lg.e(json.decode(response.body).toString());
    return [];
  }

  final List<dynamic> data = jsonDecode(response.body);

  List<DisplayMessage> displayMessageData = [];
  for (var message in data) {
    displayMessageData.add(DisplayMessage(
        message['messageId'],
        message['text'],
        DateTime.parse(message['timestamp']),
        message['senderName']
        ));
  }
  ref.read(messagesProvider.notifier).addOldMessages(displayMessageData);
  return data.map((e) => Message.fromJson(e)).toList();
}

Future<List<Message>> pollMessagesForThread(
    WidgetRef ref,{
      required String threadId,
      DateTime? startBefore,
      int limit = 10,
    }) async {
  final uri = Uri.parse(get_messages_url);

  String  pbody = jsonEncode({
    'userId': ref.read(userAuthProv)!.userId,
    "authToken": ref.read(userAuthProv)!.userToken,
    'threadId': threadId,
    'limit': limit,
    if (startBefore != null) 'startBefore': startBefore.toIso8601String(),
  });

  // lg.t("[pollMessagesForThread] post body ~ " + pbody);

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: pbody,
  );


  if (response.statusCode != 200) {
    lg.e(json.decode(response.body).toString());
    return [];
  }

  final List<dynamic> data = jsonDecode(response.body);

  List<DisplayMessage> displayMessageData = [];
  for (var message in data) {
    displayMessageData.add(DisplayMessage(
        message['messageId'],
        message['text'],
        DateTime.parse(message['timestamp']),
        message['senderName']
    ));
  }
  ref.read(messagesProvider.notifier).addNewMessages(displayMessageData);
  return data.map((e) => Message.fromJson(e)).toList();
}