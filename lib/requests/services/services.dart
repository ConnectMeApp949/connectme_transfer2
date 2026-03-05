
import 'package:connectme_app/models/services/services.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future fetchServices(
    {String? lastGeoHash,
    String? lastDocId,
      int? distanceMetric,
      String? category,
      List<String>? keywords,
      double? rating,
    }
    ) async {
  lg.d("[fetchServices] called");


  Map pdata = {};

   pdata = {
    if (lastGeoHash != null) "lastGeoHash": lastGeoHash,
    if (lastDocId != null) "lastDocId": lastDocId,
    if (distanceMetric != null) "distanceMetric": distanceMetric,
    if (category != null) "category": category,
    if (keywords != null) "keywords": keywords,
    if (rating != null) "rating": rating,
  };

  final response = await http.post(Uri.parse(services_url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(pdata),
  );

  if (response.statusCode == 200) {
    // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
    // final List data = jsonDecode(response.body)["services"];
    // return data.map((e) => ServiceOffered.fromJson(e)).toList();
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load');
    // return {"success":false};
  }
}

Future fetchRemoteServices(
    {
      String? lastDocId,
      String? category,
      List<String>? keywords,
      double? rating,
    }
    ) async {
  lg.d("[fetchRemoteServices] called");

  Map pdata = {};

  pdata = {
    if (lastDocId != null) "lastDocId": lastDocId,
    if (category != null) "category": category,
    if (keywords != null) "keywords": keywords,
    if (rating != null) "rating": rating,
  };

  final response = await http.post(Uri.parse(remote_services_url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(pdata),
  );

  if (response.statusCode == 200) {
    // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
    // final List data = jsonDecode(response.body)["services"];
    // return data.map((e) => ServiceOffered.fromJson(e)).toList();
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load remote services');
  }
}



Future fetchProviderServices(
    String vendorUserId,
    ) async {
  lg.d("[fetchProviderServices] called");


  Map pdata = {"vendorUserId": vendorUserId,

  };

  final response = await http.post(Uri.parse(vendor_services_url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(pdata),
  );
  // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body)["services"];
    lg.t("[fetchProviderServices] len ~ " + data.length.toString());
    return data.map((e) => ServiceOffered.fromJson(e)).toList();
    // return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load');
  }
}


Future deleteService(
    String userId,
    String userToken,
    String serviceId,
    ) async {
  lg.d("[deleteProviderServices] called");


  Map pdata = {"serviceId": serviceId,
              "userId": userId,
              "authToken": userToken
  };

  final response = await http.post(Uri.parse(delete_service_url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(pdata),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load');
  }
}