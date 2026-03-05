


import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

pushToUserTypeHome(BuildContext context, WidgetRef ref, UserType userType){
  if (ref.read(userTypeProv) == UserType.client) {
    Navigator
        .of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil(
      "/client_home",
          (route) => false,
    ); // Remove loading dialog
  }
  if (ref.read(userTypeProv) == UserType.vendor) {
    Navigator
        .of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil(
      "/vendor_home",
          (route) => false,
    ); // Remove loading dialog
  }

}