// import 'dart:async';
//
// import 'package:connectme_app/config/logger.dart';
// import 'package:connectme_app/requests/login/login.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// class Facebook_BS_AuthCallbackPage extends ConsumerStatefulWidget {
//   Facebook_BS_AuthCallbackPage({
//     required this.accessToken,
// });
//   final String accessToken;
//
//   @override
//   _Facebook_BS_AuthCallbackPageState createState() => _Facebook_BS_AuthCallbackPageState();
// }
//
// class _Facebook_BS_AuthCallbackPageState extends ConsumerState<Facebook_BS_AuthCallbackPage> {
//   @override
//   void initState() {
//     super.initState();
//
//     scheduleMicrotask((){
//
//       handleRedirect();
//     });
//
//   }
//
//   void handleRedirect() async {
//     lg.t("Facebook handle redirect");
//     // final fragment = html.window.location.hash; // #access_token=...
//     // final params = Uri.splitQueryString(fragment.substring(1));
//     // final accessToken = params['access_token'];
//
//     if (widget.accessToken != null) {
//       try {
//         final credential = FacebookAuthProvider.credential(widget.accessToken);
//         await FirebaseAuth.instance.signInWithCredential(credential);
//         print('✅ Signed in as: ${FirebaseAuth.instance.currentUser?.email}');
//         print('✅ Signed with uid: ${FirebaseAuth.instance.currentUser?.uid}');
//
//         String? get_firebase_email = FirebaseAuth.instance.currentUser?.email;
//         String? get_federated_firebase_uid = FirebaseAuth.instance.currentUser?.uid;
//         String? get_jwt_id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//
//
//         if (get_jwt_id_token != null && get_federated_firebase_uid != null) {
//
//           var cvAcct_AASi = await userLoginWithGoogle(context, ref,
//               get_federated_firebase_uid,
//               get_jwt_id_token, get_firebase_email);
//
//           handleConvertAccountAndSignIn(context, ref, cvAcct_AASi, get_federated_firebase_uid);
//         }
//
//
//       } catch (e) {
//         lg.t('❌ Firebase sign-in failed: $e');
//       }
//     } else {
//       lg.t('❌ No access token found in fragment');
//     }
//
//     lg.t("facebook handle redirect complete");
//     // Optional: Clean URL and redirect
//     // html.window.history.pushState(null, 'Clean', '/');
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child:
//       Column(mainAxisSize: MainAxisSize.min,
//       children:[
//         CircularProgressIndicator(),
//         Text('Logging in with Facebook...'),
//       ])),
//     );
//   }
// }