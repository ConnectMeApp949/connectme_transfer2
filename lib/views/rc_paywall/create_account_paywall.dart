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
//                               },
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



