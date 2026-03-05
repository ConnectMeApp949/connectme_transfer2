
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future saveProvider(
    String vendorUserId,
    bool? remove,
    String userId,
    String userToken
    ) async {
  lg.d("[saveProvider] called");

  Map pdata = {
    "vendorUserId": vendorUserId,
    "userId": userId,
    if (remove != null) "remove": remove
  };


  final response = await http.post(Uri.parse(save_provider_url),
    headers: {'Content-Type': 'application/json',
      'authToken': userToken
    },
    body: json.encode(pdata),
  );
  // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
  if (response.statusCode == 200) {
    final resp = jsonDecode(response.body);
    lg.t("[saveProvider] resp ~ " + resp.toString());
    return resp;
  } else {
    lg.e("[saveProvider] failed to update user meta");
    final resp = jsonDecode(response.body);
    lg.t("[saveProvider] resp ~ " + resp.toString());
    return resp;
  }
}


Future<List<String>> getSavedProviders(
    String userId,
    String userToken
    ) async {
  lg.d("[getSavedProviders] called");

  Map pdata = {
    "userId": userId,
  };


  final response = await http.post(Uri.parse(get_saved_providers_url),
    headers: {'Content-Type': 'application/json',
      'authToken': userToken
    },
    body: json.encode(pdata),
  );
  // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
  if (response.statusCode == 200) {

    final resp = jsonDecode(response.body);
    lg.t("[getSavedProviders] resp ~ " + resp.toString());
    final List<dynamic> raw = resp["data"] ?? [];
    // final List<String> data = raw.cast<String>();
    final List<String> data = List<String>.from(raw);
    return data;

  } else {
    final resp = jsonDecode(response.body);
    lg.e("[getSavedProviders] resp ~ " + resp.toString());
  }
  return [];
}