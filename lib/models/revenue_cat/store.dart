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
// final revcatAppUserIdProv = StateProvider<String?>((ref) => null);
// // final userIsPremiumProv = StateProvider<bool>((ref) => false);
//
// final vendorHasSubscriptionProv = StateProvider<bool>((ref) => false);
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
// /// supposed to return this
// ///  EntitlementInfo? entitlement_resp
// // Future<EntitlementInfo?> allowVendorLoginOrPaywall(BuildContext context,WidgetRef ref, String userId) async {
//   // // loadingStateCB(true);
//   //
//   // lg.t("[allowVendorLoginOrPaywall] calling RC_PurchasesLogin");
//   // await RC_PurchasesLogin(ref, userId);
//   //
//   // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//   //
//   // lg.t("check intro eligibility");
//   //
//   //
//   // /// surprisingly does nothing
//   // //  Map<String, IntroEligibility> pelg =  await Purchases.checkTrialOrIntroductoryPriceEligibility(["vendor_basic_monthly"]);
//   // //  lg.t("check intro eligibility res ~ " + pelg.toString());
//   // //  pelg.forEach((String productId, IntroEligibility eligibility) {
//   // //    lg.d("Product: $productId, "
//   // //        "Eligibility: ${eligibility.status}, "
//   // //        "Description: ${eligibility.description}");
//   // //  });
//   //
//   //
//   //
//   // lg.t("got customer info ~ " + customerInfo.toString());
//   //
//   // if (customerInfo.entitlements.all[vendorBasicAccountEntitlementID] != null &&
//   //     customerInfo.entitlements.all[vendorBasicAccountEntitlementID]?.isActive == true) {
//   //   // appData.currentData = WeatherData.generateData();
//   //
//   //   /// USER IS PREMIUM might get here from flow if I don't know what's going on
//   //
//   //   return customerInfo.entitlements.all[vendorBasicAccountEntitlementID];
//   //   // loadingStateCB(false);
//   // }
//   // else {
//   //   lg.t(" entitlement is not active");
//   //   Offerings? offerings;
//   //   Map <String,Offering?> vendorLoginOfferings; /// convert to map
//   //   try {
//   //     lg.t("get offerings");
//   //     offerings = await Purchases.getOfferings();
//   //
//   //     lg.t("got offerings ~ " + offerings.toString());
//   //     lg.t("offerings all ~ " + offerings.all.toString());
//   //
//   //     vendorLoginOfferings = offerings.all;
//   //     lg.t("get offerings all complete");
//   //   } catch (e) {
//   //     lg.e(e.toString());
//   //     throw Exception("Purchase error");
//   //   }
//   //
//   //   lg.t("check offereings and show sheet");
//   //
//   //   if (vendorLoginOfferings.isEmpty) {
//   //     lg.e("offerings is null");
//   //     throw Exception("Subscription offerings not found");
//   //   } else {
//   //     // if (products == null || products.current == null) {
//   //     //   lg.t("products is null");
//   //     // } else {
//   //     // current offering is available, show paywall
//   //
//   //     lg.t("check showed recent");
//   //     /// paywall showing twice from push to home and after "found vendor needs paywall" doing hack for reasons
//   //     if (ref.read(showedRecentPaywallSheet)){
//   //       lg.t("show recent true returning null");
//   //       return null;
//   //     }
//   //     else{
//   //       lg.t("run paywall trigger");
//   //       triggerPaywallTrigger(ref);
//   //     }
//   //
//   //     return await showModalBottomSheet(
//   //       useRootNavigator: true,
//   //       isDismissible: true,
//   //       isScrollControlled: true,
//   //
//   //       shape: const RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//   //       ),
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return StatefulBuilder(
//   //             builder: (BuildContext context, StateSetter setModalState) {
//   //               return VendorLoginPaywall(
//   //                   customerInfo: customerInfo,
//   //                   // offering: vendorLoginOffering!,
//   //                   offerings: vendorLoginOfferings
//   //               );
//   //             });
//   //       },
//   //     );
//   //   }
//   // }
//   // return null;
// // }
//
// // runPaywallSubroutineForVendor(BuildContext context, /// wanted to avoid but also wanted to keep nav push in here
// //     WidgetRef ref, String userId) async {
// //   bool pw_success = false;
// //
// //   /// to avoid try catch loading pop stuff
// //   try {
// //     EntitlementInfo? entitlement_resp = await allowVendorLoginOrPaywall(context,
// //         ref, userId);
// //     lg.t("allowVendorLoginOrPaywall passsed");
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
// // runOnboardingBeforePaywall(BuildContext context, WidgetRef ref, String foundUserId){
// //   lg.t("[runOnboardingBeforePaywall] called");
// //   Navigator.push(context, MaterialPageRoute(builder: (context) {
// //     return  OnboardingScreen(userType: UserType.vendor,
// //         onboardingCompletedFn: (WidgetRef ref)async{ /// very subtle and tricky, Pretty sure context is fine for the pushNameAndRemoveUntil from "MaterialPageRoute(builder: (context) {" but the       "ref.read(runPaywallSubroutineForVendorErrorProv" will error without passing ref explicityl
// //           if (appConfig.bypassPaywall ||
// //               ref.read(vendorHasSubscriptionProv) /// dont think this is actually going to exist ever unless maybe they pay get an error, account is created and we have to check somewhere else still
// //           ) {
// //             Navigator.pushNamedAndRemoveUntil(
// //                 context, "/vendor_home", (route) => false);
// //             return;
// //           }
// //           else {
// //             lg.t("Found vendor needs paywall");
// //             try {
// //               NavigatorPop_MountedSafe(context); /// pop loading screen
// //               await runPaywallSubroutineForVendor(context,
// //                   ref, foundUserId);
// //             }catch(e){
// //               lg.e("error caught from runPaywallSubroutineForVendor ~ " + e.toString());
// //               ref.read(runPaywallSubroutineForVendorErrorProv.notifier).state = true;
// //               Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
// //             }
// //           }
// //         }
// //     );
// //   }));
// // }
