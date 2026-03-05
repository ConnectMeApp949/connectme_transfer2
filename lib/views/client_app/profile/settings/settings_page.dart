import 'package:app_settings/app_settings.dart';
import 'package:connectme_app/components/ui/modals/delete_account_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/methods/etc.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/requests/user/delete_account.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/styles/text.dart';
import 'package:connectme_app/views/etc/attributions_page.dart';
import 'package:connectme_app/views/vendor_app/calendar/base_availability_page.dart';
import 'package:connectme_app/views/vendor_app/calendar/calendar_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:connectme_app/platform_bridge/platform_bridge.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../../config/logger.dart';

// import 'package:purchases_flutter/models/customer_info_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final List<_SettingsItem> items = [

      _SettingsItem(Icons.checklist_rtl_sharp, "Terms of Service"),
      _SettingsItem(Icons.important_devices, "Privacy Policy"),
      _SettingsItem(Icons.local_attraction_outlined, "Attributions"),
      // _SettingsItem(Icons.favorite_border, "Cancel Subscription"),
    ];

    if    (ref.watch(userAuthProv)!.userId != "vp5t39isqq0euy7sgkrw4u7l" &&
        ref.watch(userAuthProv)!.userId != "cp5t39isqq0euy7sgkrw4u7l") {
      if (ref.read(userTypeProv) == UserType.vendor) {
        items.add(
            _SettingsItem(Icons.subscriptions_outlined, "Manage Subscription"));
      }
    }

    /// avoid deleting test accounts
    if    (ref.watch(userAuthProv)!.userId != "vp5t39isqq0euy7sgkrw4u7l" && ref.watch(userAuthProv)!.userId != "cp5t39isqq0euy7sgkrw4u7l"){
      items.add(
          _SettingsItem(Icons.delete_sweep_outlined, "Delete Account"));
    }



    return Scaffold(
      appBar: AppBar(title:  Text('Privacy and Data',
        style: tabTitleTextStyle,
      )),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon, color: appPrimarySwatch[600],),
                  title: Text(item.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    if (item.title == "Terms of Service"){
                      openHtmlWindow(terms_of_service_url);
                    }
                    if (item.title == "Privacy Policy"){
                      openHtmlWindow(privacy_policy_url);
                    }
                    if (item.title == "Attributions"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return AttributionsPage();
                    }));
                    }

                    if (item.title == "Manage Subscription"){
                      //
                      // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
                      //
                      // if (customerInfo.managementURL != null){
                      // openHtmlWindow(customerInfo.managementURL!);
                      // }else{
                      //   showErrorDialog(context, "No subscription management URL");
                      // }

                      if (!kIsWeb) {
                        if (Platform.isIOS) {
                          AppSettings.openAppSettings(
                              type: AppSettingsType.subscriptions);
                        }
                        else if (Platform.isAndroid){
                          final String playAddress = 'http://play.google.com/store/account/subscriptions';
                          final playUrl = Uri.parse(playAddress);
                          // openHtmlWindow(playUrl);
                          bool lu_err = false;
                          if (await canLaunchUrl(playUrl)) {
                            try{
                              await launchUrl(playUrl, mode: LaunchMode.externalApplication);
                            }catch(e){
                              lg.w('Could not launch $playUrl html ');
                              lu_err = true;
                            }
                          }
                          if ( ! await canLaunchUrl(playUrl) || lu_err)
                          {
                            lg.w('Could not launch $playUrl app');
                            try{
                              openHtmlWindow(playAddress);
                            }catch(e){
                              lg.w('Could not launch $playUrl html ');
                            }
                          }
                        }
                      }
                    }

                    if (item.title == "Delete Account"){
                      showConfirmDeleteAccountDialog(gNavigatorKey.currentContext!,
                          ref,
                          username: ref.read(userAuthProv)!.userName,
                          onConfirm: ()async{

                            var resp = await deleteUserAccount(ref.read(userAuthProv)!.userToken,
                                ref.read(userAuthProv)!.userId,
                                ref.read(userTypeProv)!,
                                ref.read(userAuthProv)!.email
                            );
                            if (resp.statusCode == 200){
                              // await userLogoutFirebase();
                              // Phoenix.rebirth(context);
                              lg.t("confirm account delete 200 call logout");
                              
                              callNewLogoutForSomeStpdReason(gNavigatorKey.currentContext!, ref );

                            }else{
                              throw Exception("error deleting account");
                            }
                          });
                    }

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  _SettingsItem(this.icon, this.title);
}





class AvailabilityPage extends ConsumerWidget {
  const AvailabilityPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final List<_SettingsItem> items = [
      _SettingsItem(Icons.calendar_month, "Calendar"),
      _SettingsItem(Icons.crisis_alert, "Availability"),
    ];

    return Scaffold(
      appBar: AppBar(title:  Text('Availability',
        style: tabTitleTextStyle,
      )),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon, color: appPrimarySwatch[600],),
                  title: Text(item.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    if (item.title == "Calendar"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const VendorCalendarPage();
                      }));
                    }
                    if (item.title == "Availability"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return BaseAvailabilityPage();
                      }));
                    }
                    }


                );
              },
            ),
          ),
        ],
      ),
    );
  }
}