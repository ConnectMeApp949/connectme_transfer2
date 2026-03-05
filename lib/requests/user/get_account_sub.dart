
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future getAccountSub(
    String userId,
    ) async {
  lg.d("[getAccountSub] called");

  Map pdata = {
    "userId": userId,
  };

  final response = await http.post(Uri.parse(get_account_sub_url),
    headers: {'Content-Type': 'application/json',
    },
    body: json.encode(pdata),
  );
  lg.t("[getAccountSub] response raw ~ " + response.body.toString());
  lg.t("[getAccountSub] response ~ " + json.decode(response.body).toString());

  if (response.statusCode == 200) {
    final resp = jsonDecode(response.body);
    lg.t("[getAccountSub] resp ~ " + resp.toString());
    lg.t("[getAccountSub] get data ~ ");
    var sResp = resp["data"];
    return sResp;
  } else {
    lg.e("[getAccountSub] failed to update user meta");
    final resp = jsonDecode(response.body);
    lg.t("[getAccountSub] resp ~ " + resp.toString());
    throw Exception("getAccountSub failed");
  }
}


Future updateAccountSub(
    String userToken,
    String userId,
    String purchaseProductId
    ) async {
  lg.d("[updateAccountSub] called");

  Map pdata = {
    "userId": userId,
    "authToken": userToken,
    "purchaseProductId": purchaseProductId
  };

  final response = await http.post(Uri.parse(update_user_account_sub_url),
    headers: {'Content-Type': 'application/json',
    },
    body: json.encode(pdata),
  );
  // lg.t("[updateAccountSub] response raw ~ " + response.body.toString());
  // lg.t("[updateAccountSub] response ~ " + json.decode(response.body).toString());

  if (response.statusCode == 200) {
    final resp = jsonDecode(response.body);
    lg.t("[updateAccountSub] resp ~ " + resp.toString());
    // lg.t("[getAccountSub] get data ~ ");
    // var sResp = resp["data"];
    // return sResp;
  } else {
    lg.e("[updateAccountSub] failed to update user meta");
    final resp = jsonDecode(response.body);
    lg.t("[updateAccountSub] resp ~ " + resp.toString());
    throw Exception("updateAccountSub failed");
  }
}