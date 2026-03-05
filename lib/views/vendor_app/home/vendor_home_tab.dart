import 'dart:async';

import 'package:connectme_app/components/ui/etc/tab_page_header.dart';
import 'package:connectme_app/components/ui/modals/welcome_new_users_dialogs.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/styles/text.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/vendor_app/services/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class ConnectMeVendorHome extends ConsumerStatefulWidget {
  const ConnectMeVendorHome({super.key,
  required this.tabIndex,
  });
  final int tabIndex;

  @override
  ConsumerState<ConnectMeVendorHome> createState() => _ConnectMeVendorHomeState();
}

class _ConnectMeVendorHomeState extends ConsumerState<ConnectMeVendorHome> {


  @override
  initState() {
    super.initState();
    scheduleMicrotask(() async {
      if (ref.read(vendorIsFirstTimeAndJustPaidProv)){
        lg.t("vendorIsFirstTimeAndJustPaidProv is true");
        ref.read(vendorIsFirstTimeAndJustPaidProv.notifier).state = false;
        showWelcomeNewVendorDialog( context);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    lg.t("[ConnectMeVenodrHome] build");
    return
      ListView(
      physics: ClampingScrollPhysics(),
      children: [
    TabPageHeader(titleString:"Home"),

    SizedBox(height: 12.sr,),
          Padding(padding: EdgeInsets.symmetric(horizontal: 14.sr),
          child:
            Row(children:[Flexible(child:Padding(padding: EdgeInsets.symmetric(horizontal: 4.sr),
            child:Text("Hello ${ref.watch(userAuthProv)!.userName}",
              style: homeTabLargeHeaderTextStyle,
            )))])),
              Padding(padding: EdgeInsets.symmetric(horizontal: 14.sr),
                  child:
                  Row(children:[
              Flexible(child:
            Padding(padding: EdgeInsets.symmetric(horizontal: 7.sr),
            child:
            Text("Manage your services and bookings",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ))),
      ])),

        // IconButton(onPressed: (){},
        //     icon: Icon(Icons.notifications_none)
        // )

      // Container(
      //     padding:EdgeInsets.symmetric(horizontal: 16),
      //     child: Center(
      //         child: TextField(
      //           decoration: InputDecoration(
      //             hintText: 'Search your appointments...',
      //             filled: false,
      //             // fillColor: Colors.white,
      //             prefixIcon: Icon(Icons.search),
      //             border: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(12),
      //                 borderSide: BorderSide.none),
      //           ),
      //         ))),

      SizedBox(height: Gss.height * .04),
    Padding(padding: EdgeInsets.symmetric(horizontal: 14.sr),
    child:
        Row(children:[
                Flexible(child:
                Padding(
                padding: EdgeInsets.symmetric(vertical: 14.sr, horizontal: 4.sr),
                child:
                Text("Your Dashboard",
                  style: homeTabLargeHeaderTextStyle,
                )))])),


                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Expanded(
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Text(
                //             "0",
                //             style: dashboardNumberTextStyle,
                //           ),
                //       Flexible(child:
                //           Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 4.sr),
                //             child: Text(
                //               "Today's Bookings",
                //               textAlign: TextAlign.center,
                //             ),
                //           ))  ,
                //         ],
                //       ),
                //     ),
                //     Expanded(
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Text(
                //             "0",
                //             style: dashboardNumberTextStyle,
                //           ),
                //       Flexible(child:
                //           Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 4.sr),
                //             child: Text(
                //               "Pending Requests",
                //               textAlign: TextAlign.center,
                //             ),
                //           )),
                //         ],
                //       ),
                //     ),
                //     Expanded(
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Text(
                //             "0",
                //             style: dashboardNumberTextStyle,
                //           ),
                //           Flexible(child:
                //           Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 4.sr),
                //             child: Text(
                //               "Completed",
                //               textAlign: TextAlign.center,
                //             )),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // )

              // ],))
            // ),
          // ),

      SizedBox(height: Gss.height * .04),

      Padding(padding: EdgeInsets.symmetric(horizontal: 24.sr),
          child:
          Row( children: [
                      Flexible(child:Text("Update Your Profile",
                        style: homeTabLargeHeaderTextStyle,
                      ))])),
          Padding(padding: EdgeInsets.symmetric(horizontal: 24.sr),
            child:
          Row( children: [
                      Flexible(child:Text("Add your services, set your availability, and update your profile",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                      )),
                      ])),
                      SizedBox(height: Gss.height * .03),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[OutlinedButton(
                              onPressed: (){
                                ref.read(tabIndexProvider.notifier).state = 3;
                              },
                          child: Text("Update Profile"))
                      ]),


      SizedBox(height: Gss.height * .04),

      Padding(padding: EdgeInsets.symmetric(horizontal: 24.sr),
          child:
          Row(children: [
                      Flexible(child:Text("Manage Your Services",
                        style: homeTabLargeHeaderTextStyle,
                      ))])),

        Padding(padding: EdgeInsets.symmetric(horizontal: 24.sr),
            child:
            Row(children: [
                      Flexible(child:Text("Add, edit or remove services that you offer to clients",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                      ))])),

                      SizedBox(height: Gss.height * .03),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[OutlinedButton(onPressed: (){
                            ref.read(tabIndexProvider.notifier).state = 3;
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return const VendorServicesPage();
                            }));
                          },
                              child: Text("Manage Services"))
                          ]),

        SizedBox(height: Gss.height * .33),
              ]);

  }
}
