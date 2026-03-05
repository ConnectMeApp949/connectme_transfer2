import 'dart:convert';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/models/reviews/completed_review.dart';
import 'package:http/http.dart' as http;
import '../../../config/logger.dart';


Future<List<CompletedReview>> getRatingsForService(String userId,
    String authToken,
    String serviceId) async {

  lg.t("[getRatingsForService] called");
  Map pdata = {
    "userId": userId,
    "authToken": authToken,
    "serviceId": serviceId
  };

  final response = await http.post(
    Uri.parse(get_ratings_for_service_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(pdata),
  );

  if (response.statusCode != 200) {
    lg.e("[getRatingsForService] something went wrong");
    return [];
  }

  final List<dynamic> data = jsonDecode(response.body)["ratings"];
  lg.t("[getRatingsForService] test deocded response length ~ " + data.length.toString());
  //   lg.t("[getRatingsForService] completed call from json");
  //   lg.t("[getRatingsForService] full ratings ~ " + data.toString());
    return data.map((json) => CompletedReview.fromJson(json)).toList();
}


Future<List<CompletedReview>> getRatingsForVendor(String userId,
    String authToken,
    String vendorUserId) async {

  lg.t("[getRatingsForVendor] called");
  Map pdata = {
    "userId": userId,
    "authToken": authToken,
    "vendorUserId": vendorUserId
  };

  final response = await http.post(
    Uri.parse(get_ratings_for_vendor_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(pdata),
  );

  if (response.statusCode != 200) {
    lg.e("[getRatingsForVendor] something went wrong");
    return [];
  }

  final List<dynamic> data = jsonDecode(response.body)["ratings"];
  // lg.t("[getRatingsForVendor] test deocded response length ~ " + data.length.toString());
  // lg.t("[getRatingsForVendor] completed call from json");
  // lg.t("[getRatingsForVendor] full ratings ~ " + data.toString());
  return data.map((json) => CompletedReview.fromJson(json)).toList();
}


Future<Map<String,dynamic>> getVendorRatingsAgg(
    String vendorUserId) async {

  lg.t("[getVendorRatingsAgg] called");
  Map pdata = {
    "vendorUserId": vendorUserId,
  };

  final response = await http.post(
    Uri.parse(get_vendor_ratings_agg_url,
    ),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(pdata),
  );

  if (response.statusCode != 200) {
    lg.e("something went wrong");
    return {"success": false};
  }
else {
    return jsonDecode(response.body)["review_data"];
  }

}