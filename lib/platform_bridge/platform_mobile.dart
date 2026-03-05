

import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/methods/etc.dart';
import 'package:connectme_app/models/revenue_cat/store.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/user/get_account_sub.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/views/onboarding/onboarding_screens/obc_1.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
/// import 'dart:ui' as ui; // Needed for ui.Image
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';

/// calendar
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
/// / calendar

import 'dart:async';

import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/requests/user/get_account_sub.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';



import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// final iap = FlutterInappPurchase();

initializeInAppPurchase(WidgetRef ref) async {
  Stripe.publishableKey = appConfig.stripePublishableKey;

  final iap = FlutterInappPurchase.instance;
  await iap.initConnection();
  /// instantiate provider because listeners
  var initProvPurchase = ref.watch(purchasesProvider);
}


void doPlatformThing() {
  lg.d('Running on ${io.Platform.operatingSystem}');
}

Future<Uint8List?> pickImageAndConvertToJpeg() async{
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) return null;

  final Uint8List imageBytes = await pickedFile.readAsBytes();

  // Decode to image package format (works with PNG, HEIC, etc.)
  final img.Image? decodedImage = img.decodeImage(imageBytes);
  if (decodedImage == null) return null;

  // Re-encode as JPEG (quality: 0–100)
  final Uint8List jpegBytes = Uint8List.fromList(
    img.encodeJpg(decodedImage, quality: 85),
  );

  return jpegBytes;
}


String? getAccessTokenFromHash() {
  throw("Unsupported Error");
}

runOauthRedirectHandlers(){
  throw("Unsupported Error");
}


openHtmlWindow(String urlToOpen)async{
  // throw("Unsupported Error");
  final Uri url = Uri.parse(urlToOpen);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.platformDefault);
  }
}




final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    calendar.CalendarApi.calendarScope,
  ],
);

Future<void> signInAndFetchCalendar() async {
  final account = await _googleSignIn.signIn();
  final auth = await account?.authentication;

  final client = authenticatedClient(
    http.Client(),
    auth!.accessToken!,
  );

  calendar.CalendarApi calendarApi = calendar.CalendarApi(client);
  calendar.CalendarList calendarList =
  await calendarApi.calendarList.list(
    showHidden: true
  );
  // CalendarListEntry

  for (var cal in calendarList.items ?? []) {
    lg.t("cal.summary ~ " + cal.summary);
    lg.t("cal.id ~ " + cal.id);
    lg.t("cal.primary ~ " + cal.primary.toString());
    // lg.t("cal.colorId ~ " + cal.colorId);
    // lg.t("cal.backgroundColor ~ " + cal.backgroundColor);
    // lg.t("cal.hidden ~ " + cal.hidden);
    // lg.t("cal.selected ~ " + cal.selected);
    // lg.t("cal.accessRole ~ " + cal.accessRole);
    // lg.t("cal.defaultReminders ~ " + cal.defaultReminders);
    // lg.t("cal.description ~ " + cal.description);
    // lg.t("cal.summaryOverride ~ " + cal.s#ummaryOverride);

    lg.t("cal items ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

    lg.t("cal.kind ~ " + cal.kind);

    lg.t("cal items ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    // for (var item in cal.items ?? []) {
      // lg.t("item.id ~ " + item.id);
      // lg.t("item.kind ~ " + item.kind);
      // lg.t("item.etag ~ " + item.etag);
      // lg.t("item.status ~ " + item.status);
      // lg.t("item.htmlLink ~ " + item.htmlLink);
      // lg.t("item.created ~ " + item.created);
      // lg.t("item.updated ~ " + item.updated);
      // lg.t("item.summary ~ " + item.summary);
      // lg.t("item.description ~ " + item.description);
      // lg.t("item.location ~ " + item.location);
      // lg.t("item.colorId ~ " + item.colorId);
      // lg.t("item.creator ~ " + item.creator);
      // lg.t("item.organizer ~ " + item.organizer);
      // lg.t("item.start ~ " + item.start);
      // lg.t("item.end ~ " + item.end);
      // lg.t("item.recurrence ~ " + item.recurrence);
      // lg.t("item.recurringEventId ~ " + item.recurringEventId);
      // lg.t("item.originalStartTime ~ " + item.originalStartTime);
      // lg.t("item.transparency ~ " + item.transparency);
      // lg.t("item.visibility ~ " + item.visibility);
      // lg.t("item.iCalUID ~ " + item.iCalUID);
      // lg.t("item.sequence ~ " + item.sequence);
      // lg.t("item.reminders ~ " + item.reminders);
      // lg.t("item.extendedProperties ~ " + item.extendedProperties);
      // lg.t("item.attendees ~ " + item.attendees);
      // lg.t("item.attendeesOmitted ~ " + item.attendeesOmitted);
      // lg.t("item.hangoutLink ~ " + item.hangoutLink);
      // lg.t("item.conferenceData ~ " + item.conferenceData);
      // lg.t("item.gadget ~ " + item.gadget);
      // lg.t("item.anyoneCanAddSelf ~ " + item.anyoneCanAddSelf);
      // lg.t("item.guestsCanInviteOthers ~ " + item.guestsCanInviteOthers);
      // lg.t("item.guestsCanModify ~ " + item.guestsCanModify);
      // lg.t("item.guestsCanSeeOtherGuests ~ " + item.guestsCanSeeOtherGuests);
      // lg.t("item.privateCopy ~ " + item.privateCopy);
      // lg.t("item.locked ~ " + item.locked);
      //
      // lg.t("item.reminders.overrides ~ " + item.reminders!.overrides);
      // lg.t("item.reminders.useDefault ~ " + item.reminders!.useDefault);
      //
      // lg.t("item.attendees.overrides ~ " + item.attendees!.overrides);
      // lg.t("item.attendees.useDefault ~ " + item.attendees!.useDefault);
      //
      // lg.t("item.conferenceData.entryPoints ~ " +
      //     item.conferenceData!.entryPoints);
      // lg.t("item.conferenceData.notes ~ " + item.conferenceData!.notes);
      // lg.t("item.conferenceData.parameters ~ " +
      //     item.conferenceData!.parameters);
      // lg.t("item.conferenceData.signature ~ " + item.conferenceData!.signature);
      //
      // lg.t("item.gadget.display ~ " + item.gadget!.display);
      // lg.t("item.gadget.height ~ " + item.gadget!.height);
      // lg.t("item.gadget.iconLink ~ " + item.gadget!.iconLink);
      // lg.t("item.gadget.link ~ " + item.gadget!.link);
      // lg.t("item.gadget.preferences ~ " + item.gadget!.preferences);
      // lg.t("item.gadget.title ~ " + item.gadget!.title);
      // lg.t("item.gadget.type ~ " + item.gadget!.type);
      // lg.t("item.gadget.width ~ " + item.gadget!.width);
    // }

    calendar.Events events = await calendarApi.events.list(cal.id);

    for (var event in events.items ?? []) {
      final start = event.start?.dateTime ?? event.start?.date;
      final end = event.end?.dateTime ?? event.end?.date;

      lg.t('    Event: ${event.summary}');
      lg.t('   Start: $start');
      lg.t('   End:   $end');
    }


  }
}

http.Client authenticatedClient(http.Client baseClient, String accessToken) {
  return AuthClient(accessToken, baseClient);
}

class AuthClient extends http.BaseClient {
  final String _accessToken;
  final http.Client _inner;

  AuthClient(this._accessToken, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _inner.send(request);
  }
}

/// flutter_inapp_purchase plus implementation
// callSubscriptionConfig(
//     // apiKey
//     ) async {
//   lg.t("[callSubscriptionConfig] called");
//   var _kProductIds = ["vendor_basic_monthly_2", "vendor_basic_annual_2"];
//
//   List<String> prod_identifiers = ["vendor_basic_annual", "vendor_basic_monthly"];
//
//   lg.t("Call initialize");
//   await FlutterInappPurchase.instance.initialize();
//
//   lg.t("call test connection");
//
//   List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(prod_identifiers);
//   for (var item in items) {
//     print('${item.toString()}');
//   }
//
//   // Future<void> _initializeIAP() async {
//   //   await iap.initConnection();
//   // }
//
//
// }


/// flutter_inapp_purchase implementation 5.6.2
Future<List> callSubscriptionConfig(
    // apiKey
    // String userId
    ) async {
  lg.t("[callSubscriptionConfig] called");

  // List<ProductSubscription>? products;

  List<String> prod_identifiers = vendorBasicProductsAndroid;

  if (Platform.isIOS){
    prod_identifiers = vendorBasicProductsIos;
  }

  final iap = FlutterInappPurchase.instance;
   var fp_products = await iap.fetchProducts(
    skus: prod_identifiers,
    type: ProductQueryType.Subs,
  );

  lg.t("fpprod ! " + fp_products.toString());

  return fp_products;

}


purchaseIAP_Platform(BuildContext context, WidgetRef ref, String identifier) {

}
/// moved into paywall


/// return [hasActiveEntitlement, purchaseEver]
Future<List<bool>> checkVendorEntitlement(ref, userId)async{

  lg.t("[checkVendorEntitlement] called mobile");

  try {
    var gas_resp = await getAccountSub(userId);

    if (gas_resp["accountLevel"] == vendorBasicAccountLevelID) {
      lg.t("gas resp found user subbed skip purchases");
      return [true, gas_resp["purchaseEver"]];
    }
    else {
      return [false, gas_resp["purchaseEver"]];
    }
  } catch(e){
    lg.w("user not found throws here");
    return [false, false];
  }

}


runOnboardingBeforePaywall(BuildContext context, WidgetRef ref, String foundUserId, bool purchaseEver) async {
  lg.t("[runOnboardingBeforePaywall] called");
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return  OnboardingScreen(userType: UserType.vendor,
        onboardingCompletedFn: (WidgetRef ref)async{ /// very subtle and tricky, Pretty sure context is fine for the pushNameAndRemoveUntil from "MaterialPageRoute(builder: (context) {" but the       "ref.read(runPaywallSubroutineForVendorErrorProv" will error without passing ref explicityl
          if (appConfig.bypassPaywall ||
              ref.read(vendorHasSubscriptionProv) /// dont think this is actually going to exist ever unless maybe they pay get an error, account is created and we have to check somewhere else still
          ) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/vendor_home", (route) => false);
            return;
          }
          else {
            lg.t("Found vendor needs paywall");
            try {
              NavigatorPop_MountedSafe(context); /// pop loading screen

              /// [CRF]
              await runPaywallSubroutineForVendor(context,
                  ref, foundUserId, purchaseEver);

            }catch(e){
              lg.e("error caught from runPaywallSubroutineForVendor ~ " + e.toString());
              ref.read(runPaywallSubroutineForVendorErrorProv.notifier).state = true;
              Navigator.pushNamedAndRemoveUntil(gNavigatorKey.currentContext!, "/login", (route) => false);
            }
          }
        }
    );
  }));
}


runPaywallSubroutineForVendor(BuildContext context, /// wanted to avoid but also wanted to keep nav push in here
    WidgetRef ref, String userId, bool purchaseEver) async {
  bool pw_success = false;

  /// to avoid try catch loading pop stuff
  try {

    lg.t("await allowVendorLoginOrPaywall");
    bool? vendorSubbed = await allowVendorLoginOrPaywall(context,
        ref, userId, purchaseEver);
    lg.t("[runPaywallSubroutineForVendor] allowVendorLoginOrPaywall passed");
    // if (vendorSubbed != null ) {
      lg.t("entitlement_resp is not null");
      if (vendorSubbed) {
        lg.t("entitlement is active");
        pw_success = true;
      }
      else {
        lg.t("entitlement is not active");
      }
    // }
  }
  catch (e) {
    rethrow;
  }

  if (pw_success) {
    ref
        .read(vendorIsFirstTimeAndJustPaidProv.notifier)
        .state = true;
    Navigator.pushNamedAndRemoveUntil(
        gNavigatorKey.currentContext!, "/vendor_home", (route) => false);

    /// keep out of try catch or it will pop back for insig error maybe
  }
  else{
    lg.w("Throwing exp 73");
    throw Exception("Something went wrong: 73");
  }
}



Future<void> configure_RC_SDK() async {
 lg.t("[configure_RC_SDK] called" );

}


// Future<void> handle_AIP_Purchase(Purchase purchase) async {
//   // 1. Validate purchase on your server (required for production)
//   // final isValid = await verifyPurchaseOnServer(purchase);
//   // if (!isValid) return;
//
//   // 2. Deliver content to user
//   // await deliverContent(purchase.productId);
//
//   // 3. Finish transaction
//   // await iap.finishTransaction(
//   //   purchase: purchase,
//   //   isConsumable: true, // or false for non-consumables/subscriptions
//   // );
// }

/// supposed to return this
///  EntitlementInfo? entitlement_resp

Future<bool> allowVendorLoginOrPaywall(BuildContext context, WidgetRef ref, String userId, bool purchaseEver) async {
  // loadingStateCB(true);
  lg.t("[allowVendorLoginOrPaywall mobile] called");


  // showErrorDialog(context, "Showing normal dialog in orPaywall");
  // return false;

  return await showModalBottomSheet(
    // useRootNavigator: true,
    // isDismissible: true,
    // isScrollControlled: true,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            lg.t("StatefulBuilder build VendorLoginPaywall_Mobile(");
            return VendorLoginPaywall_Mobile(
                userId: userId,
                purchaseEver: purchaseEver
            );
          });
    },
  );

}

class VendorLoginPaywall_Mobile extends ConsumerStatefulWidget {
  const VendorLoginPaywall_Mobile({super.key,
    required this.userId,
    required this.purchaseEver
  });

  final String userId;
  final bool purchaseEver;

  @override
  ConsumerState<VendorLoginPaywall_Mobile> createState() => VendorLoginPaywall_MobileState();
}

class VendorLoginPaywall_MobileState extends ConsumerState<VendorLoginPaywall_Mobile> {


  List? subConfigResp;

  List prodSkus = [];

  @override
  void initState() {
    super.initState();
    lg.t("[VendorLoginPaywall_Mobile] initstate ");
    scheduleMicrotask(() async {
      lg.t("[VendorLoginPaywall_Mobile] get store offerings ");
      // List<ProductSubscription>?
      subConfigResp = await callSubscriptionConfig();
      lg.t("new subConfigResp ~ " + subConfigResp.toString());

      if (subConfigResp!=null) {
        for (var scr in subConfigResp!) {
          prodSkus.add(scr.id);
        }
      }

      setState(() {});
    });

  }

  // ProductSubscriptionAndroid psa;

  // makePurchase(ProductSubscription ps){
  makePurchase(String p_id) async{
  lg.t("[  makePurchase(String p_id){}] ~ " + p_id);
    // final ProductDetails productDetails = ... // Saved earlier from queryProductDetails().
    // final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    // if (_isConsumable(productDetails)) {
    // InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    // } else {
    // InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    // }
    //
    // final iap = FlutterInappPurchase();

    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // var props = RequestPurchaseAndroidProps(
    //   isOfferPersonalized: false,
    //   obfuscatedAccountIdAndroid: widget.userId,
    //   obfuscatedProfileIdAndroid: widget.userId,
    //   skus: [ps.id]
    // );
    //
    // var pprops = RequestPurchaseProps.subs(props);
    //
    // iap.requestPurchase();
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    final subsRequest = RequestPurchaseProps.subs((
    ios: RequestSubscriptionIosProps(
      andDangerouslyFinishTransactionAutomatically: true,
      sku: p_id,
    ),
    android: RequestSubscriptionAndroidProps(
      skus: [p_id],
    ),
    useAlternativeBilling: false,
    ));

    lg.t("subsRequest ~ " +subsRequest.toJson().toString());


    lg.t("init purchase connection");
    await FlutterInappPurchase.instance.initConnection();

    lg.t("call request purchase");
  await FlutterInappPurchase.instance.requestPurchase(
      subsRequest
  );


    /// Updates will be delivered to the `InAppPurchase.instance.purchaseStream`.

    /// https://hyochan.github.io/flutter_inapp_purchase/docs/6.8/guides/purchases
  /// 6.8 /// docs but doesnt work
  //        final requestProps = RequestPurchaseProps.inApp(
  //         request: RequestPurchasePropsByPlatforms(
  //           ios: RequestPurchaseIosProps(
  //             sku: productId,
  //             quantity: 1,
  //           ),
  //           android: RequestPurchaseAndroidProps(
  //             skus: [productId],
  //           ),
  //         ),
  //       );
  //
  //       await iap.requestPurchase(requestProps);

  }


  @override
  Widget build(BuildContext context) {
    //
    // if (true) {
    //   return Container(child: Text("test"));
    // }

    return
    (subConfigResp == null)?
         Container(child:Text("Loading")) :

      SingleChildScrollView(
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              Container(

                padding: EdgeInsets.symmetric(horizontal: Gss.width * .03, vertical: Gss.height * .03),
                width: double.infinity,
                decoration:  BoxDecoration(
                    color: appPrimarySwatch[700],
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
                child: Center(
                    child:
                    Text('✨  ConnectMe Account',
                        style:Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)
                    )),
              ),


              Padding(
                padding:
                EdgeInsets.only(top: Gss.height * .03, bottom: Gss.height * .015, left: 16.0, right: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                      (widget.purchaseEver==false)?
                      "Free Trial: First month free for new users" :
                      "Vendor access to the ConnectMe App platform"
                      ,
                      style: Theme.of(context).textTheme.titleMedium!
                  ),
                ),
              ),

              Padding(
                  padding: EdgeInsets.fromLTRB( Gss.width * .03, Gss.height * .015, Gss.width * .03, 0),
                  child:ListView.builder(
                    // itemCount: widget.offerings.length,
                    itemCount: subConfigResp?.length,
                    itemBuilder: (BuildContext context, int index) {
                      // var offering = widget.offerings.values.toList()[index];
                      // var myProductList = offering!.availablePackages; /// only one package per offering


                      return Container(
                        color: Colors.black,
                        child: ListTile(
                            onTap: () async {


                              lg.t("make purchase tap");
                                await makePurchase(prodSkus[index]);

                            },
                            title:
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: Gss.width * .02, vertical: Gss.width * .01),
                                child: Text(subConfigResp?[index].displayName??"",
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                                )
                            ),
                            trailing: Text(subConfigResp?[index].displayPrice??"",
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                            )
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  )),
              Padding(
                padding:
                EdgeInsets.only(top: 8, bottom: 16, left: Gss.width * .06, right: Gss.width * .03),
                child: SizedBox(
                  // child: Text(
                  //     'Secure Payment ',
                  //     style: Theme.of(context).textTheme.bodyLarge!
                  // ),
                  width: double.infinity,
                ),
              ),



              Padding(
                padding:
                EdgeInsets.only(top: 16, bottom: 6, left: 16.0, right: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                      "3 days billing grace period for renewals",
                      style: Theme.of(context).textTheme.bodyLarge!
                  ),
                ),
              ),

              Padding(
                padding:
                EdgeInsets.only(top: 12, bottom: 16, left: 16.0, right: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                      subscriptionPaywallFinePrintText,
                      style: Theme.of(context).textTheme.bodyLarge!
                  ),
                ),
              ),



            ],
          ),
        ),
      );
  }
}


// final purchasesProvider = NotifierProvider<PurchaseNotifier, Map>(
//       () => PurchaseNotifier(),
// );
// class PurchaseNotifier extends Notifier<Map> {


// final purchasesProvider = NotifierProvider<Map>((ref){
//   return {};
// });
//
//
// class PurchaseNotifier extends Notifier<Map> {

final purchasesProvider = NotifierProvider<PurchaseNotifier, Map>(
      () => PurchaseNotifier(),
);

class PurchaseNotifier extends Notifier<Map> {
  @override
  build() {
    // 'ref' here to watch other providers
///???????????????????????????????????????????????????????????????????
    lg.t("[PurchaseNotifier] build purchase notifier");
    _startListening();
    return {};
  }

  StreamSubscription<Purchase>? purchaseUpdatedSubscription;
  StreamSubscription<PurchaseError>? purchaseErrorSubscription;

  void _startListening() async{

    lg.t("purchase listening ~ _startListening");
    final iap = FlutterInappPurchase.instance;
    purchaseUpdatedSubscription = iap.purchaseUpdatedListener.listen(
          (purchase) async {

        // if (Platform.isAndroid) {
        lg.i('Purchase received: ${purchase.productId}');
        // lg.t("android purchase ack ~ " +
        //     purchase.androidIsAcknowledged.toString());
        lg.d("purchase full json ~ " +
            purchase.toJson().toString());
        // handle_AIP_Purchase(purchase);

        //       I/flutter ( 6958): 🖌 purchase full json ~ {__typename: PurchaseAndroid, autoRenewingAndroid: true, currentPlanId: null, dataAndroid: null, developerPayloadAndroid: , id: GPA.3333-4362-4266-87005, ids: [vendor_basic_monthly], isAcknowledgedAndroid: false, isAutoRenewing: true, obfuscatedAccountIdAndroid: , obfuscatedProfileIdAndroid: , packageNameAndroid: com.connectmeapp.connectmeapp, platform: android, productId: vendor_basic_monthly, purchaseState: purchased, purchaseToken: nbeggllmodfgkenlfknniigm.AO-J1OylxaaiBaN2AeZsIGPDYV3oOuQ-5ctTzZxGQXqCv2koYe934NkwOMV_acuLfrKhxWdglLacpFSXeOD_aODzTcL54Vf6Im21aNLhFiDZoT0fSh5Lcto, quantity: 1, signatureAndroid: IKWeTlDENrFhxsncoqAiJGlII74TnoLFfUqtj2jCu2PO1mh+8HJoWyMshGIuzHgw1tx9QTL4v35aWcwdKuiPXarD4WU/RIDC9lNg/pzg/gHqw9Nhw4XFaNYxx+dzxaJ+pJQB6xvAQrzeGtkyuqC9MkRO5X1oifvA/aMjjttG/WOecPgObmdQChUOjL/rWAhtwbjX1if9I0tMv5/Wu/USrL1yYq/07CPQnV13LS3uzYlgGkiqsUbQlYveuuCXwUBJDW+KbYa+jB8KdJJlUammEQedT6iQUF9yw5dB5GczAz+2HtJIVIUtIlVDF73RG2Sxn5tFo68UCofOaWPCfKqDww==, transactionDate: 1762711464229.0,
        //           I/flutter ( 6958): transactionId: GPA.3333-4362-4266-87005, isAlternativeBilling: null}

        state = purchase.toJson();

        if (purchase.purchaseState.value == "purchased") {
          purchasedStateAccountUpdate(ref, purchase.productId );
          // no ref no stuff


        }
      },
    );

    purchaseErrorSubscription = iap.purchaseErrorListener.listen(
          (error) {
        debugPrint('[purchaseListener] Purchase error: ${error.message}');
        showErrorDialog(gNavigatorKey.currentContext!, default_error_message, tag: "purchaseError Listener dialog");
      },
    );

  }


  clear(){
    state = {};
  }

// void _updatePurchases(PurchaseModel purchase) {
//   // Create a new map with the updated purchase data
//   // This is crucial: **Riverpod requires state to be immutable**.
//   state = {
//     ...state, // Spread the existing map
//     purchase.productId: purchase, // Add or overwrite the new purchase
//   };
//   // The state setter will automatically notify all listeners.
//   debugPrint('State updated with new purchase: ${purchase.productId}');
// }

// NOTE: In a real app, you must handle resource cleanup,
// like cancelling the stream subscription when the notifier is disposed.
// This is often why using StreamProvider or combining it with a Notifier
// can be simpler for external streams.
// @override
// void dispose() {
//   _purchaseSubscription.cancel();
//   super.dispose();
// }
}


purchasedStateAccountUpdate( ref, String productId) async {
  lg.t("[purchasedStateAccountUpdate] called found purchased state");

  try {
    lg.t("call updateAccountSub");
    lg.t("saving purchase id ~ " + productId.toString());
    await updateAccountSub(ref.read(userAuthProv)!.userToken,
        ref.read(userAuthProv)!.userId,
        productId
    );
  } catch (e) {
    lg.e("Exp caught updating user doc ~ " + e.toString());
  }

  lg.t("update provider");
  var makeAuth = ref.read(userAuthProv)!.copyWith(
      purchaseEver: true,
      accountLevel: "vendor_basic"
  );
  ref
      .read(userAuthProv.notifier)
      .state = makeAuth;


  ref.read(vendorIsFirstTimeAndJustPaidProv.notifier).state = true;
  // Navigator.pushNamedAndRemoveUntil(
  //     context, "/vendor_home", (route) => false);
  Navigator.pushNamedAndRemoveUntil(
      gNavigatorKey.currentContext!, "/vendor_home", (route) => false);
}




/// flutter_inapp_purchase implementation
// Future<void> _testConnection() async {
//   // final iap = FlutterInappPurchase(); // or FlutterInappPurchase.instance
//   try {
//     FlutterInappPurchase.instance.initialize();
//     // print('Connection result: $connected');
//
//     List<String> prod_ids = ["vendor_basic_annual"];
//     // Test product fetching
//     List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(prod_ids);
//     for (var item in items) {
//       print('${item.toString()}');
//     }
//     // print('Found ${result.value.length} products');
//     // print("connection products ~ " + products.toString());
//
//   } catch (e) {
//     print('Connection test failed: $e');
//   }
// }
//
// callSubscriptionConfig(
//     // apiKey
//     ) async {
//   lg.t("[callSubscriptionConfig] called");
//   var _kProductIds = ["vendor_basic_monthly_2", "vendor_basic_annual_2"];
//
//   Set<String> prod_identifiers = {"vendor_basic_annual", "vendor_basic_monthly"};
//
//   final iap = FlutterInappPurchase.instance;
//
//   // Future<void> _initializeIAP() async {
//   //   await iap.initConnection();
//   // }
//
//   lg.t("call test connection");
//   await _testConnection();
// }

/// in_app_purchase implementation
// callSubscriptionConfig(
//     // apiKey
//     ) async{
//
//   lg.t("[callSubscriptionConfig] called");
//   var _kProductIds = ["vendor_basic_monthly_2", "vendor_basic_annual_2"];
//
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = <String>[];
//   List<ProductDetails> _products = <ProductDetails>[];
//   List<PurchaseDetails> _purchases = <PurchaseDetails>[];
//   List<String> _consumables = <String>[];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;
//
//   final bool isAvailable = await InAppPurchase.instance.isAvailable().timeout(const Duration(seconds: 10));;
//
//   lg.t("[callSubscriptionConfig] _inAppPurchase.isAvailable ~ " + isAvailable.toString());
//
//   // if (!kIsWeb){
//   if (Platform.isIOS) {
//     final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//     InAppPurchase.instance
//         .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//     // fuck this
//     // await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     final ProductDetailsResponse productDetailResponse =
//     await InAppPurchase.instance.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       lg.t("productDetailResponse.error != null");
//
//       _queryProductError = productDetailResponse.error!.message;
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = <PurchaseDetails>[];
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = <String>[];
//       _purchasePending = false;
//       _loading = false;
//
//       lg.t("got prods ~ " + _products.toString());
//       return;
//     }
//
//   }
//
//   ///  od8@od8:~/.pub-cache/hosted/pub.dev$ grep -r "queryProductDetails" ./
//
//   // ./in_app_purchase_android-0.4.0+5/android/src/main/java/io/flutter/plugins/inapppurchase/Messages.java:                "dev.flutter.pigeon.in_app_purchase_android.InAppPurchaseApi.queryProductDetailsAsync"
//   if (Platform.isAndroid){
//   //   if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//   //     final InAppPurchaseAndroidPlatformAddition androidAddition =
//   //     _inAppPurchase.getPlatformAddition<
//   //         InAppPurchaseAndroidPlatformAddition>();
//   //     await androidAddition.consumePurchase(purchaseDetails);
//   //   }
//   // }
//   // if (purchaseDetails.pendingCompletePurchase) {
//   //   await _inAppPurchase.completePurchase(purchaseDetails);
//   // }
//
//     // var prod_identifiers = ["test"];
//
//     lg.t("run android store query");
//     Set<String> prod_identifiers = {"vendor_basic_annual", "vendor_basic_monthly"};
//
//     lg.t("android prod_identifiers ~ " + prod_identifiers.toString());
//     lg.t("run android do query");
//
//     try {
//       ProductDetailsResponse pdr = await InAppPurchase.instance.queryProductDetails(prod_identifiers).timeout(const Duration(seconds: 10));
//       lg.t("pdr ~ " + pdr.toString());
//     }catch(e){
//       lg.e("error getting ProductDetailsResponse ~ " + e.toString());
//     }
//
//
//     lg.t("run android store query complete");
//   }
//
// /// in_app_purchase_storekit-0.2.1/lib/src/in_app_purchase_storekit_platform.dart:  Future<ProductDetailsResponse> queryProductDetails(
//   if (Platform.isIOS){
//
//
//   }
// }



// callSubscriptionConfig(apiKey) async{
//   // String rc_web_api_key = apiKey;
//   // RCStoreConfig(
//   //   store: Store.appStore,
//   //   apiKey: rc_web_api_key,
//   //   /// NOT GOING TO WORK
//   // );
//
//   String bearerJWT = generateAppStoreServerJWT();
//   lg.t("[callSubscriptionConfig] mobile");
//   // String u = "https://api.storekit.itunes.apple.com/inApps/v2/history";
//   String u = "https://api.storekit-sandbox.itunes.apple.com/inApps/v2/history";
//
//   lg.t("make req with JWT ~ " + bearerJWT.toString());
//   final response = await http.get(Uri.parse(u),
//       headers:{
//     "Authorization": "Bearer $bearerJWT",
//     "Accept": "application/json"
//       }
//   );
//   lg.t("kresss ~ " + response.toString());
//   lg.t("kresss bod ~ " + response.body.toString());
//
// }