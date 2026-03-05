
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



deleteUserAccount(String userToken, String userId, UserType userType, String userEmail )async{
  lg.d("[deleteUserAccount] called");

  var delBody = jsonEncode({
    'authToken': userToken,
    'userId': userId,
    "userType": userType.name,
    "userEmail": userEmail,
  });

  lg.t("deleteUserAccount delBody ~ " + delBody.toString());

  var delUserAccountResp = await http.post(Uri.parse(delete_user_account_url),
    headers: {'Content-Type': 'application/json'},
    body: delBody,
  );

  lg.t("deleteUserAccount delUserAccountResp ~ " + delUserAccountResp.toString());

  if (delUserAccountResp.statusCode == 200) {
    return delUserAccountResp;
  } else {
    lg.e("[deleteUserAccount] failed to delete user account");
    final resp = jsonDecode(delUserAccountResp.body);
    lg.t("[deleteUserAccount] resp ~ " + resp.toString());
    return delUserAccountResp;
  }
}