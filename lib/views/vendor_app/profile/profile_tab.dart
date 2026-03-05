import 'package:connectme_app/components/ui/etc/tab_page_header.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/methods/etc.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/providers/user.dart';
import 'package:connectme_app/requests/user/profile_image.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/profile/settings/settings_page.dart';
import 'package:connectme_app/views/vendor_app/profile/payment_methods/payment_methods.dart';
import 'package:connectme_app/views/vendor_app/services/services_page.dart';
import 'package:connectme_app/views/vendor_client_shared/payments_history.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/logger.dart';
import 'business_information.dart';




class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key, required this.tabIndex});
  final int tabIndex;

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {


  @override
  Widget build(BuildContext context) {

    final List<_ProfileItem> items = [
      // _ProfileItem(Icons.person_outline, "Personal Information"),
      _ProfileItem(Icons.business_outlined, "Business Information"),
      _ProfileItem(Icons.home_repair_service_outlined, "Services"),
      _ProfileItem(Icons.calendar_month, "Availability"),
      _ProfileItem(Icons.payment, "Payment Methods"),
      _ProfileItem(Icons.receipt_long_outlined, "Payment History"),
      _ProfileItem(Icons.settings_outlined, "Settings"),
      _ProfileItem(Icons.logout_outlined, "Log Out"),

    ];


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

                if (index == items.length){
                  return SizedBox(height: Gss.height * .33,);
                }

                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon, color: appPrimarySwatch[700],),
                  title: Text(item.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    // if (item.title == "Personal Information"){
                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    //     return const ClientPersonalInformation();
                    //   }));
                    // }
                    if (item.title == "Business Information"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const BusinessInformation();
                      }));
                    }
                    if (item.title == "Availability"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const AvailabilityPage();
                      }));
                    }
                    if (item.title == "Services"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const VendorServicesPage();
                      }));
                    }
                    if (item.title == "Payment Methods"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return const VendorPaymentMethodsPage();
                      }));
                    }
                    if (item.title == "Payment History"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return PaymentHistoryPage();
                      }));
                    }
                    if (item.title == "Settings"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return SettingsPage();
                      }));
                    }
                    if (item.title == "Log Out"){
                      lg.t("logout press");
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
                    //         var resp = await deleteUserAccount(ref.read(userAuthProv)!.userToken,
                    //             ref.read(userAuthProv)!.userId,
                    //             ref.read(userTypeProv)!,
                    //             ref.read(userAuthProv)!.email
                    //         );
                    //         if (resp.statusCode == 200){
                    //           await userLogoutFirebase();
                    //           Phoenix.rebirth(context);
                    //         }else{
                    //           throw Exception("error deleting account");
                    //         }
                    //       });
                    // }

                  },
                );
              },
            // ),
          ),
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



class ProfileImageAsyncLoadingWrapper extends ConsumerStatefulWidget {
  const ProfileImageAsyncLoadingWrapper({super.key});

  @override
  ConsumerState<ProfileImageAsyncLoadingWrapper> createState() => _ProfileImageAsyncLoadingWrapperState();
}

class _ProfileImageAsyncLoadingWrapperState extends ConsumerState<ProfileImageAsyncLoadingWrapper> {



  @override
  Widget build(BuildContext context) {
    final imageAsync = ref.watch(profileImageUrlProvider(ref.watch(userAuthProv)!.userId));

    return
    imageAsync.when(
      data: (url) =>

      // Container(
      //   color: Colors.red,
      //     child:
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Expanded(
                child:Stack(children:[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Container(
                            width:155.sr,
                            height:155.sr,
                            child:
                            CircleAvatar(
                              radius: 155.sr,
                              backgroundImage: url != null
                                  ?
                              CachedNetworkImageProvider(url)
                                  :
                              AssetImage('assets/images/etc/avatar_placeholder.jpeg') as ImageProvider,
                            ))]),
                  Positioned(bottom: 0, right: ((Gss.width * .5) - (.5 * (155.sr))  ), child: IconButton(
                    iconSize: 28.sr,
                    onPressed: ()async{
                      await updateProfileImage(ref);
                    },
                    icon:Icon(
                      Icons.add_circle,
                    ), color: appPrimarySwatch[700],)),
                ]))
          ])
      ,
      loading: () => const CircleAvatar(
        radius: 50,
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/images/etc/avatar_placeholder.jpeg'),
      ),
    );

  }
}
