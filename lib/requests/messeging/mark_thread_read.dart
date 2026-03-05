import 'dart:convert';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

Future markThreadRead(
    WidgetRef ref,{
      required String threadId,
    }) async {

  final uri = Uri.parse(mark_thread_read_url);

  String  pbody = jsonEncode({
    'userId': ref.read(userAuthProv)!.userId,
    "authToken": ref.read(userAuthProv)!.userToken,
    'threadId': threadId,
  });


  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: pbody,
  );

  return jsonDecode(response.body);

}