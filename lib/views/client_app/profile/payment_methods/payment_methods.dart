import 'dart:async';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/providers/stripe.dart';
import 'package:connectme_app/requests/stripe/stripe_client.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectme_app/platform_bridge/platform_bridge.dart';


// import 'package:flutter_stripe_web/flutter_stripe_web.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// import 'dart:html' as html;

// Call this when client signs up
Future createClientCustomer(WidgetRef ref, String userToken, String clientUserId, String email) async {
  lg.t("createClientCustomer called");
  final response = await http.post(
    Uri.parse(create_stripe_client_customer_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': clientUserId,
      "authToken": userToken,
      // 'client_user_id': clientUserId, // cannot do, need auth by userId
      'email': email,
    }),
  );

  if (response.statusCode != 200) {
    /// response not used right now
    // throw Exception('Failed to create customer: ${response.body}');
    lg.e("error creating customer ~ " + response.body.toString());
    throw Exception("StripeConnectionError");
  }

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    lg.t("stripe customer create success resp ~ " + data.toString());
    ref.read(stripeCustomerIdProv.notifier).state = data["stripe_customer_id"];
    return data;
  }
}


// Call this when client enters card
// Future<String> setupClientPaymentMethod(String userToken, String clientUserId) async {
//   final setupIntentResp = await http.post(
//     Uri.parse(create_stripe_client_setup_intent_url),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'userId': clientUserId,
//       "authToken": userToken,
//       'client_user_id': clientUserId,
//     }),
//   );
//
//   if (setupIntentResp.statusCode != 200) {
//     throw Exception('Failed to create setup intent: ${setupIntentResp.body}');
//   }
//
//   final clientSecret = jsonDecode(setupIntentResp.body)['client_secret'];
//
//   /// not available on web
//   // // Present the Stripe card sheet
//   // await Stripe.instance.initPaymentSheet(
//   //   paymentSheetParameters: SetupPaymentSheetParameters(
//   //     merchantDisplayName: 'Connectme App',
//   //     customerId: null, // Optional
//   //     setupIntentClientSecret: clientSecret,
//   //   ),
//   // );
//   //
//   // await Stripe.instance.presentPaymentSheet();
//
//   return clientSecret;
//
//   print('✅ Payment method saved successfully');
// }

Future<void> openCheckoutForSetup(
    String userToken,
    String clientUserId,
    String customerId,
    String successUrl,
    String failUrl
    ) async {
  final uri = Uri.parse(create_client_stripe_checkout_setup_session);
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'authToken': userToken,
      'userId': clientUserId,
      'customer_id': customerId,
      'success_url': successUrl,
      'cancel_url': failUrl
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final checkoutUrl = data['url'] as String;

    if (kIsWeb){
    // html.window.open(checkoutUrl, '_blank');
      openHtmlWindow(checkoutUrl);
    }else {
      try {
        openHtmlWindow(checkoutUrl);
      } catch (e) {
        lg.e("Implement html window for mobile");
      }
    }


  } else {
    throw Exception('Failed to create checkout session: ${response.body}');
  }
}







class ClientPaymentMethodsPage extends ConsumerStatefulWidget {
  const ClientPaymentMethodsPage({super.key});

  @override
  ConsumerState<ClientPaymentMethodsPage> createState() => _ClientPaymentMethodsPageState();
}

class _ClientPaymentMethodsPageState extends ConsumerState<ClientPaymentMethodsPage> {

  bool initStripeLoading = true;
  bool accountSetupInit = false;
  bool accountSetupComplete = false;
  String accountStatusString = "incomplete"; ///

  String? client_setup_secret;

  List? linked_payment_method;

  @override
  void initState() {
    super.initState();
    refreshPaymentStatus();
  }

  refreshPaymentStatus(){
    scheduleMicrotask(()async {
      var resp = await getStripeClientAccountStatus(
          ref,
          ref.read(userAuthProv)!.userToken,
          ref.read(userAuthProv)!.userId);
      lg.t("getStripeClientAccountStatus client status resp " + resp.toString());
      if (resp["accountStatus"] == "not_created"){
        lg.t("getStripeClientAccountStatus resp account status not_created");
        accountSetupInit = false;
      }
      else{
        lg.t("getStripeClientAccountStatus resp account status else");
        accountSetupInit = true;
        accountStatusString = "in progress";

        if (!resp.containsKey("pay_methods") ){
          accountSetupComplete = false;
        }
        else if (resp.containsKey("pay_methods") &&  resp["pay_methods"].length < 1){
          accountSetupComplete = false;
        }else{
          accountStatusString = "complete";
          accountSetupComplete = true;
          linked_payment_method = resp["pay_methods"];
        }
      }
      lg.t("getStripeClientAccountStatus set loading complete");
      lg.t("linked payment methods ~ " + linked_payment_method.toString());
      initStripeLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    if (initStripeLoading){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text("Payment Methods",),
        ),
        body:Center(child:CircularProgressIndicator())
        );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text("Payment Methods",),
        actions: [
          IconButton(onPressed: ()async{
            await refreshPaymentStatus();
          },
              icon: Icon(Icons.refresh)
          )
        ],
      ),
      body: ListView(children: [
        SizedBox(height: Gss.height*.05,),

        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sr),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Account Status:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                AccountStatusIndicator(status: accountStatusString)
              ],)),

        linked_payment_method != null && linked_payment_method!.isNotEmpty?
        SizedBox(height: Gss.height*.25): SizedBox(height: Gss.height*.01) ,
        // accountStatusString == "incomplete"?
        ref.watch(stripeCustomerIdProv) == null && accountStatusString != "in progress" ?
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.sr),
            child:
            RoundedOutlineButton(onTap: ()async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              try {
                var create_resp = await createClientCustomer(
                    ref,
                    ref.read(userAuthProv)!.userToken,
                    ref.read(userAuthProv)!.userId,
                    ref.read(userAuthProv)!.email);
                if (create_resp.containsKey("stripe_customer_id") && create_resp["stripe_customer_id"] != null){
                  setState(() {
                    accountStatusString = "in progress";
                  });
                }
              }catch(e){
                lg.e("exp caught from createClientCustomer");
              }

              // var client_setup_secret = await setupClientPaymentMethod(
              //   ref.read(userAuthProv)!.userToken,
              //   ref.read(userAuthProv)!.userId,);
              // var refresh_resp = await getStripeClientAccountStatus(
              //   ref.read(userAuthProv)!.userToken,
              //   ref.read(userAuthProv)!.userId,);
              Navigator.pop(gNavigatorKey.currentContext!);

            },
                paddingVertical: 12.sr,
                label: "Setup Now"))
        :Container(),

        linked_payment_method != null && linked_payment_method!.isNotEmpty?
        SizedBox(height: Gss.height*.01): SizedBox(height: Gss.height*.08) ,
        linked_payment_method != null && linked_payment_method!.isNotEmpty?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Linked Payment Methods",
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],):Container(),
        SizedBox(height: Gss.height*.02),
        linked_payment_method != null?
        Padding(
            padding: EdgeInsets.symmetric(horizontal: Gss.width*.05),
            child:ListView.builder(
                shrinkWrap: true,
                itemCount: linked_payment_method?.length,
                itemBuilder: (context, index) {
                  lg.t("linked_payment_methods len ~ " + linked_payment_method!.length.toString());
                  lg.t("linked payment methods ~ " + linked_payment_method.toString());
                  return
                    Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ref.watch(darkModeProv)
                                  ? Colors.black.withValues(alpha:0.6)
                                  : Colors.grey.withValues(alpha:0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:
                        ListTile(
                          title: Text(linked_payment_method?[index]["card"]["brand"],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text("**** **** **** " + linked_payment_method?[index]["card"]["last4"],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          trailing: Icon(Icons.credit_card,
                          ),
                        ));
                })):Container(),

        linked_payment_method != null && linked_payment_method!.isNotEmpty?
        SizedBox(height: Gss.height*.15): SizedBox(height: 0) ,

        accountStatusString == "in progress" || accountStatusString == "complete"?
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.sr),
            child:
            RoundedOutlineButton(
                paddingVertical: 12.sr,
                onTap: ()async {
                  lg.t("start checkout for setup flow");
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
              // client_setup_secret = await setupClientPaymentMethod(
              //   ref.read(userAuthProv)!.userToken,
              //   ref.read(userAuthProv)!.userId,);
              // // Navigator.pop(context);
              // setState(() {});

              if (ref.read(stripeCustomerIdProv) != null) {
                try {
                  await openCheckoutForSetup(
                      ref.read(userAuthProv)!.userToken,
                      ref.read(userAuthProv)!.userId,
                      ref.read(stripeCustomerIdProv)!,
                      stripe_vendor_onboard_redirect_url,
                      stripe_vendor_onboard_refresh_url
                  );
                }catch(e){
                  lg.e("error opening checkout ~ " + e.toString());
                }
              }
              else{
                setState(() {
                  accountStatusString = "incomplete";
                });
              }
              Navigator.pop(gNavigatorKey.currentContext!);

            }, label:
            accountStatusString == "in progress"?
            "Add Payment Method":
            (linked_payment_method != null && linked_payment_method!.isNotEmpty)?
            "Replace Payment Method":
                "Add Payment Method" /// also fine here
            )):Container(),




            // :Container()
        // CardField(
        //   dangerouslyGetFullCardDetails: true,
        //   dangerouslyUpdateFullCardDetails: true,
        //   onCardChanged: (card) {
        //    lg.t("card ~ " + card.toString());
        //   },
        // ),
        // client_setup_secret != null?
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        //   child: PaymentElement(
        //   autofocus: true,
        //   enablePostalCode: true,
        //   onCardChanged: (card) {
        //     lg.t("card changed with card ~ " + card.toString());
        //   },
        //   clientSecret:client_setup_secret!,
        //   ),
        //   ):Container()

      ],),
    );
  }
}



class AccountStatusIndicator extends StatelessWidget {
  const AccountStatusIndicator({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    if (status == "incomplete"){
      // statusColor = appPrimarySwatch[700]!;
    statusColor = Colors.transparent;
    }
    if (status == "in progress"){
      statusColor = appPrimarySwatch[700]!;
    }
    if (status == "complete"){
      statusColor = Colors.green[700]!;
    }

    return
      Padding(
          padding: EdgeInsets.symmetric(horizontal: Gss.width * .02, vertical: Gss.width * .04),
          child:Container(
              padding: EdgeInsets.symmetric(horizontal: Gss.width * .02, vertical: Gss.width * .01),
              decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4)
              ),
              child:Center(child:Text(status,
                  style:
                  TextStyle(color:
                  status == "incomplete"?
                      TextTheme.of(context).bodyLarge!.color:
                  Colors.white)
              ))
          ));
  }
}