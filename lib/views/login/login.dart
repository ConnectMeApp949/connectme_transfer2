import 'dart:async';
import 'dart:convert';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectme_app/components/ui/modals/test_user_bypass_dialog.dart';
import 'package:connectme_app/config/error_control_flow_strings.dart';
import 'package:connectme_app/methods/etc.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_io/io.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/requests/login/login.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/etc/loading_screen.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import "package:flutter/foundation.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


import '../../config/globals.dart';
import '../../config/logger.dart';
import '../../config/settings.dart';
import 'create_username_page.dart';

import 'dart:math' as math;
// import 'package:app_settings/app_settings.dart';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:crypto/crypto.dart';

//import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:connectme_app/platform_bridge/platform_bridge.dart';

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

String generateRetardedFacebookNonceForStupidIOS([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}


class ConnectMeLogin extends ConsumerStatefulWidget {
  const ConnectMeLogin({super.key});

  @override
  ConnectMeLoginState createState() => ConnectMeLoginState();
}

class ConnectMeLoginState extends ConsumerState<ConnectMeLogin>
    with WidgetsBindingObserver {

  /// only for google silent sign in right now
  bool isLoading = false;

  TextEditingController? loginUsernameController;


  /// whether we tried to sign in silently yet or not (should run once per app startup)
  // bool trySIS = false;
  bool handledGoogleSignIn = false; /// sometimes the listener fires and sometimes it doesn't so need to know whether it was handled or not



  signInWithGoogle() async {
    lg.d("[signInWithGoogle] called");
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        lg.d("[signInWithGoogle] got googleSignInAccount resp ~ " + googleSignInAccount.toString());
        return googleSignInAccount;
      }
    } catch (e) {
      lg.e("[signInWithGoogle] caught e ~ " + e.toString());
      if (e is PlatformException) {
        lg.e("[signInWithGoogle] PlatformException caught details:"
            "\n  Code: ${e.code}"
            "\n  Message: ${e.message}"
            "\n  Details: ${e.details}");
      } else {
        lg.e("[signInWithGoogle] Unknown error: $e");
      }
      rethrow;
    }
  }


  Future<GoogleSignInAccount?> googleSIS()async{
    lg.d("[googleSignInSilent] called");
    setState(() {
      isLoading = true;
    });
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signInSilently();
    lg.d("[googleSignInSilent] got gsia ~ " + googleSignInAccount.toString());
    // trySIS = true;
    return googleSignInAccount;
  }



  handleGoogleSignInRes(GoogleSignInAccount? googleSignInAccount) async {
    lg.d("[handleGoogleSignInRes] called");
    // check for null lg.i("[handleGoogleSignInRes] googleSignInAccount res ~ " + googleSignInAccount.toString());
    if (googleSignInAccount != null) {
      lg.d("[handleGoogleSignInRes] googleSignInAccount  ~ " + googleSignInAccount.toString());

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      // lg.t("[signInWithGoogle] try get credential idToken ~ " +
      //     googleSignInAuthentication.idToken.toString()); // idToken
      // lg.t("[signInWithGoogle] try get credential accessToken ~ " +
      //     googleSignInAuthentication.accessToken.toString());
      lg.t("[signInWithGoogle] googleSignInAuthentication  ~ " +
          googleSignInAuthentication.toString());

      /// userLoginWithGoogleResp response from user_login_with_google_url gets passed back after calling initializeLoginUserHome
      var userLoginWithGoogleResp = await convAccountToAuthAndSignIn(
           ref, googleSignInAuthentication,
          appConfig
      );
      lg.t("[handleGoogleSignInRes] got userLoginWithGoogleResp push home ~ " +
          userLoginWithGoogleResp.toString());

      String? get_federated_firebase_uid = FirebaseAuth.instance.currentUser?.uid;
      // await handleConvertAccountAndSignIn(context, ref, userLoginWithGoogleResp, googleSignInAuthentication.id);

      try {
        lg.t("call handleUserLoginWithGoogleRespAndSignIn");
        await handleUserLoginWithGoogleRespAndSignIn(
            ref, userLoginWithGoogleResp, get_federated_firebase_uid);
      }catch(e){
        lg.e("Caught e in handleGoogleSignInRes  rethrowing ~ " + e.toString());
        rethrow;
      }
      lg.t("[handleGoogleSignInRes] finished handleConvertAccountAndSignIn");
      return;
    }
      else {
      lg.t("[handleGoogleSignInRes] setting error true");
        throw Exception("Sign in response null");
      }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();

    _initPackageInfo();



    scheduleMicrotask(() async {


      await AppTrackingTransparency.requestTrackingAuthorization();

        // final iap = FlutterInappPurchase.instance;
        // await iap.initConnection();

      await initializeInAppPurchase(ref);

      // /// instantiate provider because listeners
      // var initProvPurchase = ref.watch(purchasesProvider);
      // lg.t("initProvPurchase initted ~ " + initProvPurchase.toString());
    });


    //   final iap = FlutterInappPurchase.instance;
    //   await iap.initConnection();
    //
    //
    //   purchaseUpdatedSubscription = iap.purchaseUpdatedListener.listen(
    //         (purchase) async {
    //
    //           // if (Platform.isAndroid) {
    //             debugPrint('Purchase received: ${purchase.productId}');
    //             // lg.t("android purchase ack ~ " +
    //             //     purchase.androidIsAcknowledged.toString());
    //             lg.t("purchase full json ~ " +
    //                 purchase.toJson().toString());
    //             // handle_AIP_Purchase(purchase);
    //
    //             if (purchase.purchaseState.value == "purchased") {
    //               lg.t("found purchased state");
    //
    //               try {
    //                 lg.t("call updateAccountSub");
    //                 await updateAccountSub(ref.read(userAuthProv)!.userToken,
    //                   ref.read(userAuthProv)!.userId,
    //                   purchase.id
    //                 );
    //               } catch (e) {
    //                 lg.e("Exp caught updating user doc ~ " + e.toString());
    //               }
    //
    //               lg.t("update provider");
    //               var makeAuth = ref.read(userAuthProv)!.copyWith(
    //                   purchaseEver: true,
    //                   accountLevel: "vendor_basic"
    //               );
    //               ref
    //                   .read(userAuthProv.notifier)
    //                   .state = makeAuth;
    //
    //
    //               ref.read(vendorIsFirstTimeAndJustPaidProv.notifier).state = true;
    //               Navigator.pushNamedAndRemoveUntil(
    //                   context, "/vendor_home", (route) => false);
    //
    //             }
    //           // }
    //
    //         },
    //   );
    //
    //   purchaseErrorSubscription = iap.purchaseErrorListener.listen(
    //         (error) {
    //       debugPrint('[purchaseListener] Purchase error: ${error.message}');
    //       showErrorDialog(context, default_error_message, tag: "purchaseError Listener dialog");
    //     },
    //   );
    //
    //
    // });

    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? googleSignInAccountResp) async {
      lg.d("[googleSignIn.onCurrentUserChanged] fired ~~~ ");

      /// might try to get called twice while last is running esp with quick login popup
      // if (handledGoogleSignIn) {
      //   return;
      // }
      // setState(() {
      //   handledGoogleSignIn = true;
      // });

      // In mobile, being authenticated means being authorized...
      bool isAuthorized = googleSignInAccountResp != null;
      if (isAuthorized) {
        lg.d("[googleSignIn.onCurrentUserChanged] isAuthorized");
        try {
          await handleGoogleSignInRes(googleSignInAccountResp);

        }catch(e){
          lg.e("[googleSignIn.onCurrentUserChanged] Exp caught in authorized loop for firebase user callback ~ " + e.toString());

          if (mounted) {
            setState(() {
              isLoading = false;
            });
            if (e.toString().toLowerCase().contains("purchase")) {
              String purchasesErrorMessage = web_purchase_error_text;
              if (!kIsWeb) {
                if (Platform.isIOS) {
                  purchasesErrorMessage =
                  ios_purchase_error_text;
                }
                if (Platform.isAndroid) {
                  purchasesErrorMessage = android_purchase_error_text;
                }
              }
              showErrorDialog(context, purchasesErrorMessage, tag:"[googleSignIn.onCurrentUserChanged] user change callback");
            }
            else{
              lg.t("[googleSignIn.onCurrentUserChanged] cb exp dont want to show error to dialog backout ");
            }
          }
        }
        /// paywall checks done all the way down in handleConvertAccountAndSignIn
      }
      else {
        lg.d("[googleSignIn.onCurrentUserChanged] not isAuthorized");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          // showErrorDialog(context, loginCredentialsUnverifiedMessage, tag:"logincred unverified");
        }
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      lg.t("[googleSignIn.onCurrentUserChanged.listen] complete");
    });


    lg.t("schedule paywall microtask");
    scheduleMicrotask(() async {

      /// Check paywall errors
      if (ref.read(runPaywallSubroutineForVendorErrorProv) == true) {
        lg.e("show runPaywallSubroutineForVendorErrorProv error");

        String purchasesErrorMessage = web_purchase_error_text;
        if (!kIsWeb) {
          if (Platform.isIOS) {
            purchasesErrorMessage =
                ios_purchase_error_text;
          }
          if (Platform.isAndroid) {
            purchasesErrorMessage = android_purchase_error_text;
          }
        }
        lg.e("show runPaywallSubroutineForVendorErrorProv throw dialog");
        showErrorDialog(context, purchasesErrorMessage, tag:"paywallSubroutine throw");
        ref
            .read(runPaywallSubroutineForVendorErrorProv.notifier)
            .state = false;
      }

      lg.t("set dark mode prov");

      setDarkModeProvToSystem(context);

      // if (!kIsWeb)
      // {
      //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
      //   appDocsDir = documentsDirectory.path;
      // }

      lg.t("init hive");
      await Hive.initFlutter();
      // lg.i("set docs path ~ " + appDocsDir);
      // emulator docs path ~ /data/user/0/ai.netra.vertex_flutter_demo/app_flutter

      if (appConfig.useGoogleSignIn) {
        await googleSIS().then((GoogleSignInAccount? res) async {
          lg.t("[googleSIS] then called");
          if (res == null) {
            /// user just leaves flow to here dont want to show an err
            lg.d(
                "[initState googleSIS().then] sign in with google failed res null");
          }
          lg.t("[googleSIS] res not null");
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          /// get account called from listener callback
        });
      }

      lg.i("past dev mode init second delay cb~ ");
    });
    lg.i("login init state complete");
  }


  @override
  void dispose() {
    if (loginUsernameController != null) {
      loginUsernameController!.dispose();
    }
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        Future.delayed(Duration.zero, () async {

          // if (!kIsWeb) {
          //   Directory documentsDirectory =
          //   await getApplicationDocumentsDirectory();
          //   appDocsDir = documentsDirectory.path;
          // }
          /// for compiler
          if (context.mounted) {
            if(mounted) {
              setDarkModeProvToSystem(context);
            }
          }
        });

        break;
      default:
    }
  }

  setDarkModeProvToSystem(BuildContext context) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        ref.read(darkModeProv.notifier).state = true;
      }
      if (MediaQuery.of(context).platformBrightness == Brightness.light) {
        ref.read(darkModeProv.notifier).state = false;
      }

  }

  // Widget _infoTile(String title, String subtitle) {
  //   return ListTile(
  //     title: Text(title),
  //     subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    lg.i(" login build ");

    // if (trySIS == false && appConfig.useGoogleSignIn == true){
    //   return LoadingScreen(descriptionMain: loadingScreenTitleMessage, descriptionSub: "", noUseItemUploadCounter: true,);
    // }

    if (isLoading){
      return LoadingScreen(descriptionMain: loadingScreenTitleMessage, descriptionSub: "", noUseItemUploadCounter: true,);
    }

    return Scaffold(
      body: ListView(
          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: .15.sh),
                // Text("ConnectMe (beta)", style: TextStyle(fontSize: 18.sr),),

                // ClipRRect(
                //   borderRadius:
                //   BorderRadius.only(topLeft: Radius.circular(Gss.width * .05),
                //       topRight: Radius.circular(Gss.width * .05)),
                //   child:
                  Image.asset("assets/connectme_logos/connectme_wave_logo.png",
                width: Gss.width * .33,
                ),

                GestureDetector(
                  onLongPress: (){
                    showTestUserBypassDialog(context);
                  },
                child:Padding(
                  padding: EdgeInsets.symmetric(vertical: Gss.width * .0225),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Version ${_packageInfo.version}+${_packageInfo.buildNumber}",
                  style: TextStyle(fontSize: 12.sr),
                  ),

                ],))),

                SizedBox(height: .1.sh),

                Padding(
                    padding: EdgeInsets.symmetric(vertical: Gss.width * .0225),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sign in with",
                        style: TextStyle(
                          fontSize:13.sr
                        )
                        ),
                      ],)),

                SizedBox(height: .025.sh),

                GestureDetector(
                    onTap: ()async{
                      lg.d("[Google Sign In] called");
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(child:
                        CircularProgressIndicator(color: appPrimarySwatch,)),
                      );

                      try {
                        GoogleSignInAccount signInWithGoogleResp = await signInWithGoogle();
                          lg.d("[signInWithGoogle().then] start");
                            lg.t("signInWithGoogleResp not null start sign in flow");
                            await handleGoogleSignInRes(signInWithGoogleResp);
                      }
                      catch (e) {
                        lg.e("[signInWithGoogle().then] caught e ~ " + e.toString());
                        NavigatorPop_MountedSafe(gNavigatorKey.currentContext!);

                        if (e.toString().toLowerCase().contains("purchase")) {
                          String purchasesErrorMessage = web_purchase_error_text;
                          if (!kIsWeb) {
                            if (Platform.isIOS) {
                              purchasesErrorMessage =
                                  ios_purchase_error_text;
                            }
                            if (Platform.isAndroid) {
                              purchasesErrorMessage = android_purchase_error_text;
                            }
                          }
                          showErrorDialog(gNavigatorKey.currentContext!, purchasesErrorMessage, tag:"purcherr goog sign web");
                        }

                        else if (e.toString().contains("popup_closed")) {
                          lg.w("Don't show error to user cancelling");
                        }
                        else if (e.toString().contains(entitlementNullError)) {
                          lg.w("Don't show error to user not subbed (paywall will throw)");
                        }
                        else if (e.toString().contains("FIRAuthError") ||
                            e.toString().contains("internal")
                        ){
                          lg.w("Why even show errors to users just freeze and pray after this FIR ^^ one");
                        }
                        else if (e.toString().contains("ype 'Null' is not a subtype of type 'FutureOr<boo")){
                          lg.w("Why even show errors to users just freeze and pray after this FIR ^^ one");
                        }
                        else{
                          showErrorDialog(gNavigatorKey.currentContext!, default_error_message, tag:"def google sign web");
                        }
                      }
                    },
                    child:Container(
                      width: .88.sw,
                      // height: 58.sr,
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(44.sr),
                          border: Border.all(color: Theme.of(context).textTheme.titleSmall!.color!, width: 1.sr)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// cant find trans logo
                          Expanded(child:Center(child:
                          Container(
                              width: 44.sr,
                              height: 44.sr,
                              padding: EdgeInsets.symmetric(vertical: 4.sr, horizontal: 2.sr),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(44.sr),
                              ),
                              child:
                              ClipRect(child:Container(
                                  width: 44.sr,
                                  height: 44.sr,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.circular(44.sr),
                                  ),
                                  child: Image.asset(
                                    "assets/images/google_logo_sst.png",
                                    fit:BoxFit.cover // ?? BoxFit.fill,
                                    ,
                                  )))))),
                          Container(
                              width: .66.sw,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(44.sr),
                              ),
                              child:
                              Text("Google", style: TextStyle(fontSize: 13.sr),
                              ))

                        ],),

                    )),

                SizedBox(height: Gss.height*.03,),

                GestureDetector(
                    onTap: ()async{
                      try {
                        lg.d("[Facebook Sign In] called");
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => Center(child:
                          CircularProgressIndicator(color: appPrimarySwatch,)),
                        );

                        LoginResult? facebookLoginResult;
                        UserCredential? firebaseAuthCredential_Facebook;

                        if (kIsWeb) {
                           facebookLoginResult = await FacebookAuth
                              .instance.login(
                            // permissions: ['public_profile', 'email']
                            permissions: ['email'],
                            // loginBehavior: LoginBehavior.nativeWithFallback,
                          );

                           lg.t("[Facebook Sign In kIsWeb] get facebook login token");
                           final accessToken = facebookLoginResult.accessToken!;
                           lg.t("[Facebook Sign In kIsWeb] token ~ " + accessToken.toString());
                           lg.t("[Facebook Sign In kIsWeb] get facebook auth provider credential");
                           final facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);
                           lg.t("[Facebook Sign In kIsWeb] sign in with credential");
                           firebaseAuthCredential_Facebook = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
                           lg.t("[Facebook Sign In kIsWeb] sign in with credential complete");

                        }
                        else{
                          if (Platform.isAndroid) {
                            facebookLoginResult = await FacebookAuth
                                .instance.login(
                                permissions: ['public_profile', 'email'],
                              // permissions: ['email'],
                              loginBehavior: LoginBehavior.nativeWithFallback,
                            );

                            lg.t("[Facebook Sign In isAndroid] get facebook login token");
                            final accessToken = facebookLoginResult.accessToken!;
                            lg.t("[Facebook Sign In isAndroid] token ~ " + accessToken.toString());
                            lg.t("[Facebook Sign In isAndroid] get facebook auth provider credential");
                            final facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);
                            lg.t("[Facebook Sign In isAndroid] sign in with credential");
                            firebaseAuthCredential_Facebook = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
                            lg.t("[Facebook Sign In isAndroid] sign in with credential complete");

                          }
                          /// getting limited login on iOS and it's not working
                          if (Platform.isIOS){
                            var stupidNonce = generateRetardedFacebookNonceForStupidIOS();
                            facebookLoginResult = await FacebookAuth
                                .instance.login(
                                permissions: ['public_profile', 'email'],
                                loginTracking: LoginTracking.limited,
                              nonce: stupidNonce
                              // permissions: ['email'],
                              // loginBehavior: LoginBehavior.nativeWithFallback,
                            );
                            // TrackingStatus status =
                            // await AppTrackingTransparency.trackingAuthorizationStatus;
                            //
                            // if (status == TrackingStatus.notDetermined) {
                            //   status = await AppTrackingTransparency.requestTrackingAuthorization();
                            // } else {
                            //   if (status != TrackingStatus.authorized) {
                            //     await AppSettings.openAppSettings();
                            //   }
                            // }
                            //
                            // if (status != TrackingStatus.authorized) {
                            //   const snackBar = SnackBar(content: Text('Login cancelled, to continue please allow this app to track your activity.',));
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     snackBar
                            //   );
                            //   return;
                            // }
                            // facebookLoginResult  = await FacebookAuth.instance.login(
                            //   loginTracking: LoginTracking.enabled,
                            // );

                            lg.t("generate raw nonce");
                            final rawNonce = generateRetardedFacebookNonceForStupidIOS();
                            final nonce = sha256ofString(rawNonce);
                            lg.t("converted to sha nonce");
                             facebookLoginResult = await FacebookAuth.instance.login(
                              loginTracking: LoginTracking.limited,
                              nonce: nonce,
                            );
                             lg.t("called instance login with nonce");
                            // lg.t("get user data");
                            // print('${await FacebookAuth.instance.getUserData()}'); /// breaks everything, can't believe forum post almost pwnd me with this

                            lg.t("get token as LimiteToken");
                            final token = facebookLoginResult.accessToken as LimitedToken;
                            // Create a credential from the access token
                            lg.t("convert to OAuthCredential");
                            OAuthCredential credential = OAuthCredential(
                              providerId: 'facebook.com',
                              signInMethod: 'oauth',
                              idToken: token.tokenString,
                              rawNonce: rawNonce,
                            );
                            lg.t("call Firebase sign in with credential");
                            firebaseAuthCredential_Facebook = await FirebaseAuth.instance.signInWithCredential(credential);
                          }
                        }

                        lg.t("passed platform specific facebook login");


                        /// reached from cancel popup
                        if (facebookLoginResult == null){
                          throw("facebookLoginResult null throwing no-dialog");
                        }

                        // if (firebaseAuthCredential_Facebook == null){ /// only android
                        //   throw("firebaseAuthCredential_Facebook is null throwing no-dialog");
                        // }

                        /// [FirebaseResponseHandleSubroutine] same could pull to function
                        String get_federated_firebase_id =  firebase_auth_inst.currentUser!.uid;
                        String? get_jwt_id_token = await firebase_auth_inst.currentUser!.getIdToken();
                        String? get_user_email   = firebase_auth_inst.currentUser!.email;

                        if(get_jwt_id_token == null){
                          throw("Token null throwing");
                        }

                        lg.t("compare credential uid to firebase uid ~");
                        // same
                        lg.t("federated id ~ " + get_federated_firebase_id);
                        lg.t("firebaseAuthCredential_Facebook uid ~ " + firebaseAuthCredential_Facebook!.user!.uid);

                        var userLoginWithGoogleResp =  await userLoginWithGoogle(ref, get_federated_firebase_id, get_jwt_id_token, get_user_email, appConfig);
                        lg.t(
                            "[handleFacebookSignInRes] got userLoginWithGoogleResp push home w userLoginWithGoogleResp ~ " +
                                userLoginWithGoogleResp.toString());

                        await handleUserLoginWithGoogleRespAndSignIn( ref, userLoginWithGoogleResp, get_federated_firebase_id);

                      }
                      catch (e) {
                        lg.e("Caught e in facebooklogin ~ " + e.toString());
                        NavigatorPop_MountedSafe(gNavigatorKey.currentContext!);

                        /// the errors I know about
                        if (e.toString().contains("[firebase_auth/account-exists-with-different-credential]")){
                          showErrorDialog(gNavigatorKey.currentContext!, accountProviderExistsMessage);
                        }
                        else if (e.toString().contains("Unexpected null value")){/// happens when user cancels login
                          lg.w("Don't show error to user cancelling");
                        }
                        else if (e.toString().contains("no-dialog")){
                          lg.w("Don't show error to user cancelling");
                        }
                        else {
                          lg.w("showing generic case error facebook");
                          showErrorDialog(gNavigatorKey.currentContext!, default_error_message, tag:"facebook sign default");
                        }
                      }

                    },
                    child:Container(
                      width: .88.sw,
                      // height: 58.sr,
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(44.sr),
                          border: Border.all(color: Theme.of(context).textTheme.titleSmall!.color!, width: 1.sr)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// cant find trans logo
                          Expanded(child:Center(child:
                          Container(
                              width: 44.sr,
                              height: 44.sr,
                              padding: EdgeInsets.symmetric(vertical: 4.sr, horizontal: 2.sr),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(44.sr),
                              ),
                              child:
                              ClipRect(child:Container(
                                  width: 44.sr,
                                  height: 44.sr,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.circular(44.sr),
                                  ),
                                  child: Image.asset(
                                    "assets/images/facebook_transbg.png",
                                    fit:BoxFit.cover // ?? BoxFit.fill,
                                    ,
                                  )))))),
                          Container(
                              width: .66.sw,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(44.sr),
                              ),
                              child:
                              Text("Facebook", style: TextStyle(fontSize: 13.sr),
                              ))

                        ],),

                    )),

                SizedBox(height: Gss.height*.03,),

                GestureDetector(
                    onTap: ()async {
                      lg.d("[Apple Sign In] called");
                      /// Don't show popup first because cancelling "polls" for close and takes a few seconds
                      try {
                        /// Firebase auth credential
                        UserCredential? firebaseAuthCredential_Apple;

                        final appleProvider = AppleAuthProvider();
                        if (kIsWeb) {
                          firebaseAuthCredential_Apple = await FirebaseAuth.instance.signInWithPopup(
                              appleProvider);
                        } else {
                          firebaseAuthCredential_Apple = await FirebaseAuth.instance.signInWithProvider(
                              appleProvider);
                        }

                        /// [FirebaseResponseHandleSubroutine] same could pull to function
                        String get_federated_firebase_id =  firebase_auth_inst
                            .currentUser!.uid;
                        String? get_jwt_id_token = await firebase_auth_inst
                            .currentUser!.getIdToken();
                        String? get_user_email = firebase_auth_inst
                            .currentUser!.email;

                        lg.t("Get user email firebase auth instance ~ " + get_user_email.toString());

                        final user = firebaseAuthCredential_Apple.user;
                        lg.t("user ~ " + user.toString());

                        /// Check for email (even though does not exist? just in case we add email requirement i guess)
                        if (get_user_email == null){
                          try{
                            lg.t("Get user email firebase credentials user ~ " + get_user_email.toString());
                            get_user_email = user!.email;
                          }catch(e){
                            lg.e("Exp caught getting iOS user email ~ " + e.toString());
                            // String notFoundEmailPostFix = generateRandomAlphanumeric(12);
                            String notFoundEmail = noEmailHashSeedPlaceholderEmail;
                            get_user_email = notFoundEmail;
                          }
                        }

                        if (get_jwt_id_token == null) {
                          lg.e("get_jwt_id_token null showing error dialog");
                          showErrorDialog(gNavigatorKey.currentContext!, default_error_message, tag:"apple sign jwt null");
                          return;
                        }

                        lg.t("compare credential uid to firebase uid ~");
                        // same
                        lg.t("federated id ~ " + get_federated_firebase_id);
                        lg.t("firebaseAuthCredential_Apple uid ~ " + firebaseAuthCredential_Apple.user!.uid);

                        showDialog(
                          context: gNavigatorKey.currentContext!,
                          barrierDismissible: false,
                          builder: (_) =>
                              Center(child:
                              CircularProgressIndicator(
                                color: appPrimarySwatch,)),
                        );

                        var userLoginWithGoogleResp = await userLoginWithGoogle(
                             ref, get_federated_firebase_id,
                            get_jwt_id_token, get_user_email, appConfig);
                        lg.t(
                            "[handleAppleSignInRes] got userLoginWithGoogleResp push home w userLoginWithGoogleResp ~ " +
                                userLoginWithGoogleResp.toString());

                        await handleUserLoginWithGoogleRespAndSignIn(
                             ref, userLoginWithGoogleResp,
                            get_federated_firebase_id);
                      }
                      catch (e) {
                        lg.e("[Apple Sign In] caught e ~ " + e.toString());
                        try{
                          lg.t("Nav pop apple sign in ");
                          NavigatorPop_MountedSafe(gNavigatorKey.currentContext!);
                        }catch(e){
                          lg.e("cant pop context");
                        }
            ///[Apple Sign In] caught e ~ [firebase_auth/popup-closed-by-user] The popup has been closed by the user before finalizing the operation.
                        if (e.toString().contains("popup-closed")) {
                          lg.w("Don't show error to user cancelling");
                        }
                        else {
                          if (e.toString().toLowerCase().contains("purchase")) {
                            lg.w("purchase err found");
                            String purchasesErrorMessage = web_purchase_error_text;
                            if (!kIsWeb) {
                              if (Platform.isIOS) {
                                purchasesErrorMessage =
                                    ios_purchase_error_text;
                              }
                              if (Platform.isAndroid) {
                                purchasesErrorMessage = android_purchase_error_text;
                              }
                            }
                            showErrorDialog(gNavigatorKey.currentContext!, purchasesErrorMessage, tag:"apple sign purch err");
                          }
                          else{
                            lg.e("Apple sign in unknown error show default");
                            showErrorDialog(gNavigatorKey.currentContext!, default_error_message, tag:"apple sign default");
                          }
                        }
                      }
                    },
                    child:Container(
                      width: .88.sw,
                      // height: 58.sr,
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(44.sr),
                          border: Border.all(color: Theme.of(context).textTheme.titleSmall!.color!, width: 1.sr)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// cant find trans logo
                          Expanded(child:Center(child:
                          Container(
                              width: 44.sr,
                              height: 44.sr,
                              padding: EdgeInsets.symmetric(vertical: 4.sr, horizontal: 2.sr),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(44.sr),
                              ),
                              child:
                              ClipRect(child:Container(
                                  width: 44.sr,
                                  height: 44.sr,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.circular(44.sr),
                                  ),
                                  child: Image.asset(
                                    "assets/images/apple_logo_trans_bg_0.png",
                                    fit:BoxFit.cover // ?? BoxFit.fill,
                                    ,
                                  )))))),
                          Container(
                              width: .66.sw,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(44.sr),
                              ),
                              child:
                              Text("Apple", style: TextStyle(fontSize: 13.sr),
                              ))

                        ],),

                    )),

                    SizedBox(height: Gss.height*.088,),

                    GestureDetector(
                    onTap: ()async{
                      await initializeLoginUserHome(
                         ref,
                         "Guest",
                        "Guest",
                        "GuestAuthToken",
                        "guestemail@example.com",
                        UserType.guest.name,
                        "free",
                        false,
                          appConfig.sConfigOptions
                      );
                      Navigator.pushNamedAndRemoveUntil(
                          gNavigatorKey.currentContext!, "/client_home", (route) => false);
                    },
                    child:
                    Container(
                      width: .66.sw,
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                      Flexible(child:Text(
                        "Continue as Guest",
                        style:
                        TextStyle(fontSize: 12.sr, decoration: TextDecoration.underline)
                        // Theme.of(context).textTheme.bodyLarge!.copyWith(decoration: TextDecoration.underline),
                      ))])
                    )
                    ),


                SizedBox(height: 44.sr,),
                appConfig.showDevSignInBypass?
                GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(child:
                        CircularProgressIndicator(color: appPrimarySwatch,)),
                      );

                      await initializeLoginUserHome(
                          ref, vendorTestUser.uid, vendorTestUser.un,
                          vendorTestUser.ut, vendorTestUser.ue, vendorTestUser.utype.name ,
                      "vendor_basic",
                        true,
                          appConfig.sConfigOptions
                      );

                      Navigator.pushNamedAndRemoveUntil(gNavigatorKey.currentContext!, "/vendor_home", (route) => false);

                      // try {
                      //     if (mounted && Navigator.canPop(context)) {
                      //       Navigator.pop(context);
                      //     }
                      // }catch(e){}
                    },
                    child:Container(
                      width: .88.sw,
                      padding: EdgeInsets.symmetric(horizontal: Gss.width*.1, vertical: Gss.width*.05),
                      decoration: BoxDecoration(
                        border: Border.all(color: appPrimarySwatch, width: 1.sr),
                        borderRadius: BorderRadius.circular(999),),
                      child:Center(child: Text( "Test Vendor",
                      style: TextStyle(fontSize:13.sr),
                      )),),
                    ):Container(),
                SizedBox(height: 22.sr,),
                appConfig.showDevSignInBypass?
                GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(child:
                        CircularProgressIndicator(color: appPrimarySwatch,)),
                      );

                      await initializeLoginUserHome(
                          ref, clientTestUser.uid, clientTestUser.un,
                          clientTestUser.ut, clientTestUser.ue, clientTestUser.utype.name,
                        "free",
                        false,
                          appConfig.sConfigOptions
                      );
                      Navigator.pushNamedAndRemoveUntil(gNavigatorKey.currentContext!, "/client_home", (route) => false);

                      // try {
                      //   if (mounted && Navigator.canPop(context)) {
                      //     Navigator.pop(context);
                      //   }
                      // }catch(e){}

                      },
                    child:Container(
                      width: .88.sw,
                      padding: EdgeInsets.symmetric(horizontal: Gss.width*.1, vertical: Gss.width*.05),
                      decoration: BoxDecoration(
                        border: Border.all(color: appPrimarySwatch, width: 1.sr),
                        borderRadius: BorderRadius.circular(999),),
                      child:Center(child: Text( "Test Client",
                        style: TextStyle(fontSize:13.sr),
                      )),
                    )):Container(),

                appConfig.showDevSignInBypass?
                GestureDetector(
                    onTap: () async {

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return CreateUsernamePage(
                          federatedUserId: "stub_id",
                          // googleSignInAccount: gsia_res,
                          // googleSignInAuthentication: googleSignInAuthentication
                        );
                      }));

                    },
                    child:Container(
                      width: .88.sw,
                      padding: EdgeInsets.symmetric(horizontal: Gss.width*.1, vertical: Gss.width*.05),
                      decoration: BoxDecoration(
                        border: Border.all(color: appPrimarySwatch, width: 1.sr),
                        borderRadius: BorderRadius.circular(999),),
                      child:Center(child: Text( "Test Screen",
                        style: TextStyle(fontSize:13.sr),
                      )),
                    )):Container(),
              ],
            ),
          ]),
    );
  }
}


