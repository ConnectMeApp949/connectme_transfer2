
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




Future lookupSuggestedAddress(
    // WidgetRef ref,
    String inputAddress
    ) async {
  lg.d("[lookupSuggestedAddress] called");

  // Map pdata = {
  //   "userId": ref.read(userAuthProv)!.userId,
  // };

  final buildLocationQueryUrl =
  Uri.parse("https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(inputAddress)}&format=json&limit=1");

  final response = await http.get(buildLocationQueryUrl,
    headers:{
      "User-Agent": "ConnectMeApp/1.0",
      "Referer": "com.connectmeapp"
    }
  );
  // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
  if (response.statusCode == 200) {
    final resp = jsonDecode(response.body);
    if (resp.length > 0) {
      lg.t("[lookupSuggestedAddress] resp ~ " + resp.toString());
      return resp[0];
    } else {
      lg.e("[lookupSuggestedAddress] failed");
     return {};
    }
  } else {
    lg.e("[lookupSuggestedAddress] failed with non 200 status code");
    lg.e(response.body);
    throw Exception("[lookupSuggestedAddress] failed");
    // lg.t("[lookupSuggestedAddress] resp ~ " + resp.toString());
    // return resp;
  }
}

// https://nominatim.openstreetmap.org/search?q=101%20W%20Marquita%20san%20clemente%20ca&format=json&limit=1

