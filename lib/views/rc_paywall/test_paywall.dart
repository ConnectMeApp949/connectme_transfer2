// import 'package:connectme_app/components/ui/modals/error_dialog.dart';
// import 'package:connectme_app/config/logger.dart';
// import 'package:connectme_app/models/revenue_cat/store.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:purchases_flutter/models/customer_info_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import 'create_account_paywall.dart';
//
//
// class TestVendorLoginPaywallPage extends ConsumerStatefulWidget {
//   const TestVendorLoginPaywallPage({super.key});
//
//   @override
//   ConsumerState<TestVendorLoginPaywallPage> createState() => _TestVendorLoginPaywallPageState();
// }
//
// class _TestVendorLoginPaywallPageState extends ConsumerState<TestVendorLoginPaywallPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body:
//         Column(children: [
//           Center(
//               child: ElevatedButton(
//                   child: const Text('Test Vendor Login Paywall'),
//                   onPressed: () async {
//                     await RC_PurchasesLogin(ref, "test_vendor_login_paywall_user_0");
//
//                     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//
//                     lg.t("got customer info ~ " + customerInfo.toString());
//
//                     if (customerInfo.entitlements.all[vendorEntitlementID] !=
//                         null &&
//                         customerInfo.entitlements.all[vendorEntitlementID]
//                             ?.isActive == true) {
//                       lg.t("entitlement active");
//                     }
//                     else {
//                       lg.t(" entitlement is not active");
//                       Offerings? offerings;
//
//                       Offering? vendorLoginOffering;
//                       try {
//                         lg.t("get offerings");
//                         offerings = await Purchases.getOfferings();
//                         // lg.t("got offerings ~ " + offerings.toString());
//                         lg.t("offerings all ~ " + offerings.all.toString());
//
//                         vendorLoginOffering =
//                             offerings.getOffering(vendorOfferingID);
//                       } on PlatformException catch (e) {
//                         showErrorDialog(context, "Purchase error");
//                       }
//
//
//                       if (vendorLoginOffering == null) {
//                         lg.e("offerings is null");
//                         showErrorDialog(context, "offerings is null");
//                       }
//
//
//                       await showModalBottomSheet(
//                           useRootNavigator: true,
//                           isDismissible: true,
//                           isScrollControlled: true,
//
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(25.0)),
//                           ),
//                           context: context,
//                           builder: (BuildContext context) {
//                             return StatefulBuilder(
//                                 builder: (BuildContext context,
//                                     StateSetter setModalState) {
//                                   return VendorLoginPaywall(
//                                     offering: vendorLoginOffering!,
//                                   );
//                                 });
//                           }
//                       );
//                     }
//                   }
//               )),
//
//           ElevatedButton(
//               child: const Text('Test Vendor Success'),
//               onPressed: () async {
//                 // showWelcomeNewVendorDialog(context);
//
//               })
//           // appData.currentData = WeatherData.generateData();
//         ])
//
//     );
//   }
// }