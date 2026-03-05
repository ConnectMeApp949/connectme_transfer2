import 'dart:async';
import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

Future<void> startVendorOnboarding(
    String userId,
    String userToken,
    String vendorUserId) async {
  final response = await http.post(
    Uri.parse(create_stripe_vendor_onboarding_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      "authToken": userToken,
      // 'vendor_user_id': vendorUserId,
                      'redirect_url': stripe_vendor_onboard_redirect_url,
                      'refresh_url': stripe_vendor_onboard_refresh_url
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final String stripeSetupUrl = data['url'];
    final Uri stripeSetupUri = Uri.parse(stripeSetupUrl);
    if (await canLaunchUrl(stripeSetupUri)) {
      await launchUrl(stripeSetupUri);
    } else {
      throw 'Could not launch onboarding URL';
    }
  } else {
    throw 'Failed to create onboarding: ${response.body}';
  }
}

Future getStripeVendorAccountStatus(
    String userId,
    String userToken,
    String vendorUserId) async {
  final response = await http.post(
    Uri.parse(get_stripe_vendor_account_status_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      "authToken": userToken,
      // 'vendor_user_id': vendorUserId}), // cannot do, need auth by userId
    })
      );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  else if (response.statusCode == 404){ /// expect on not set up yet
    return json.decode(response.body);
  }
  else {
    return {"error": "error getting account status"};
  }
}


Future getVendorStripeDashboardUrl(String userToken, String userId, String vendorStripeAccountId) async {
  final response = await http.post(
    Uri.parse(get_vendor_stripe_dashboard_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'authToken': userToken,
      'userId': userId,
      'vendor_stripe_account_id': vendorStripeAccountId}),
  );

  if (response.statusCode == 200) {
    var getUrl = json.decode(response.body)["dashboard_url"];
    Uri getUri = Uri.parse(getUrl);
    if (await canLaunchUrl(getUri)) {
      await launchUrl(getUri);
    } else {
      throw 'Could not launch dashboard URL';
    }
  }
  else if (response.statusCode == 404){ /// expect on not set up yet
    return json.decode(response.body);
  }
  else {
    return {"error": "error getting account status"};
  }
}


class VendorPaymentMethodsPage extends ConsumerStatefulWidget {
  const VendorPaymentMethodsPage({super.key});

  @override
  ConsumerState<VendorPaymentMethodsPage> createState() => _VendorPaymentMethodsPageState();
}

class _VendorPaymentMethodsPageState extends ConsumerState<VendorPaymentMethodsPage> {

  bool initStripeLoading = true;
  bool accountSetupInit = false;
  bool accountSetupComplete = false;
  String accountStatusString = "incomplete";

  String? stripeAccountId;
  bool? chargesEnabled;
  bool? payoutsEnabled;

  // bool loading = true;

  @override
  void initState() {
    super.initState();
    refreshPaymentStatus();
  }

  refreshPaymentStatus(){
    scheduleMicrotask(()async {
      var resp = await getStripeVendorAccountStatus(
          ref.read(userAuthProv)!.userId,
          ref.read(userAuthProv)!.userToken,
          ref.read(userAuthProv)!.userId);

      lg.t("got vendor account status ~ " + resp.toString());
      if (resp["accountStatus"] == "not_created"){
        accountSetupInit = false;
      }
      else{
        accountSetupInit = true;
        accountStatusString = "in progress";
        if ( resp["charges_enabled"] != true ||
            resp["payouts_enabled"] != true){
          accountSetupComplete = false;
          chargesEnabled = resp["charges_enabled"];
          payoutsEnabled = resp["payouts_enabled"];
        }else{
          accountStatusString = "complete";
          accountSetupComplete = true;
          chargesEnabled = resp["charges_enabled"];
          payoutsEnabled = resp["payouts_enabled"];
          stripeAccountId = resp["stripe_account_id"];
        }
      }
       initStripeLoading  = false;
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
        title: Text("Payment Methods",),
      actions: [
        IconButton(onPressed: ()async{
         await refreshPaymentStatus();
        },
            icon: Icon(Icons.refresh)
        )
      ],
      ),
      body:
      initStripeLoading?
      Center(child: CircularProgressIndicator()):
      ListView(children: [
        SizedBox(height: Gss.height*.05,),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sr),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
            child:Text("Account Status:",
            style: Theme.of(context).textTheme.bodyLarge,
            )),

            AccountStatusIndicator(status: accountStatusString)
          ],)),

        SizedBox(height: Gss.height*.05,),

        chargesEnabled != null?
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sr),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child:Text("Charges Enabled:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),

                AccountPropertiesIndicator(value: chargesEnabled!)
              ],)):Container(),

        SizedBox(height: Gss.height*.05,),
        payoutsEnabled != null?
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sr),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child:Text("Payouts Enabled:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),

                AccountPropertiesIndicator(value: payoutsEnabled!)
              ],)):Container(),

        SizedBox(height: Gss.height*.055),
        // accountSetupInit == false?
        !accountSetupComplete?
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.sr),
            child:
        RoundedOutlineButton(onTap: ()async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
          // var resp =
          await startVendorOnboarding(
              ref.read(userAuthProv)!.userId,
              ref.read(userAuthProv)!.userToken,
              ref.read(userAuthProv)!.userId);
          Navigator.pop(gNavigatorKey.currentContext!);
        },
            paddingVertical: 12.sr,
            label:
        "Setup Now"
        )):Container(),
         accountSetupComplete?
         Padding(
             padding: EdgeInsets.symmetric(horizontal: 22.sr),
             child:
             RoundedOutlineButton(onTap: ()async {
               showDialog(
                 context: context,
                 barrierDismissible: false,
                 builder: (_) => const Center(child: CircularProgressIndicator()),
               );
               if (stripeAccountId != null) {
                 // var resp =
                 await getVendorStripeDashboardUrl(ref.read(userAuthProv)!.userToken, ref.read(userAuthProv)!.userId, stripeAccountId!);
               }
               Navigator.pop(gNavigatorKey.currentContext!);

             },
                 paddingVertical: 12.sr,
                 label:
             "Go to Dashboard"
             )):Container()

      ],),
    );
  }
}



class AccountStatusIndicator extends StatelessWidget {
  const AccountStatusIndicator({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {

    String? altStatusString;

    Color statusColor = Colors.grey;
    if (status == "incomplete"){
      statusColor = appPrimarySwatch[700]!;
      altStatusString = "Incomplete";
    }
    if (status == "in progress"){
      statusColor = appPrimarySwatch[700]!;
      altStatusString = "In progress";
    }
    if (status == "complete"){
      statusColor = Colors.green[700]!;
      altStatusString = "Complete";
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
              child:Center(child:Text(altStatusString?? status,
                  style: TextStyle(color:Colors.white)
              ))
          ));
  }
}


class AccountPropertiesIndicator extends StatelessWidget {
  const AccountPropertiesIndicator({super.key,
    // required this.property,
    required this.value
  });

  // final String property;
  final bool value;

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;

    if (value == false){
      statusColor = Colors.blue[700]!;
    }
    if (value == true){
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
              child:Center(child:Text(value?"Yes":"No" ,
                  style: TextStyle(color:Colors.white)
              ))
          ));
  }
}