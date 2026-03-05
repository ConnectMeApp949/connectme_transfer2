// class PaywallTestPage extends ConsumerStatefulWidget {
//   const PaywallTestPage({super.key});
//
//   @override
//   ConsumerState<PaywallTestPage> createState() => _PaywallTestPageState();
// }
//
// class _PaywallTestPageState extends ConsumerState<PaywallTestPage> {
//   bool _isLoading = false;
//
//   /*
//     We should check if we can magically change the weather
//     (subscription active) and if not, display the paywall.
//   */
//   void perfomMagic(WidgetRef ref) async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     await purchasesLogin(ref, "test_customer_1");
//
//     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//
//     lg.t("got customer info ~ " + customerInfo.toString());
//
//     if (customerInfo.entitlements.all[entitlementID] != null &&
//         customerInfo.entitlements.all[entitlementID]?.isActive == true) {
//       // appData.currentData = WeatherData.generateData();
//
//       /// USER IS PREMIUM
//       showErrorDialog(context, "USER DID A PREMIUM");
//
//       setState(() {
//         _isLoading = false;
//       });
//     } else {
//       lg.t("premium entitlement is not active");
//       Offerings? offerings;
//       try {
//         lg.t("get offerings");
//         offerings = await Purchases.getOfferings();
//         // lg.t("got offerings ~ " + offerings.toString());
//         lg.t("offerings all ~ " + offerings.all.toString());
//       } on PlatformException catch (e) {
//         showErrorDialog(context, "Purchase error");
//       }
//
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       if (offerings == null || offerings.current == null) {
//         lg.t("offerings is null");
//       } else {
//       // if (products == null || products.current == null) {
//       //   lg.t("products is null");
//       // } else {
//       // current offering is available, show paywall
//         await showModalBottomSheet(
//           useRootNavigator: true,
//           isDismissible: true,
//           isScrollControlled: true,
//
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//           ),
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setModalState) {
//                   return Paywall(
//                     offering: offerings!.current!,
//                   );
//                 });
//           },
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return
//     _isLoading?  Container(
//       child: const Center(child: CircularProgressIndicator()),
//     ):
//
//       Scaffold(
//           body: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 30.0),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Text(
//                          "FIRST THING"
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 15.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.near_me),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                     "sECOND THING"),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 30.0),
//                   child: TextButton(
//                     onPressed: () => perfomMagic(ref),
//                     child: Text(
//                       "✨ Change the Weather",
//                     ),
//                   ),
//                 ),
//               ],
//           ),
//         );
//   }
// }
//
//
//
// class Paywall extends ConsumerStatefulWidget {
//   final Offering offering;
//
//   const Paywall({Key? key,
//     required this.offering
//   }) : super(key: key);
//
//   @override
//   _PaywallState createState() => _PaywallState();
// }
//
// class _PaywallState extends ConsumerState<Paywall> {
//   @override
//   Widget build(BuildContext context) {
//     return
// SingleChildScrollView(
//       child: SafeArea(
//         child: Wrap(
//           children: <Widget>[
//             Container(
//               height: 70.0,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                   color: Colors.purple,
//                   borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(25.0))),
//               child: const Center(
//                   child:
//                   Text('✨ Magic Weather Premium',)),
//             ),
//             const Padding(
//               padding:
//               EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
//               child: SizedBox(
//                 child: Text(
//                   'MAGIC WEATHER PREMIUM',
//                   // style: kDescriptionTextStyle,
//                 ),
//                 width: double.infinity,
//               ),
//             ),
//             ListView.builder(
//               itemCount: widget.offering.availablePackages.length,
//               itemBuilder: (BuildContext context, int index) {
//                 var myProductList = widget.offering.availablePackages;
//                 return Card(
//                   color: Colors.black,
//                   child: ListTile(
//                       onTap: () async {
//                         try {
//                           PurchaseResult purchaseResult =
//                           await Purchases.purchasePackage(
//                               myProductList[index]);
//                           lg.t("purchased package result ~ " + purchaseResult.toString());
//
//                           EntitlementInfo? entitlement = purchaseResult
//                               .customerInfo.entitlements.all[entitlementID];
//
//                           lg.t("entitlement ~ " + entitlement.toString());
//
//                           ref.read(vendorHasSubscriptionProv.notifier).state =
//                               entitlement?.isActive ?? false;
//
//                         } catch (e) {
//                           print(e);
//                         }
//
//                         setState(() {});
//                         Navigator.pop(context);
//                       },
//                       title: Text(
//                         myProductList[index].storeProduct.title,
//                         // style: kTitleTextStyle,
//                       ),
//                       subtitle: Text(
//                         myProductList[index].storeProduct.description,
//                         // style: kDescriptionTextStyle.copyWith(
//                         //     fontSize: kFontSizeSuperSmall),
//                       ),
//                       trailing: Text(
//                           myProductList[index].storeProduct.priceString,
//                           // style: kTitleTextStyle
//                       )),
//                 );
//               },
//               shrinkWrap: true,
//               physics: const ClampingScrollPhysics(),
//             ),
//             const Padding(
//               padding:
//               EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
//               child: SizedBox(
//                 child: Text(
//                   "APP POLICY GOES HERE",
//                   // style: kDescriptionTextStyle,
//                 ),
//                 width: double.infinity,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }