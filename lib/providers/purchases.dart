// import 'dart:async';
//
// import 'package:connectme_app/components/ui/modals/error_dialog.dart';
// import 'package:connectme_app/config/logger.dart';
// import 'package:connectme_app/providers/auth.dart';
// import 'package:connectme_app/providers/etc.dart';
// import 'package:connectme_app/requests/user/get_account_sub.dart';
// import 'package:connectme_app/views/strings/ui_message_strings.dart';
// import 'package:flutter/material.dart';



// final purchasesProvider = NotifierProvider<PurchaseNotifier, Map>(
//       () => PurchaseNotifier(),
// );
//
//
// class PurchaseNotifier extends Notifier<Map> {
//
//   @override
//   build() {
//     // 'ref' here to watch other providers
//
//     lg.t("build purchase notifier");
//     _startListening();
//     return {};
//   }
//
//   StreamSubscription<Purchase>? purchaseUpdatedSubscription;
//   StreamSubscription<PurchaseError>? purchaseErrorSubscription;
//
//   void _startListening() async{
//
//     lg.t("purchase listening ~ _startListening");
//     final iap = FlutterInappPurchase.instance;
//     purchaseUpdatedSubscription = iap.purchaseUpdatedListener.listen(
//           (purchase) async {
//
//         // if (Platform.isAndroid) {
//         lg.i('Purchase received: ${purchase.productId}');
//         // lg.t("android purchase ack ~ " +
//         //     purchase.androidIsAcknowledged.toString());
//         lg.d("purchase full json ~ " +
//             purchase.toJson().toString());
//         // handle_AIP_Purchase(purchase);
//
//         //       I/flutter ( 6958): 🖌 purchase full json ~ {__typename: PurchaseAndroid, autoRenewingAndroid: true, currentPlanId: null, dataAndroid: null, developerPayloadAndroid: , id: GPA.3333-4362-4266-87005, ids: [vendor_basic_monthly], isAcknowledgedAndroid: false, isAutoRenewing: true, obfuscatedAccountIdAndroid: , obfuscatedProfileIdAndroid: , packageNameAndroid: com.connectmeapp.connectmeapp, platform: android, productId: vendor_basic_monthly, purchaseState: purchased, purchaseToken: nbeggllmodfgkenlfknniigm.AO-J1OylxaaiBaN2AeZsIGPDYV3oOuQ-5ctTzZxGQXqCv2koYe934NkwOMV_acuLfrKhxWdglLacpFSXeOD_aODzTcL54Vf6Im21aNLhFiDZoT0fSh5Lcto, quantity: 1, signatureAndroid: IKWeTlDENrFhxsncoqAiJGlII74TnoLFfUqtj2jCu2PO1mh+8HJoWyMshGIuzHgw1tx9QTL4v35aWcwdKuiPXarD4WU/RIDC9lNg/pzg/gHqw9Nhw4XFaNYxx+dzxaJ+pJQB6xvAQrzeGtkyuqC9MkRO5X1oifvA/aMjjttG/WOecPgObmdQChUOjL/rWAhtwbjX1if9I0tMv5/Wu/USrL1yYq/07CPQnV13LS3uzYlgGkiqsUbQlYveuuCXwUBJDW+KbYa+jB8KdJJlUammEQedT6iQUF9yw5dB5GczAz+2HtJIVIUtIlVDF73RG2Sxn5tFo68UCofOaWPCfKqDww==, transactionDate: 1762711464229.0,
//         //           I/flutter ( 6958): transactionId: GPA.3333-4362-4266-87005, isAlternativeBilling: null}
//
//         state = purchase.toJson();
//
//         if (purchase.purchaseState.value == "purchased") {
//           lg.t("found purchased state");
//
//           try {
//             lg.t("call updateAccountSub");
//             lg.t("saving purchase id ~ " + purchase.productId.toString());
//             await updateAccountSub(ref.read(userAuthProv)!.userToken,
//                 ref.read(userAuthProv)!.userId,
//                 purchase.productId
//             );
//           } catch (e) {
//             lg.e("Exp caught updating user doc ~ " + e.toString());
//           }
//
//           lg.t("update provider");
//           var makeAuth = ref.read(userAuthProv)!.copyWith(
//               purchaseEver: true,
//               accountLevel: "vendor_basic"
//           );
//           ref
//               .read(userAuthProv.notifier)
//               .state = makeAuth;
//
//
//           ref.read(vendorIsFirstTimeAndJustPaidProv.notifier).state = true;
//           // Navigator.pushNamedAndRemoveUntil(
//           //     context, "/vendor_home", (route) => false);
//           Navigator.pushNamedAndRemoveUntil(
//               gNavigatorKey.currentContext!, "/vendor_home", (route) => false);
//
//         }
//       },
//     );
//
//     purchaseErrorSubscription = iap.purchaseErrorListener.listen(
//           (error) {
//         debugPrint('[purchaseListener] Purchase error: ${error.message}');
//         showErrorDialog(gNavigatorKey.currentContext!, default_error_message, tag: "purchaseError Listener dialog");
//       },
//     );
//
//   }
//
//
//   clear(){
//     state = {};
//   }
//
// // void _updatePurchases(PurchaseModel purchase) {
// //   // Create a new map with the updated purchase data
// //   // This is crucial: **Riverpod requires state to be immutable**.
// //   state = {
// //     ...state, // Spread the existing map
// //     purchase.productId: purchase, // Add or overwrite the new purchase
// //   };
// //   // The state setter will automatically notify all listeners.
// //   debugPrint('State updated with new purchase: ${purchase.productId}');
// // }
//
// // NOTE: In a real app, you must handle resource cleanup,
// // like cancelling the stream subscription when the notifier is disposed.
// // This is often why using StreamProvider or combining it with a Notifier
// // can be simpler for external streams.
// // @override
// // void dispose() {
// //   _purchaseSubscription.cancel();
// //   super.dispose();
// // }
// }
//
//
//
// //
// //
// //
// // final purchasesProvider = NotifierProvider<PurchaseNotifier, Map>(
// //       () => PurchaseNotifier(),
// // );
// //
// //
// // class PurchaseNotifier extends Notifier<Map> {
// //
// //   @override
// //    build() {
// //     // 'ref' here to watch other providers
// //
// //     lg.t("build purchase notifier");
// //     _startListening();
// //     return {};
// //   }
// //
// //   StreamSubscription<Purchase>? purchaseUpdatedSubscription;
// //   StreamSubscription<PurchaseError>? purchaseErrorSubscription;
// //
// //   void _startListening() async{
// //
// //     lg.t("purchase listening ~ _startListening");
// //       final iap = FlutterInappPurchase.instance;
// //       purchaseUpdatedSubscription = iap.purchaseUpdatedListener.listen(
// //             (purchase) async {
// //
// //     // if (Platform.isAndroid) {
// //           lg.i('Purchase received: ${purchase.productId}');
// //     // lg.t("android purchase ack ~ " +
// //     //     purchase.androidIsAcknowledged.toString());
// //           lg.d("purchase full json ~ " +
// //               purchase.toJson().toString());
// //     // handle_AIP_Purchase(purchase);
// //
// //           //       I/flutter ( 6958): 🖌 purchase full json ~ {__typename: PurchaseAndroid, autoRenewingAndroid: true, currentPlanId: null, dataAndroid: null, developerPayloadAndroid: , id: GPA.3333-4362-4266-87005, ids: [vendor_basic_monthly], isAcknowledgedAndroid: false, isAutoRenewing: true, obfuscatedAccountIdAndroid: , obfuscatedProfileIdAndroid: , packageNameAndroid: com.connectmeapp.connectmeapp, platform: android, productId: vendor_basic_monthly, purchaseState: purchased, purchaseToken: nbeggllmodfgkenlfknniigm.AO-J1OylxaaiBaN2AeZsIGPDYV3oOuQ-5ctTzZxGQXqCv2koYe934NkwOMV_acuLfrKhxWdglLacpFSXeOD_aODzTcL54Vf6Im21aNLhFiDZoT0fSh5Lcto, quantity: 1, signatureAndroid: IKWeTlDENrFhxsncoqAiJGlII74TnoLFfUqtj2jCu2PO1mh+8HJoWyMshGIuzHgw1tx9QTL4v35aWcwdKuiPXarD4WU/RIDC9lNg/pzg/gHqw9Nhw4XFaNYxx+dzxaJ+pJQB6xvAQrzeGtkyuqC9MkRO5X1oifvA/aMjjttG/WOecPgObmdQChUOjL/rWAhtwbjX1if9I0tMv5/Wu/USrL1yYq/07CPQnV13LS3uzYlgGkiqsUbQlYveuuCXwUBJDW+KbYa+jB8KdJJlUammEQedT6iQUF9yw5dB5GczAz+2HtJIVIUtIlVDF73RG2Sxn5tFo68UCofOaWPCfKqDww==, transactionDate: 1762711464229.0,
// //     //           I/flutter ( 6958): transactionId: GPA.3333-4362-4266-87005, isAlternativeBilling: null}
// //
// //           state = purchase.toJson();
// //
// //           if (purchase.purchaseState.value == "purchased") {
// //             lg.t("found purchased state");
// //
// //             try {
// //               lg.t("call updateAccountSub");
// //               lg.t("saving purchase id ~ " + purchase.productId.toString());
// //               await updateAccountSub(ref.read(userAuthProv)!.userToken,
// //                   ref.read(userAuthProv)!.userId,
// //                   purchase.productId
// //               );
// //             } catch (e) {
// //               lg.e("Exp caught updating user doc ~ " + e.toString());
// //             }
// //
// //             lg.t("update provider");
// //             var makeAuth = ref.read(userAuthProv)!.copyWith(
// //                 purchaseEver: true,
// //                 accountLevel: "vendor_basic"
// //             );
// //             ref
// //                 .read(userAuthProv.notifier)
// //                 .state = makeAuth;
// //
// //
// //             ref.read(vendorIsFirstTimeAndJustPaidProv.notifier).state = true;
// //             // Navigator.pushNamedAndRemoveUntil(
// //             //     context, "/vendor_home", (route) => false);
// //             Navigator.pushNamedAndRemoveUntil(
// //                 gNavigatorKey.currentContext!, "/vendor_home", (route) => false);
// //
// //           }
// //         },
// //       );
// //
// //       purchaseErrorSubscription = iap.purchaseErrorListener.listen(
// //             (error) {
// //           debugPrint('[purchaseListener] Purchase error: ${error.message}');
// //           showErrorDialog(gNavigatorKey.currentContext!, default_error_message, tag: "purchaseError Listener dialog");
// //         },
// //       );
// //
// //   }
// //
// //
// //   clear(){
// //     state = {};
// //   }
// //
// //   // void _updatePurchases(PurchaseModel purchase) {
// //   //   // Create a new map with the updated purchase data
// //   //   // This is crucial: **Riverpod requires state to be immutable**.
// //   //   state = {
// //   //     ...state, // Spread the existing map
// //   //     purchase.productId: purchase, // Add or overwrite the new purchase
// //   //   };
// //   //   // The state setter will automatically notify all listeners.
// //   //   debugPrint('State updated with new purchase: ${purchase.productId}');
// //   // }
// //
// // // NOTE: In a real app, you must handle resource cleanup,
// // // like cancelling the stream subscription when the notifier is disposed.
// // // This is often why using StreamProvider or combining it with a Notifier
// // // can be simpler for external streams.
// // // @override
// // // void dispose() {
// // //   _purchaseSubscription.cancel();
// // //   super.dispose();
// // // }
// // }
//
//
