

import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import "package:flutter/foundation.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectme_app/requests/urls.dart';




/// test requests
///  just for testing
///
///  not used in prod
///



testPostReq() async {
  lg.d("testPostReq called");
  Map pdata = {"test_data": "some data"};

  return await http
      .post(Uri.parse(test_post_request_url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pdata))
      .then((resp) async {
    lg.d("testPostReq RESP ~ " + resp.body.toString());
    lg.d("testPostReq RHEADERS ~ " + resp.headers.toString());
    lg.d("testPostReq RREAS ~ " + resp.reasonPhrase.toString());
    lg.d("testPostReq RSTAT ~ " + resp.statusCode.toString());
  });
}

testLargReq() async {
  String a = "\$\$\$";
  String b = a * 5000000;

  Uint8List ui = const Utf8Encoder().convert(b);
  lg.d("Request byte size ~ " + ui.length.toString());

  Map pdata = {"fuzz_data": b};

  return await http
      .post(Uri.parse(appConfig.server_url + "/test_large_req"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pdata))
      .then((resp) async {
    lg.d("testLargReq RESP ~ " + resp.body.toString());
    lg.d("testLargReq RHEADERS ~ " + resp.headers.toString());
    lg.d("testLargReq RREAS ~ " + resp.reasonPhrase.toString());
    lg.d("testLargReq RSTAT ~ " + resp.statusCode.toString());
  });
}