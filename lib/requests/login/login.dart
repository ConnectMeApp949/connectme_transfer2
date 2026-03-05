import 'package:connectme_app/models/app/config.dart';
import 'package:connectme_app/models/user/client_user_meta.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/models/user/vendor_user_meta.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/requests/user/user_meta.dart';
import 'package:connectme_app/util/regexp.dart';
import 'package:connectme_app/views/login/create_username_page.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectme_app/models/user/user_auth.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/globals.dart';

// import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:connectme_app/platform_bridge/platform_bridge.dart';


initializeLoginUserHome(
    WidgetRef ref,
    String user_id,
    String user_disp_name,
    String auth_token,
    String email,
    String user_type,
    String account_level,
    bool purchase_ever,
    Map configOptions
    ) async{
  lg.d("[initializeLoginUserHome] called with args ~ "
      "user_id: $user_id, disp_name: $user_disp_name, token: $auth_token, email: $email");

  try {
    UserAuth makeAuth = UserAuth(
      userName: user_disp_name,
      userId: user_id,
      userToken: auth_token,
      email: email,
      accountLevel: account_level,
      purchaseEver: purchase_ever
    );

    ref.read(userAuthProv.notifier).state = makeAuth;

    if (user_type == "vendor") {
      ref.read(userTypeProv.notifier).state = UserType.vendor;
      await getUserMeta(
        user_id,
        // auth_token
      ).then((resp) {
        lg.t("initializeLoginUserHome getUserMeta vendor resp handle ~ ${resp.toString()}");
        /// should always succeed now
        if (resp["success"] == true) {
          ref.read(vendorUserMetaProv.notifier).state = VendorUserMeta.fromJson(resp["data"]);
        }
        else {
          lg.e("getUserMeta vendor resp error");
          throw Exception("getUserMeta VendorUserMeta resp error");
        }
      });
    }
    else if (user_type == "client") {
      ref
          .read(userTypeProv.notifier)
          .state = UserType.client;
      await getUserMeta(
        user_id,
        // auth_token
      ).then((resp) {
        lg.t("initializeLoginUserHome getUserMeta client resp handle ~ ${resp.toString()}");
        // try {
        if (resp["success"] == true) {
          ref
              .read(clientUserMetaProv.notifier)
              .state = ClientUserMeta.fromJson(resp["data"]);
        }
        else {
          lg.e("getUserMeta client resp error");
          throw Exception("getUserMeta ClientUserMeta resp error");
        }
      });
    }
    else if (user_type == "guest"){
      ref.read(userTypeProv.notifier).state = UserType.guest;

      ref.read(clientUserMetaProv.notifier).state =
          ClientUserMeta(
            userName:"Guest", /// username
            userType: UserType.guest, /// usertpye
          );
    }
  }
  catch(e){
    lg.e("error in initializeLoginUserHome");
    lg.e(e.toString());
    rethrow;
  }
}


convAccountToAuthAndSignIn(
    WidgetRef ref,
    GoogleSignInAuthentication googleSignInAuthentication,
    AppConfig appConfig
    )async{
  lg.d("[convAccountToAuthAndSignIn] called");

    /// #[Not this token]
    // String cred_id_token = googleSignInAuthentication.idToken!;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential? signInWithCredentialResp = await firebase_auth_inst.signInWithCredential(
        authCredential);
    lg.d("[convAccountToAuthAndSignIn] sign in with credential get cred ~ " + signInWithCredentialResp.toString());

    if (signInWithCredentialResp.user != null) {
      lg.d("[convAccountToAuthAndSignIn] user not null get id token");

      String? get_jwt_id_token = await firebase_auth_inst.currentUser!.getIdToken();
      String? get_user_email   =  firebase_auth_inst.currentUser!.email;

      if(get_jwt_id_token == null){
        return;
      }
      // lg.d("[convAccountToAuthAndSignIn] get jwt id token ~ " + get_jwt_id_token); // encoded

      /// this response should have the userFound param and success etc
      return await userLoginWithGoogle(ref, signInWithCredentialResp.user!.uid, get_jwt_id_token, get_user_email ,
      appConfig
      );
    }

  lg.d("[convAccountToAuthAndSignIn] complete");
}


userLoginWithGoogle(
    WidgetRef ref,
    String firebaseUID,
    String firebaseJWT_ID_Token,
    String? email,
    AppConfig appConfig
    ) async {

  Map pdata = {
    "firebaseUid": firebaseUID,
    "firebaseIdToken": firebaseJWT_ID_Token,
    "firebaseUserEmail": email,
    "sConfigOptions": appConfig.sConfigOptions
  };

  lg.d("[userLoginWithGoogle] called with pdata ~ " + pdata.toString());

  return await http
      .post(Uri.parse(user_login_with_google_url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pdata))
      .then((resp) async {
        lg.t("userLoginPost RESP ~ " + resp.body.toString());
        var userLoginWithGoogleResp = json.decode(resp.body);
        if (userLoginWithGoogleResp["success"] == true) {

        if (userLoginWithGoogleResp["userFound"] == false) {
          lg.d("[userLoginPostProdFirebase] user not found response retting");
          return userLoginWithGoogleResp;
        }

        lg.d("user login resp ~ " + userLoginWithGoogleResp.toString());

        /// should show error if throws in catchError
          await initializeLoginUserHome(
              ref,
            userLoginWithGoogleResp["data"]["userId"],
            userLoginWithGoogleResp["data"]["userName"],
            userLoginWithGoogleResp["data"]["token"],
            userLoginWithGoogleResp["data"]["userEmail"],
            userLoginWithGoogleResp["data"]["userType"],
            userLoginWithGoogleResp["data"]["accountLevel"],
            userLoginWithGoogleResp["data"]["purchaseEver"],
              appConfig.sConfigOptions
          );

        return userLoginWithGoogleResp;

      }
      else {
        lg.e("userLoginWithGoogle throwing userLoginPost error");
        throw Exception("userLoginPost error");
      }

  });

  //     .catchError((error) {
  //   lg.e("[userLoginPost] login error " + error.toString());
  //   showErrorDialog(context, default_error_message, tag:"userLoginWithGoogle top level default");
  // });
}


handleUserLoginWithGoogleRespAndSignIn(WidgetRef ref, userLoginWithGoogleResp, federatedId) async {
  lg.t("[handleConvertAccountAndSignIn] called with userLoginWithGoogleResp ~ " + userLoginWithGoogleResp.toString());
  lg.t("called with fid ~ " + federatedId.toString());

  if (userLoginWithGoogleResp == null){
    lg.d("[handleConvertAccountAndSignIn] userLoginWithGoogleResp null");
    /// gets to here first time from sign in silent login don't show error
    /// I/flutter ( 7953): 🖌  [googleSignIn.onCurrentUserChanged] fired
    return;
  }
  if (userLoginWithGoogleResp["success"] == true && userLoginWithGoogleResp["userFound"] == true) {
    lg.d("[handleConvertAccountAndSignIn] ~ success push to home");

    if (userLoginWithGoogleResp["data"]["userType"] == "vendor"){


      lg.t("get userLoginWithGoogleResp user Id");
      String getRespUserId = userLoginWithGoogleResp["data"]["userId"];
      lg.t("call check vendor entitlement");


      List<bool> vendorEntitled = await checkVendorEntitlement(ref, getRespUserId);
      lg.t("[requests login] check entitlement resp ~ " + vendorEntitled.toString());

      /// dying here
      if ( !vendorEntitled[0] ){
        lg.t("[login] check entitlement resp vendorEntitled false call paywall");
        await allowVendorLoginOrPaywall( gNavigatorKey.currentContext!, ref, getRespUserId, vendorEntitled[1]);
        return;
      }


      lg.t("user should have payed to get here");
      Navigator.pushNamedAndRemoveUntil(gNavigatorKey.currentContext!, "/vendor_home", (route) => false);
    }
    else if (userLoginWithGoogleResp["data"]["userType"] == "client"){
      Navigator.pushNamedAndRemoveUntil(gNavigatorKey.currentContext!, "/client_home", (route) => false);
    }

  }

  else if (userLoginWithGoogleResp["success"] == true && userLoginWithGoogleResp["userFound"] == false) {
    lg.d("[handleConvertAccountAndSignIn] user DNE send to create username page");
    if (gNavigatorKey.currentContext!.mounted) {

      Navigator.pushNamedAndRemoveUntil(gNavigatorKey.currentContext!, "/login", (route) => false);

    Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
      return CreateUsernamePage(
        federatedUserId: federatedId,
        // googleSignInAccount: gsia_res,
        // googleSignInAuthentication: googleSignInAuthentication
      );
    }));}
    else{
      lg.e("[handleConvertAccountAndSignIn] context not mounted");
    }

  }
}

userPostCreateAccountFirebase(
    // BuildContext context,
    WidgetRef ref,
    String usernameText,
    String email,
    String userType,
    String platformDescString,
    String firebaseUID,
    String firebaseID_Token,
    AppConfig appConfig
    ) async {

  Map pdata = {
    "userName": usernameText,
    "firebaseUid": firebaseUID,
    "firebaseIdToken": firebaseID_Token ,
    "platformDesc": platformDescString,
    "userEmail": email,
    "userType": userType
  };

  lg.d("[userPostCreateAccountFirebase] called with pdata ~ " + pdata.toString());

  var userLoginNameValidateResp = userLoginNameValidate(usernameText);

  if (!userLoginNameValidateResp[0]) {
    lg.e("throwing ulnv[1] ");
    throw( userLoginNameValidateResp[1] );
  }

  return await http
      .post(Uri.parse(user_create_account_firebase_url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pdata))
      .then((resp) async {
          var userCreateAccountFirebaseResp = json.decode(resp.body);
          lg.t("user_create_account_firebase_url RESP ~ " + userCreateAccountFirebaseResp.toString());
          if (userCreateAccountFirebaseResp["success"] == true) {
              await initializeLoginUserHome(
                  ref,
                  userCreateAccountFirebaseResp["data"]["userId"],
                  userCreateAccountFirebaseResp["data"]["userName"],
                  userCreateAccountFirebaseResp["data"]["token"],
                  email,
                  userType,
                "free",
                false,
                appConfig.sConfigOptions
              );
            return userCreateAccountFirebaseResp;
        }

         else if (userCreateAccountFirebaseResp["success"] == false) {
            if (userCreateAccountFirebaseResp.containsKey("userFound")){
              if (userCreateAccountFirebaseResp["userFound"] == true){
                  throw( userNameTakenErrorDialogMessage);
              }
            }

      throw(default_error_message);

    }
  }).catchError((error) {
    lg.e("[userPostCreateAccountFirebase] login error " + error.toString());
    throw error;
  });
}


/// log out
userLogoutFirebase()async {
  await firebase_auth_inst.signOut();
  await googleSignIn.signOut();
}

