import 'dart:async';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/bookings/bookings_tab.dart';
import 'package:connectme_app/views/client_app/client_app.dart';
import 'package:connectme_app/views/vendor_app/profile/profile_tab.dart';
import 'package:connectme_app/views/etc/loading_screen.dart';
import 'package:connectme_app/views/messaging/messaging_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectme_app/config/logger.dart';

import 'home/vendor_home_tab.dart';


class ConnectMeVendorApp extends ConsumerStatefulWidget {
  const ConnectMeVendorApp ({super.key});


  @override
  ConsumerState<ConnectMeVendorApp> createState() => _ConnectMeVendorAppState();
}

class _ConnectMeVendorAppState extends ConsumerState<ConnectMeVendorApp> {

  bool showFAB = false;
  List<Widget> tabPages = [];

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      tabPages = [
        ConnectMeVendorHome(tabIndex: 0,),
        BookingsTab(tabIndex: 1,
            ownerType: ref.watch(vendorUserMetaProv)!.userType,),
        ThreadListWidget(tabIndex: 2,),
        ProfileTab(tabIndex: 3,),
      ];
      setState(() {});
    });


  }

  @override
  void dispose() {
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    lg.t("build vendor app");

    if (tabPages.isEmpty){
     return LoadingScreen(descriptionMain: "Loading...", descriptionSub: "One second please...", noUseItemUploadCounter: true,);
    }

    return SafeArea(child:Scaffold(
      // floatingActionButton: ref.watch(showFABProvider)
      //     ? FloatingActionButton(
      //   onPressed: () {
      //     // gScrollControllers[ref.watch(tabIndexProvider)]
      //     ref.watch(scrollControllerProvider)
      //         .animateTo(
      //       0,
      //       duration: Duration(milliseconds: 500),
      //       curve: Curves.easeOut,
      //     );
      //   },
      //   child: Icon(Icons.arrow_upward),
      // )
      //     : null,
      body:
      Stack(children:[
      tabPages[ref.watch(tabIndexProvider)],
        // Positioned(
        //     top:0.0,
        //     left:0.0,
        //     child:
        // AnimatedCrossFade(duration: Duration(milliseconds: 234),
        //   firstChild:
        //     CustomFloatingActionButton(size:(Gss.width * .18) * ( 1 / 1.sr)),
        //   secondChild:
        //     Container(width: (Gss.width * .18) * ( 1 / 1.sr), height: (Gss.width * .18) * ( 1 / 1.sr),
        //   ),
        //     crossFadeState:
        //     ref.watch(showFABProvider)?
        //     CrossFadeState.showFirst: CrossFadeState.showSecond
        // )),

        Positioned(
          bottom:0.0,
          left:0.0,
          right:0.0,
          child:
          AnimatedCrossFade(duration: Duration(milliseconds: 234),
              firstChild:
              Container(height: 64.sr,child:Row(children: [
                CustomBottomNavBarItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  label: ref.watch(tabIndexProvider)!=0?null:'Home',
                ),
                CustomBottomNavBarItem(
                  index: 1,
                  icon: Icons.calendar_today_outlined,
                  label: ref.watch(tabIndexProvider)!=1?null:'Bookings',
                ),
                CustomBottomNavBarItem(
                  index: 2,
                  icon: Icons.messenger_outline,
                  label: ref.watch(tabIndexProvider)!=2?null:'Messages',
                ),
                CustomBottomNavBarItem(
                  index:3,
                  icon: Icons.person_outline_rounded,
                  label: ref.watch(tabIndexProvider)!=3?null:'Profile',
                ),
              ],)),
              secondChild: Container(height: 100, width: 100,),
              crossFadeState:
              ref.watch(showBNBProvider)?
              CrossFadeState.showFirst: CrossFadeState.showSecond
          ),
        ),

      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   onTap: (int index) {
      //     ref.read(showFABProvider.notifier).state = false;
      //     ref.read(tabIndexProvider.notifier).state = index;
      //     if (index == 0) {
      //       ref.read(scrollControllerProvider.notifier).state = homeScrollController;
      //     }
      //     else if (index == 1) {
      //       ref.read(scrollControllerProvider.notifier).state = bookingUpcomingScrollController;
      //     }
      //   },
      //   currentIndex: ref.watch(tabIndexProvider),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       label: 'Home',
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.search),
      //     //   label: 'Explore',
      //     // ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today_outlined),
      //       label: 'Bookings',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.messenger_outline),
      //       label: 'Messages',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person_outline_rounded),
      //       label: 'Profile',
      //     ),
      //
      //
      //   ],
      // ),
   ])
    ));
  }
}






