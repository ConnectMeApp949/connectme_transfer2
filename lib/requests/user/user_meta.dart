
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/models/user/user_auth.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future getUserMeta(
    String userId,
    // String userToken
    ) async {
  lg.d("[getUserMeta] called");

  Map pdata = {
    "userId": userId,
  };

  final response = await http.post(Uri.parse(get_user_meta_url),
    headers: {'Content-Type': 'application/json',
      // 'authToken': userToken
    },
    body: json.encode(pdata),
  );
  // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
  if (response.statusCode == 200) {
    final resp = jsonDecode(response.body);
    lg.t("[getUserMeta] resp ~ " + resp.toString());
    return resp;
  } else {
    lg.e("[getUserMeta] failed to update user meta");
    final resp = jsonDecode(response.body);
    lg.t("[getUserMeta] resp ~ " + resp.toString());
    return resp;
  }
}

Future updateUserMeta(
    WidgetRef ref,
    ) async {
  lg.d("[updateUserMeta] called");

  Map? updateUserMeta;
  if (ref.read(userTypeProv) == UserType.vendor) {
    updateUserMeta = ref.read(vendorUserMetaProv)!.toJson();
  }
  if (ref.read(userTypeProv) == UserType.client) {
    updateUserMeta = ref.read(clientUserMetaProv)!.toJson();
  }

  Map pdata = {
    "userId": ref.read(userAuthProv)!.userId,
    "updateUserMeta": updateUserMeta};

  lg.t("updateUserMeta with pdata " + pdata.toString());

  final response = await http.post(Uri.parse(update_user_meta_url),
    headers: {'Content-Type': 'application/json',
          'authToken': ref.read(userAuthProv)!.userToken
    },
    body: json.encode(pdata),
  );
  // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
  if (response.statusCode == 200) {
    final resp = jsonDecode(response.body);
    lg.t("[updateUserMeta] resp ~ " + resp.toString());
    return resp;
  } else {
    lg.e("[updateUserMeta] failed to update user meta");
    final resp = jsonDecode(response.body);
    lg.t("[updateUserMeta] resp ~ " + resp.toString());
    return resp;
  }
}

updateUserName(WidgetRef ref, String newUserName) async{
  lg.d("[updateUserName] called");


  /// just allowing vendors to change name for now
  if (ref.read(userTypeProv) == UserType.vendor) {
    UserAuth oldAuthObj = ref.read(userAuthProv)!;
    UserAuth newAuthObj = oldAuthObj.copyWith(userName: newUserName);
    ref.read(userAuthProv.notifier).state = newAuthObj;
  }
  // if (ref.read(userTypeProv) == UserType.client) {
  //   updateUserMeta = ref.read(clientUserMetaProv)!.toJson();
  // }

  Map pdata = {
    "userId": ref.read(userAuthProv)!.userId,
    "updateUserName": newUserName};

  lg.t("updateUserName with pdata " + pdata.toString());

  final response = await http.post(Uri.parse(update_user_meta_url),
    headers: {'Content-Type': 'application/json',
      'authToken': ref.read(userAuthProv)!.userToken
    },
    body: json.encode(pdata),
  );
  // lg.t("[fetchServices] response ~ " + json.decode(response.body).toString());
  if (response.statusCode == 200) {
    final resp = jsonDecode(response.body);
    lg.t("[updateUserName] resp ~ " + resp.toString());
    return resp;
  } else {
    lg.e("[updateUserName] failed to update user name");
    final resp = jsonDecode(response.body);
    lg.t("[updateUserName] resp ~ " + resp.toString());
    return resp;
  }
}