import 'dart:async';

import 'package:connectme_app/models/messeging/user_message_thread.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


Future<UserMessageThread> getOrCreateThread(
    WidgetRef ref,
    String callingUserId,
    String callingUserName,
    String user1Id,
    String user2Id,
    String user1Name,
    String user2Name,
    ) async {
  final uri = Uri.parse(get_or_create_thread_url);

  Map pdata = {
    'userId': callingUserId,
    'callingUserId': callingUserId,
    'authToken': ref.read(userAuthProv)!.userToken,
    'user1Id': user1Id,
    'user2Id': user2Id,
    'user1Name': user1Name,
    'user2Name': user2Name,
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(pdata),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load threads');
    // return {"success":false};
  }

  final Map data = jsonDecode(response.body);
  String otherUserId = user1Id;
  if (user1Id == callingUserId){
    otherUserId = user2Id;
  }
  String otherUserName = user1Name;
  if (user1Name == callingUserName){
    otherUserName = user2Name;
  }

  Map<String, dynamic> userMessageThreadData = {
  "lastMessage": data["lastMessage"],
  "lastUpdated":data["lastUpdated"],
  "otherUserId": otherUserId,
  "otherUserName": otherUserName,
  "threadId": data["threadId"]
  };


  return UserMessageThread.fromJson(userMessageThreadData);

  // return data.map((e) => UserMessageThread.fromJson(e)).toList();
  // return data.map((e) => UserMessageThread.fromJson(e)).toList();
}