// import 'dart:async';
// import 'dart:html' as html;
// // import 'package:sky_engine/js_interop/js_interop.dart' as html;
// import 'dart:typed_data';
// import 'package:connectme_app/config/globals.dart';
// import 'package:connectme_app/config/logger.dart';
// import 'package:connectme_app/config/settings.dart';
// import 'package:connectme_app/methods/etc.dart';
// import 'package:connectme_app/models/revenue_cat/store.dart';
// import 'package:connectme_app/models/user/etc.dart';
// import 'package:connectme_app/providers/auth.dart';
// import 'package:connectme_app/providers/etc.dart';
// import 'package:connectme_app/requests/user/get_account_sub.dart';
// import 'package:connectme_app/util/image_util.dart';
// import 'package:connectme_app/views/onboarding/onboarding_screens/obc_1.dart';
// import 'package:connectme_app/views/rc_paywall/create_account_paywall.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:universal_io/io.dart';
//
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import '../config/error_control_flow_strings.dart';
//
//
// import 'package:connectme_app/components/ui/modals/error_dialog.dart';
// import 'package:connectme_app/config/settings.dart';
// import 'package:connectme_app/methods/etc.dart';
// import 'package:connectme_app/models/user/etc.dart';
// import 'package:connectme_app/providers/etc.dart';
// import 'package:connectme_app/views/onboarding/onboarding_screens/obc_1.dart';
// import 'package:connectme_app/views/rc_paywall/create_account_paywall.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import '../../config/logger.dart';
//
//
// import 'package:connectme_app/config/globals.dart';
// import 'package:connectme_app/config/settings.dart';
// import 'package:connectme_app/models/revenue_cat/store.dart';
// import 'package:connectme_app/styles/colors.dart';
// import 'package:connectme_app/views/strings/ui_message_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import '../../components/ui/modals/error_dialog.dart';
// import '../../config/logger.dart';
//
// import 'package:connectme_app/platform_bridge/platform_bridge.dart';
//
//
//
//
// /// **************
// /// Conditional import web only
// /// ******************
// // import 'package:purchases_flutter/purchases_flutter.dart';
//
//
// void doPlatformThing() {
//   html.window.alert('Running on Web!');
// }
//
//
//
// initializeInAppPurchase(ref) async {
//
//   lg.t("initializeInAppPurchase web called" );
//   Stripe.publishableKey = appConfig.stripePublishableKey;
//
//       // if (kIsWeb) {
//       //   RCStoreConfig(
//       //     store: Store.rcBilling,
//       //     apiKey: appConfig.revenuecatApiKey,
//       //   );
//       // } else if (Platform.isIOS || Platform.isMacOS) {
//       //   RCStoreConfig(
//       //     store: Store.appStore,
//       //     apiKey: appConfig.revenuecatApiKey,
//       //   );
//       // } else if (Platform.isAndroid) {
//       //   // Run the app passing --dart-define=AMAZON=true
//       //   // const useAmazon = bool.fromEnvironment("amazon");
//       //   RCStoreConfig(
//       //     store: /*useAmazon ? Store.amazon : */  Store.playStore,
//       //     apiKey:/* useAmazon ? amazonApiKey :*/ appConfig.revenuecatApiKey,
//       //   );
//       // }
//
//   await configure_RC_SDK();
//
//
// }
//
//
//
// Future<Uint8List?> pickImageAndConvertToJpeg() async{
//   final completer = Completer<Uint8List?>();
//   final input = html.FileUploadInputElement()..accept = 'image/*';
//   input.click();
//
//   input.onChange.listen((event) async {
//     final file = input.files?.first;
//     if (file == null) {
//       completer.complete(null);
//       return;
//     }
//
//     final reader = html.FileReader();
//     reader.readAsDataUrl(file);
//     await reader.onLoad.first;
//
//     final base64DataUrl = reader.result as String;
//
//     final imageElement = html.ImageElement();
//     imageElement.src = base64DataUrl;
//
//     await imageElement.onLoad.first;
//
//     // Draw image to a canvas
//     final canvas = html.CanvasElement(
//       width: imageElement.width,
//       height: imageElement.height,
//     );
//     final context = canvas.context2D;
//     context.drawImage(imageElement, 0, 0);
//
//     // Export canvas as JPEG data URL
//     final jpegDataUrl = canvas.toDataUrl("image/jpeg", 0.85); // 0.0–1.0 quality
//
//     // Convert base64 JPEG data URL to Uint8List
//     final jpegBytesResult = dataUrlToBytes(jpegDataUrl);
//
//     completer.complete(jpegBytesResult);
//
//   });
//
//   return completer.future;
//
// }
//
//
//
// String? getAccessTokenFromHash() {
//   final hash = html.window.location.hash; // e.g., "#access_token=EAA..."
//   if (hash.isEmpty || !hash.contains('=')) return null;
//
//   // Convert the fragment into a query string by replacing "#" with "?"
//   final parsed = Uri.parse(hash.replaceFirst('#', '?'));
//   return parsed.queryParameters['access_token'];
// }
//
// // runOauthRedirectHandlers(){
// //   lg.t('>> location.href: ${html.window.location.href}');
// //   lg.t('>> location.hash: ${html.window.location.hash}');
// //   String? getAccessToken = getAccessTokenFromHash();
// //   lg.t('>> access token: ${getAccessToken}');
// //
// //   if (html.window.location.href.contains("facebook_bs") &&
// //       getAccessToken != null
// //   ){
// //     MaterialPageRoute(
// //       builder: (_) => Facebook_BS_AuthCallbackPage(
// //         accessToken: getAccessToken,
// //       ),
// //     );
// //
// //   }
// // }
//
//
// openHtmlWindow(url){
//   html.window.open(url, '_self');
// }
//
//
// Future<void> signInAndFetchCalendar() async {
//
// }
//
//
// callSubscriptionConfig() {
//   // String rc_web_api_key = apiKey;
//   // String rc_web_api_key = revenueCatWebApiKey;
//   // RCStoreConfig(
//   //   store: Store.appStore,
//   //   apiKey: rc_web_api_key,
//   // );
// }
//
//
// // class RCStoreConfig {
// //   final Store store;
// //   final String apiKey;
// //   static RCStoreConfig? _instance;
// //
// //   factory RCStoreConfig({required Store store, required String apiKey}) {
// //     _instance ??= RCStoreConfig._internal(store, apiKey);
// //     return _instance!;
// //   }
// //
// //   RCStoreConfig._internal(this.store, this.apiKey);
// //
// //   static RCStoreConfig get instance {
// //     return _instance!;
// //   }
// //
// //   static bool isForAppleStore() => instance.store == Store.appStore;
// //
// //   static bool isForGooglePlay() => instance.store == Store.playStore;
// //
// //   static bool isForAmazonAppstore() => instance.store == Store.amazon;
// //
// //   static bool isForWeb() => instance.store == Store.rcBilling;
// // }
//
// Future<void> configure_RC_SDK() async {
//   // Enable debug logs before calling `configure`.
//   // await Purchases.setLogLevel(LogLevel.debug);
//   //
//   // /*
//   //   - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//   //
//   //   - PurchasesAreCompletedyBy is PurchasesAreCompletedByRevenueCat, so Purchases will automatically handle finishing transactions. Read more about completing purchases here: https://www.revenuecat.com/docs/migrating-to-revenuecat/sdk-or-not/finishing-transactions
//   //   */
//   PurchasesConfiguration configuration;
//   // if (RCStoreConfig.isForAmazonAppstore()) {
//   //   configuration = AmazonConfiguration(RCStoreConfig.instance.apiKey)
//   //     ..appUserID = null
//   //     ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
//   // } else {
//   configuration = PurchasesConfiguration(appConfig.revenuecatApiKey)
//     ..appUserID = null
//     ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
//   // }
//   await Purchases.configure(configuration);
// }
//
// Future<void> RC_InitVendorCustomerStatus(WidgetRef ref) async {
//
//   // var preInfoUpdateUserId = await Purchases.appUserID;
//   // lg.i("[Purchases.addCustomerInfoUpdateListener] set appUserID ~ " + preInfoUpdateUserId.toString());
//   // ref.read(revcatAppUserIdProv.notifier).state = preInfoUpdateUserId;
//   //
//   // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//   // EntitlementInfo? entitlement = customerInfo.entitlements.all[vendorBasicAccountEntitlementID];
//   // ref.read(vendorHasSubscriptionProv.notifier).state = entitlement?.isActive ?? false;
//   //
//   // Purchases.addCustomerInfoUpdateListener((CustomerInfo customerInfo) async {
//   //
//   //   lg.i("[Purchases.addCustomerInfoUpdateListener] fired ~ ");
//   //
//   //   var postInfoUpdateUserId = await Purchases.appUserID;
//   //   lg.i("[Purchases.addCustomerInfoUpdateListener] callback set appUserID ~ " + postInfoUpdateUserId.toString());
//   //   ref.read(revcatAppUserIdProv.notifier).state = postInfoUpdateUserId;
//   //
//   //   // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//   //   EntitlementInfo? entitlement = customerInfo.entitlements.all[vendorBasicAccountEntitlementID];
//   //   ref.read(vendorHasSubscriptionProv.notifier).state = entitlement?.isActive ?? false;
//   //
//   // });
//
// }
//
// RC_RestorePurchases(WidgetRef ref) async {
//
//   /*
//       How to login and identify your users with the Purchases SDK.
//       Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//     */
//
//   // try {
//   //   await Purchases.restorePurchases();
//   //   ref.read(revcatAppUserIdProv.notifier).state = await Purchases.appUserID;
//   // } on PlatformException catch (e) {
//   //   lg.e("Error restoring purchases: ${e.message}");
//   // }
//
// }
//
// RC_PurchasesLogin(WidgetRef ref, String appUserID) async {
//
//   /*
//       How to login and identify your users with the Purchases SDK.
//       Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//     */
//   lg.t("[RC_PurchasesLogin] called with appUserID ~ " + appUserID.toString());
//   try {
//     await Purchases.logIn(appUserID);
//     ref.read(revcatAppUserIdProv.notifier).state = await Purchases.appUserID;
//   } on PlatformException catch (e) {
//     lg.e("Error logging in to purchases: ${e.message}");
//   }
//
// }
//
// /// supposed to return this
// ///  EntitlementInfo? entitlement_resp
// // Future<EntitlementInfo?> allowVendorLoginOrPaywall(BuildContext context,WidgetRef ref, String userId) async {
// //   // loadingStateCB(true);
// //
// //   lg.t("[allowVendorLoginOrPaywall] calling platform");
// //   lg.t("[allowVendorLoginOrPaywall] calling RC_PurchasesLogin");
// //   await RC_PurchasesLogin(ref, userId);
// //
// //   CustomerInfo customerInfo = await Purchases.getCustomerInfo();
// //
// //   lg.t("check intro eligibility");
// //
// //
// //   /// surprisingly does nothing
// //   //  Map<String, IntroEligibility> pelg =  await Purchases.checkTrialOrIntroductoryPriceEligibility(["vendor_basic_monthly"]);
// //   //  lg.t("check intro eligibility res ~ " + pelg.toString());
// //   //  pelg.forEach((String productId, IntroEligibility eligibility) {
// //   //    lg.d("Product: $productId, "
// //   //        "Eligibility: ${eligibility.status}, "
// //   //        "Description: ${eligibility.description}");
// //   //  });
// //
// //
// //   lg.t("got customer info ~ " + customerInfo.toString());
// //
// //   if (customerInfo.entitlements.all[vendorBasicAccountEntitlementID] !=
// //       null &&
// //       customerInfo.entitlements.all[vendorBasicAccountEntitlementID]
// //           ?.isActive == true) {
// //     // appData.currentData = WeatherData.generateData();
// //
// //     /// USER IS PREMIUM might get here from flow if I don't know what's going on
// //
// //     return customerInfo.entitlements.all[vendorBasicAccountEntitlementID];
// //     // loadingStateCB(false);
// //   }
// //   else {
// //     lg.t(" entitlement is not active");
// //     Offerings? offerings;
// //     Map <String, Offering?> vendorLoginOfferings;
// //
// //     /// convert to map
// //     try {
// //       lg.t("get offerings");
// //       offerings = await Purchases.getOfferings();
// //
// //       lg.t("got offerings ~ " + offerings.toString());
// //       lg.t("offerings all ~ " + offerings.all.toString());
// //
// //       vendorLoginOfferings = offerings.all;
// //       lg.t("get offerings all complete");
// //     } catch (e) {
// //       lg.e(e.toString());
// //       throw Exception("Purchase error");
// //     }
// //
// //     lg.t("check offerings and show sheet");
// //
// //     if (vendorLoginOfferings.isEmpty) {
// //       lg.e("offerings is null");
// //       throw Exception("Subscription offerings not found");
// //     } else {
// //       // if (products == null || products.current == null) {
// //       //   lg.t("products is null");
// //       // } else {
// //       // current offering is available, show paywall
// //
// //       lg.t("check showed recent");
// //
// //       /// paywall showing twice from push to home and after "found vendor needs paywall" doing hack for reasons
// //       if (ref.read(showedRecentPaywallSheet)) {
// //         lg.t("show recent true returning null");
// //         return null;
// //       }
// //       else {
// //         lg.t("run paywall trigger");
// //         triggerPaywallTrigger(ref);
// //       }
// //
// //       return await showModalBottomSheet(
// //         useRootNavigator: true,
// //         isDismissible: true,
// //         isScrollControlled: true,
// //
// //         shape: const RoundedRectangleBorder(
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
// //         ),
// //         context: context,
// //         builder: (BuildContext context) {
// //           return StatefulBuilder(
// //               builder: (BuildContext context, StateSetter setModalState) {
// //                 return VendorLoginPaywall(
// //                     customerInfo: customerInfo,
// //                     // offering: vendorLoginOffering!,
// //                     offerings: vendorLoginOfferings
// //                 );
// //               });
// //         },
// //       );
// //     }
// //   }
// // }
//
// /// clone for revenuecat triage
//
//
//
// // runPaywallSubroutineForVendor(BuildContext context, /// wanted to avoid but also wanted to keep nav push in here
// //     WidgetRef ref, String userId) async {
// //   bool pw_success = false;
// //
// //   /// to avoid try catch loading pop stuff
// //   try {
// //     EntitlementInfo? entitlement_resp = await allowVendorLoginOrPaywall(context,
// //         ref, userId);
// //     lg.t("allowVendorLoginOrPaywall passed");
// //     if (entitlement_resp != null) {
// //       lg.t("entitlement_resp is not null");
// //       if (entitlement_resp.isActive == true) {
// //         lg.t("entitlement is active");
// //         pw_success = true;
// //       }
// //       else {
// //         lg.t("entitlement is not active");
// //       }
// //     }
// //   }
// //   catch (e) {
// //     rethrow;
// //   }
// //
// //   if (pw_success) {
// //     ref
// //         .read(vendorIsFirstTimeAndJustPaidProv.notifier)
// //         .state = true;
// //     Navigator.pushNamedAndRemoveUntil(
// //         context, "/vendor_home", (route) => false);
// //
// //     /// keep out of try catch or it will pop back for insig error maybe
// //   }
// //   else{
// //     throw Exception("Something went wrong: 73");
// //   }
// // }
//
//
// runOnboardingBeforePaywall(BuildContext context, WidgetRef ref, String foundUserId, bool purchaseEver){
//   lg.t("[runOnboardingBeforePaywall] called");
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return  OnboardingScreen(userType: UserType.vendor,
//         onboardingCompletedFn: (WidgetRef ref)async{ /// very subtle and tricky, Pretty sure context is fine for the pushNameAndRemoveUntil from "MaterialPageRoute(builder: (context) {" but the       "ref.read(runPaywallSubroutineForVendorErrorProv" will error without passing ref explicityl
//           if (appConfig.bypassPaywall ||
//               ref.read(vendorHasSubscriptionProv) /// dont think this is actually going to exist ever unless maybe they pay get an error, account is created and we have to check somewhere else still
//           ) {
//             Navigator.pushNamedAndRemoveUntil(
//                 context, "/vendor_home", (route) => false);
//             return;
//           }
//           else {
//             lg.t("Found vendor needs paywall");
//             try {
//               NavigatorPop_MountedSafe(context); /// pop loading screen
//
//               /// [CRF]
//               // await runPaywallSubroutineForVendor(context,
//               //     ref, foundUserId);
//
//             }catch(e){
//               lg.e("error caught from runPaywallSubroutineForVendor ~ " + e.toString());
//               ref.read(runPaywallSubroutineForVendorErrorProv.notifier).state = true;
//               Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
//             }
//           }
//         }
//     );
//   }));
// }
//
//
//
// const String KEY_ID = "DT7Q6642WB"; // Your private key ID
// const String ISSUER_ID = "b12187d5-efa7-44ca-8cbc-292e85a148bb";
// const String BUNDLE_ID = "com.connectmeapp.connectmeapp";
// // const String PRIVATE_KEY_PATH = "AuthKey_AB1C2D3E4F.p8"; // Path to your downloaded .p8 file
//
// // The App Store Server API audience is fixed
// // const String AUDIENCE = "appstoreconnect-v2";
// const AUDIENCE = "appstore-v1";
// // Max token lifespan is 5 minutes (300 seconds)
// const int EXPIRATION_SECONDS = 300;
//
// /// Generates an ES256-signed JWT for the App Store Server API.
// String generateAppStoreServerJWT() {
//   try {
//     // 1. Read the Private Key
//     // final privateKeyContent = File(PRIVATE_KEY_PATH).readAsStringSync();
//
//     // Create the SecretKey object from the P8 file content
//     // ES256 requires an ECPrivateKey
//     final ecPrivateKey = ECPrivateKey(
//         """-----BEGIN PRIVATE KEY-----
//         MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgC9aBsDTjYORsf099
//         1YqHdpGNvNARq1wD2nGd8RVXQ2+gCgYIKoZIzj0DAQehRANCAATsoixCNxVL8jd/
//         1dWHHG198Yi8t4FK6flYliSUETuu1PXTk0oOZCcKBSGwYP3lap4d+aG3njSgQEiE
//         qxeHChCv
//         -----END PRIVATE KEY-----"""
//     );
//
//     // 2. Define Claims (Payload)
//     final issuedAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     final expiration = issuedAt + EXPIRATION_SECONDS;
//
//     final payload = {
//       // Required Claims:
//       "iss": ISSUER_ID, // Issuer ID
//       "iat": issuedAt,  // Issued At (Unix timestamp in seconds)
//       "exp": expiration, // Expiration Time (Max 300 seconds after iat)
//       "aud": AUDIENCE, // Audience
//       // "bid": BUNDLE_ID, // Bundle ID of your app
//     };
//
//     // 3. Define Header and Sign the Token
//     final jwt = JWT(
//         payload,
//         header: {
//           "alg": "ES256", // Algorithm must be ES256
//           "kid": KEY_ID,  // Key ID
//           "typ": "JWT"
//         }
//     );
//
//     // Sign the JWT with the ECPrivateKey
//     final token = jwt.sign(
//         ecPrivateKey,
//         algorithm: JWTAlgorithm.ES256 // Explicitly specify ES256
//     );
//
//     return token;
//   } on FileSystemException {
//     // print("ERROR: Private key file not found at $PRIVATE_KEY_PATH.");
//     rethrow;
//   } on JWTException catch (e) {
//     lg.e("ERROR generating JWT: ${e.message}");
//     rethrow;
//   } catch (e) {
//     lg.e("An unexpected error occurred: $e");
//     rethrow;
//   }
// }
//
// /// intentifier from myProductList[0]
// purchaseIAP_Platform(BuildContext context, WidgetRef ref, String identifier) async{
//
//     // RC_InitVendorCustomerStatus(ref);
//     //
//     // // Package p = Package(
//     // //   identifier,
//     // //   PackageType.
//     // // );
//     // try {
//     //
//     //   PurchaseResult purchaseResult =
//     //       await Purchases.purchasePackage(
//     //         identifier
//     //       );
//     //
//     //   lg.t("purchased package result ~ " + purchaseResult.toString());
//     //
//     //   EntitlementInfo? entitlement = purchaseResult
//     //       .customerInfo.entitlements.all[vendorBasicAccountEntitlementID];
//     //
//     //   lg.t("entitlement ~ " + entitlement.toString());
//     //
//     //   ref.read(vendorHasSubscriptionProv.notifier).state =
//     //       entitlement?.isActive ?? false;
//     //
//     //   Navigator.pop(context, entitlement);
//     // } catch (e) {
//     //   lg.e(e.toString());
//     //   Navigator.pop(context);
//     // }
//
//   // else{
//   //   /// moved
//   //   /// getMobileCustomerStatus(ref);
//   // }
// }
// /// moved into paywall
//
// Future<bool> allowVendorLoginOrPaywall(BuildContext context, WidgetRef ref, String userId, bool purchaseEver) async {
//   // loadingStateCB(true);
//     lg.t("[allowVendorLoginOrPaywall] entitlement is not active");
//     Offerings? offerings;
//     Map <String,Offering?> vendorLoginOfferings; /// convert to map
//     try {
//       lg.t("get offerings");
//       offerings = await Purchases.getOfferings();
//
//       lg.t("got offerings ~ " + offerings.toString());
//       lg.t("offerings all ~ " + offerings.all.toString());
//
//       vendorLoginOfferings = offerings.all;
//       lg.t("get offerings all complete");
//     } catch (e) {
//       lg.e(e.toString());
//       throw Exception("Purchase error");
//     }
//
//     lg.t("check offereings and show sheet");
//
//     if (vendorLoginOfferings.isEmpty) {
//       lg.e("offerings is null");
//       throw Exception("Subscription offerings not found");
//     } else {
//       // if (products == null || products.current == null) {
//       //   lg.t("products is null");
//       // } else {
//       // current offering is available, show paywall
//
//       lg.t("check showed recent");
//       /// paywall showing twice from push to home and after "found vendor needs paywall" doing hack for reasons
//       if (ref.read(showedRecentPaywallSheet)){
//         lg.t("show recent true returning null");
//         return false;
//       }
//       else{
//         lg.t("run paywall trigger");
//         triggerPaywallTrigger(ref);
//       }
//
//       return await showModalBottomSheet(
//         useRootNavigator: true,
//         isDismissible: true,
//         isScrollControlled: true,
//
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//         ),
//         context: gNavigatorKey.currentContext!,
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setModalState) {
//                 lg.t("builder ret VendorLoginPaywall_RC");
//                 return VendorLoginPaywall_RC(
//                     // customerInfo: customerInfo,
//                     // offering: vendorLoginOffering!,
//                     purchaseEver: purchaseEver,
//                     offerings: vendorLoginOfferings
//                 );
//               });
//         },
//       );
//     }
//
// }
//
// /// return [hasActiveEntitlement, purchaseEver]
// Future<List<bool>> checkVendorEntitlement(ref, userId)async{
//   lg.t("checkVendorEntitlement call web");
//
//   try {
//     var gas_resp = await getAccountSub(userId);
//
//     if (gas_resp["accountLevel"] == vendorBasicAccountLevelID) {
//       lg.t("gas resp found user subbed skip purchases");
//       return [true, gas_resp["purchaseEver"]];
//     }
//     else {
//       return [false, gas_resp["purchaseEver"]];
//     }
//   } catch(e){
//     lg.w("user not found throws here");
//     return [false, false];
//   }
//
//   try {
//     lg.t("[checkVendorEntitlement] calling RC_PurchasesLogin");
//     await RC_PurchasesLogin(ref, userId);
//
//     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//
//     lg.t("check intro eligibility");
//
//
//     /// surprisingly does nothing
//     //  Map<String, IntroEligibility> pelg =  await Purchases.checkTrialOrIntroductoryPriceEligibility(["vendor_basic_monthly"]);
//     //  lg.t("check intro eligibility res ~ " + pelg.toString());
//     //  pelg.forEach((String productId, IntroEligibility eligibility) {
//     //    lg.d("Product: $productId, "
//     //        "Eligibility: ${eligibility.status}, "
//     //        "Description: ${eligibility.description}");
//     //  });
//
//     lg.t("got customer info ~ " + customerInfo.toString());
//
//     // if (customerInfo.entitlements.all[vendorBasicAccountEntitlementID] != null &&
//     //     customerInfo.entitlements.all[vendorBasicAccountEntitlementID]?.isActive == true) {
//     //   return [true];
//     // }
//
//     if (customerInfo.entitlements.active.isNotEmpty){
//       lg.t("return [true]");
//       return [true, true];
//     }
//
//     lg.t(
//         "[handleConvertAccountAndSignIn] allowVendorLoginOrPaywall passsed");
//       return [false, false];
//
//       // throw Exception(entitlementNullError);
//
//   }
//   catch (e) {
//     lg.w(
//         "Rethrowing not for error but because user does not have a subscription");
//     /// gets entitlement_resp is null
//     lg.w("Caught ~ " + e.toString());
//     rethrow;
//   }
//
//
// }
//
//
//
//
//
//
// purchasedStateAccountUpdate(ref, String productId) async {
//   lg.t("[purchasedStateAccountUpdate] called found purchased state");
//
//   try {
//     lg.t("call updateAccountSub");
//     lg.t("saving purchase id ~ " + productId.toString());
//     await updateAccountSub(ref.read(userAuthProv)!.userToken,
//     ref.read(userAuthProv)!.userId,
//     productId
//     );
//   } catch (e) {
//     lg.e("Exp caught updating user doc ~ " + e.toString());
//   }
//
//   lg.t("update provider");
//   var makeAuth = ref.read(userAuthProv)!.copyWith(
//       purchaseEver: true,
//       accountLevel: "vendor_basic"
//   );
//   ref
//       .read(userAuthProv.notifier)
//       .state = makeAuth;
//
//
//   ref.read(vendorIsFirstTimeAndJustPaidProv.notifier).state = true;
//   // Navigator.pushNamedAndRemoveUntil(
//   //     context, "/vendor_home", (route) => false);
//   Navigator.pushNamedAndRemoveUntil(
//       gNavigatorKey.currentContext!, "/vendor_home", (route) => false);
// }
//
//
//
//
//
// /// for basic vendor
// // const vendorOfferingID = 'connectme_vendor_basic_0';
// // const vendorEntitlementID = 'cm_vendor_basic_ent_0';
//
// // const vendorBasicAccountID = "Basic Vendor Account";
//
//
//
//
// Future<void> configure_RC_SDK() async {
//   // Enable debug logs before calling `configure`.
//   lg.t("[configure_RC_SDK] called");
//   await Purchases.setLogLevel(LogLevel.debug);
//
//   /*
//     - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//
//     - PurchasesAreCompletedyBy is PurchasesAreCompletedByRevenueCat, so Purchases will automatically handle finishing transactions. Read more about completing purchases here: https://www.revenuecat.com/docs/migrating-to-revenuecat/sdk-or-not/finishing-transactions
//     */
//   PurchasesConfiguration configuration;
//   // if (RCStoreConfig.isForAmazonAppstore()) {
//   //   configuration = AmazonConfiguration(RCStoreConfig.instance.apiKey)
//   //     ..appUserID = null
//   //     ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
//   // } else {
//   configuration = PurchasesConfiguration(appConfig.revenuecatApiKey)
//     ..appUserID = null
//     ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
//   // }
//   await Purchases.configure(configuration);
//   lg.t("[configure_RC_SDK] Purchases.configure complete");
// }
//
// Future<void> RC_InitVendorPlatformState(WidgetRef ref) async {
//
//   var preInfoUpdateUserId = await Purchases.appUserID;
//   lg.i("[Purchases.addCustomerInfoUpdateListener] set appUserID ~ " + preInfoUpdateUserId.toString());
//   ref.read(revcatAppUserIdProv.notifier).state = preInfoUpdateUserId;
//
//   CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//   EntitlementInfo? entitlement = customerInfo.entitlements.all[vendorBasicAccountEntitlementID];
//   ref.read(vendorHasSubscriptionProv.notifier).state = entitlement?.isActive ?? false;
//
//   Purchases.addCustomerInfoUpdateListener((CustomerInfo customerInfo) async {
//
//     lg.i("[Purchases.addCustomerInfoUpdateListener] fired ~ ");
//
//     var postInfoUpdateUserId = await Purchases.appUserID;
//     lg.i("[Purchases.addCustomerInfoUpdateListener] callback set appUserID ~ " + postInfoUpdateUserId.toString());
//     ref.read(revcatAppUserIdProv.notifier).state = postInfoUpdateUserId;
//
//     // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//     EntitlementInfo? entitlement = customerInfo.entitlements.all[vendorBasicAccountEntitlementID];
//     ref.read(vendorHasSubscriptionProv.notifier).state = entitlement?.isActive ?? false;
//
//   });
//
// }
//
// RC_RestorePurchases(WidgetRef ref) async {
//
//   /*
//       How to login and identify your users with the Purchases SDK.
//       Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//     */
//
//   try {
//     await Purchases.restorePurchases();
//     ref.read(revcatAppUserIdProv.notifier).state = await Purchases.appUserID;
//   } on PlatformException catch (e) {
//     lg.e("Error restoring purchases: ${e.message}");
//   }
//
// }
//
// RC_PurchasesLogin(WidgetRef ref, String appUserID) async {
//
//   /*
//       How to login and identify your users with the Purchases SDK.
//       Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//     */
//
//   lg.t("[RC_PurchasesLogin] called with appUserID ~ " + appUserID.toString());
//   try {
//     await Purchases.logIn(appUserID);
//     ref.read(revcatAppUserIdProv.notifier).state = await Purchases.appUserID;
//   } on PlatformException catch (e) {
//     lg.e("Error logging in to purchases: ${e.message}");
//   }
//
// }
//
//
// final userLeftPaywallProv = StateProvider<bool>((ref) => false);
//
//
//
//
// class VendorLoginPaywall_RC extends ConsumerStatefulWidget {
//   // final CustomerInfo customerInfo;
//   // final Offering offering;
//
//
//   const VendorLoginPaywall_RC({Key? key,
//     // required this.customerInfo,
//     required this.purchaseEver,
//     required this.offerings
//   }) : super(key: key);
//
//   final bool purchaseEver;
//   final Map <String,Offering?> offerings;
//
//   @override
//   VendorLoginPaywall_RCState createState() => VendorLoginPaywall_RCState();
// }
//
// class VendorLoginPaywall_RCState extends ConsumerState<VendorLoginPaywall_RC> {
//   @override
//   Widget build(BuildContext context) {
//
//
//     // lg.d("widget.customerInfo.allPurchaseDates.isNotEmpty ~ " + widget.customerInfo.allPurchaseDates.isNotEmpty.toString());
//
//     return
//       SingleChildScrollView(
//         child: SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               Container(
//
//                 padding: EdgeInsets.symmetric(horizontal: Gss.width * .03, vertical: Gss.height * .03),
//                 width: double.infinity,
//                 decoration:  BoxDecoration(
//                     color: appPrimarySwatch[700],
//                     borderRadius:
//                     BorderRadius.vertical(top: Radius.circular(25.0))),
//                 child: Center(
//                     child:
//                     Text('✨  ConnectMe Account',
//                         style:Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)
//                     )),
//               ),
//
//
//               Padding(
//                 padding:
//                 EdgeInsets.only(top: Gss.height * .03, bottom: Gss.height * .015, left: 16.0, right: 16.0),
//                 child: SizedBox(
//                   child: Text(
//                       widget.purchaseEver?
//                       "Free Trial: First month free for new users" :
//                       "Vendor access to the ConnectMe App platform"
//                       ,
//                       style: Theme.of(context).textTheme.titleMedium!
//                   ),
//                   width: double.infinity,
//                 ),
//               ),
//
//               Padding(
//                   padding: EdgeInsets.fromLTRB( Gss.width * .03, Gss.height * .015, Gss.width * .03, 0),
//                   child:ListView.builder(
//                     itemCount: widget.offerings.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       var offering = widget.offerings.values.toList()[index];
//
//                       var myProductList = offering!.availablePackages; /// only one package per offering
//                       return Card(
//                         color: Colors.black,
//                         child: ListTile(
//                             onTap: () async {
//
//                               lg.t("[VendorLoginPaywall] RC_InitVendorPlatformState call");
//                               RC_InitVendorPlatformState(ref);
//
//                               try {
//
//                                 lg.t("try purchase ~ " + myProductList[0].storeProduct.toString());
//
//                                 /// upgrade to bool, returned from modal into allowVendorLoginOrPaywall( which is typed
//                                 bool respForEntitlementFromModal = false;
//                                 CustomerInfo purchaseResult =
//                                 await Purchases.purchasePackage(
//                                     myProductList[0]);
//
//                                 lg.t("purchased package result ~ " + purchaseResult.toString());
//
//                                 EntitlementInfo? entitlement = purchaseResult
//                                     .entitlements.all[vendorBasicAccountEntitlementID];
//
//                                 lg.t("entitlement ~ " + entitlement.toString());
//
//                                 respForEntitlementFromModal = entitlement?.isActive?? false;
//                                 ref.read(vendorHasSubscriptionProv.notifier).state =
//                                     respForEntitlementFromModal;
//
//                                 if (respForEntitlementFromModal){
//                                   lg.t("call purchasedStateAccountUpdate");
//                                   purchasedStateAccountUpdate(ref, myProductList[0].storeProduct.identifier );
//                                 }
//
//                                 lg.t("pop entitlement");
//                                 Navigator.pop(gNavigatorKey.currentContext!, respForEntitlementFromModal);
//                               } catch (e) {
//                                 lg.e(e.toString());
//                                 Navigator.pop(gNavigatorKey.currentContext!, false);
//                               }
//
//                             },
//                             title:
//                             Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: Gss.width * .02, vertical: Gss.width * .01),
//                                 child:Text(
//                                   myProductList[0].storeProduct.title,
//                                   style: Theme.of(gNavigatorKey.currentContext!).textTheme.bodyLarge!.copyWith(color: Colors.white),
//                                   // style: kTitleTextStyle,
//                                 )),
//                             // subtitle: Text(
//                             //   myProductList[0].storeProduct.description,
//                             //   style: Theme.of(gNavigatorKey.currentContext!).textTheme.bodyLarge!.copyWith(color: Colors.white),
//                             //   // style: kDescriptionTextStyle.copyWith(
//                             //   //     fontSize: kFontSizeSuperSmall),
//                             // ),
//                             trailing: Text(
//                               myProductList[0].storeProduct.priceString,
//                               style: Theme.of(gNavigatorKey.currentContext!).textTheme.bodyLarge!.copyWith(color: Colors.white),
//                               // style: kTitleTextStyle
//                             )),
//                       );
//                     },
//                     shrinkWrap: true,
//                     physics: const ClampingScrollPhysics(),
//                   )),
//               Padding(
//                 padding:
//                 EdgeInsets.only(top: 8, bottom: 16, left: Gss.width * .06, right: Gss.width * .03),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Text(
//                       'Powered by Stripe ',
//                       style: Theme.of(gNavigatorKey.currentContext!).textTheme.bodyLarge!
//                   ),
//                 ),
//               ),
//
//
//
//               Padding(
//                 padding:
//                 EdgeInsets.only(top: 16, bottom: 6, left: 16.0, right: 16.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Text(
//                       "3 days billing grace period for renewals",
//                       style: Theme.of(gNavigatorKey.currentContext!).textTheme.bodyLarge!
//                   ),
//                 ),
//               ),
//
//               Padding(
//                 padding:
//                 EdgeInsets.only(top: 12, bottom: 16, left: 16.0, right: 16.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Text(
//                       subscriptionPaywallFinePrintText,
//                       style: Theme.of(gNavigatorKey.currentContext!).textTheme.bodyLarge!
//                   ),
//                 ),
//               ),
//
//
//
//             ],
//           ),
//         ),
//       );
//   }
// }