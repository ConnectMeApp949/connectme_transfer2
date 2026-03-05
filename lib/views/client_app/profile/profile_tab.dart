import 'package:connectme_app/components/ui/etc/tab_page_header.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/methods/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/views/client_app/profile/client_addresses.dart';
import 'package:connectme_app/views/client_app/profile/payment_methods/payment_methods.dart';
import 'package:connectme_app/views/client_app/profile/personal_information.dart';
import 'package:connectme_app/views/client_app/profile/saved_providers.dart';
import 'package:connectme_app/views/client_app/profile/settings/settings_page.dart';
import 'package:connectme_app/views/client_app/reviews/reviews_page.dart';
import 'package:connectme_app/views/vendor_app/profile/profile_tab.dart';
import 'package:connectme_app/views/vendor_client_shared/payments_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../config/logger.dart';



class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key,
  required this.tabIndex
  });
  final int tabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<_ProfileItem> items = [
      // _ProfileItem(Icons.person_outline, "Personal Information"),
      // _ProfileItem(Icons.calendar_today_outlined, "Bookings"),
      // _ProfileItem(Icons.messenger_outline, "Messages"),
      _ProfileItem(Icons.house_outlined, "Address"),
      _ProfileItem(Icons.favorite_border, "Saved Providers"),
      _ProfileItem(Icons.star_outline, "Reviews"),
      _ProfileItem(Icons.payment, "Payment Methods"),
      _ProfileItem(Icons.receipt_long_outlined, "Payment History"),
      _ProfileItem(Icons.settings_outlined, "Settings"),
      _ProfileItem(Icons.logout_outlined, "Log Out"),


      // _ProfileItem(Icons.science_outlined, "Calendar Experiment"),
    ];

    /// avoid deleting test accounts
// if    (ref.watch(userAuthProv)!.userId != "vp5t39isqq0euy7sgkrw4u7l" && ref.watch(userAuthProv)!.userId != "cp5t39isqq0euy7sgkrw4u7l"){
//   items.add(
//   _ProfileItem(Icons.delete_sweep_outlined, "Delete Account"));
//     }

    return Scaffold(
      // appBar: AppBar(title:  Text('Profile',
      //   style: tabTitleTextStyle,
      // )),
      body: ListView(
        children: [
          TabPageHeader(titleString:"Profile"),
          const SizedBox(height: 24),
          ProfileImageAsyncLoadingWrapper(),
          const SizedBox(height: 24),
          // Expanded(
          //   child:
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length + 1,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {

                if (index == items.length ){
                  return SizedBox(height: Gss.height * .33,);
                }

                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon, color: appPrimarySwatch[700],),
                  title: Text(item.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    if (item.title == "Personal Information"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const ClientPersonalInformation();
                      }));
                    }
                    if (item.title == "Address"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const ClientAddresses();
                      }));
                    }
                    if (item.title == "Payment Methods"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const ClientPaymentMethodsPage();
                      }));
                    }
                    if (item.title == "Saved Providers"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return SavedServicesList();
                      }));
                    }
                    if (item.title == "Payment History"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return PaymentHistoryPage();
                      }));
                    }
                    if (item.title == "Reviews"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return ReviewsPage();
                      }));
                    }
                    if (item.title == "Settings"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return SettingsPage();
                      }));
                    }

                    if (item.title == "Log Out"){
                      lg.t("[client_app profile_tab] logout press");
                      // await userLogoutFirebase();
                      // lg.t("logout firebase conplete");
                      // Phoenix.rebirth(gNavigatorKey.currentContext!);
                      // lg.t("phoenix rebirth complete");
                      callNewLogoutForSomeStpdReason(gNavigatorKey.currentContext!, ref);
                    }

                    // if (item.title == "Delete Account"){
                    //   showConfirmDeleteAccountDialog(context,
                    //       username: ref.read(userAuthProv)!.userName,
                    //       onConfirm: ()async{
                    //
                    //            var resp = await deleteUserAccount(ref.read(userAuthProv)!.userToken,
                    //                                               ref.read(userAuthProv)!.userId,
                    //                                               ref.read(userTypeProv)!,
                    //                                               ref.read(userAuthProv)!.email
                    //                                               );
                    //            if (resp.statusCode == 200){
                    //              await userLogoutFirebase();
                    //              Phoenix.rebirth(context);
                    // callNewLogoutForSomeStpdReason(gNavigatorKey.currentContext!);
                    //            }else{
                    //              throw Exception("error deleting account");
                    //            }
                    //         });
                    // }


                    // if (item.title == "Calendar Experiment") {
                    //   if (!kIsWeb) {
                    //     await signInAndFetchCalendar();
                    //   }
                    // }

                  },
                );
              },
            ),
          // ),
        ],
      ),
    );
  }
}

class _ProfileItem {
  final IconData icon;
  final String title;
  _ProfileItem(this.icon, this.title);
}
