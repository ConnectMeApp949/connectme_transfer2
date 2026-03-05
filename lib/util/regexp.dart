
import 'dart:core';
import 'package:connectme_app/views/strings/ui_message_strings.dart';



/// no spaces because they will impersonate one another and increases mistakes in invite
userLoginNameValidate(String unText) {

  /// Name can only contain letters, numbers, underscores and dashes. NO spaces or any other special characters
  // var re = RegExp(r'^[a-zA-Z][a-zA-Z0-9_-]*$');
  //
  // if (!re.hasMatch(unText)) {
  //
  //   return [false, nameCanContainMessage];
  // }

  if (unText == "Guest" || unText == "guest"){
    return [false, "Cannot use username Guest"];
  }

  if (unText.length > 32) {
    return [false, nameMaxLengthMessage];
  }

  return [true];
}
