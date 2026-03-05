import 'dart:async';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/methods/client_init.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/bookings/bookings_tab.dart';
import 'package:connectme_app/views/client_app/profile/profile_tab.dart';
import 'package:connectme_app/views/etc/loading_screen.dart';
import 'package:connectme_app/views/messaging/messaging_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:connectme_app/config/logger.dart';

import 'home/client_home_tab.dart';
import 'dart:ui' as ui;



class ConnectMeClientApp extends ConsumerStatefulWidget {
  const ConnectMeClientApp ({super.key});


  @override
  ConsumerState<ConnectMeClientApp> createState() => _ConnectMeClientAppState();
}

class _ConnectMeClientAppState extends ConsumerState<ConnectMeClientApp> {

  bool showFAB = false;
  List<Widget> tabPages = [];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {

      if (ref.read(userTypeProv) != UserType.guest) {
        await initializeClientProviders(ref);
      }

      lg.t("build tabPages");
      lg.t("get userType");
      lg.t("ut ~ " + ref.read(clientUserMetaProv)!.userType.toString());
      lg.t("buuild tabpages 3");

     if (ref.read(userAuthProv)!.userId != "Guest") {
       tabPages = [
         ConnectMeClientHome(tabIndex: 0,),
         BookingsTab(tabIndex: 1,
           ownerType: ref.read(clientUserMetaProv)!.userType,
         ),
         ThreadListWidget(tabIndex: 2,),
         ProfileTab(tabIndex: 3,),
       ];
     }
      else if (ref.read(userAuthProv)!.userId == "Guest") {
        tabPages = [
          ConnectMeClientHome(tabIndex: 0,),
          AccountRequiredTab(key:ValueKey("Bookings"), tabIndex: 1, title: "Bookings"),
          AccountRequiredTab(key:ValueKey("Messages"), tabIndex: 2, title: "Messages"),
          AccountRequiredTab( key:ValueKey("Profile"),tabIndex: 3, title: "Profile"),
        ];
      }
      setState(() {});
    });



  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    lg.t("build client app");

    if (tabPages.isEmpty){
      return LoadingScreen(descriptionMain: "Loading...", descriptionSub: "One second please...", noUseItemUploadCounter: true,);
    }

    return SafeArea(child:Scaffold(
      // floatingActionButton: ref.watch(showFABProvider)
      //     ? FloatingActionButton(
      //   onPressed: () {
      //     // gScrollControllers[ref.watch(tabIndexProvider)]
      //         ref.watch(scrollControllerProvider)
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
      // tabPages[ref.watch(tabIndexProvider)],
      Stack(children: [
      tabPages[ref.watch(tabIndexProvider)],
        // ref.watch(showBNBProvider)?
        // Positioned(
        //     bottom:0.0,
        //     child:
        //     Container(
        //       height: ,
        //     child:Row(children:[
        //
        //     ]))):Container(),

        /// for FAB
        // Positioned(
        //     top:0.0,
        //     left:0.0,
        //     child:
        // AnimatedCrossFade(duration: Duration(milliseconds: 234),
        // firstChild:
        //         InkWell(
        //           onTap:(){
        //                 // gScrollControllers[ref.watch(tabIndexProvider)]
        //                     ref.watch(scrollControllerProvider)
        //                     .animateTo(
        //                   0,
        //                   duration: Duration(milliseconds: 500),
        //                   curve: Curves.easeOut,
        //                 );
        //           },
        //       child:CustomFloatingActionButton(size:(Gss.width * .18) * ( 1 / 1.sr))),
        //     secondChild:
        //       Container(width: (Gss.width * .18) * ( 1 / 1.sr), height: (Gss.width * .18) * ( 1 / 1.sr),),
        // crossFadeState:
        // ref.watch(showFABProvider)?
        // CrossFadeState.showFirst: CrossFadeState.showSecond
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
                // BottomNavigationBar(
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
                //   ],
                // ),
                secondChild: Container(height: 100, width: 100,),
                crossFadeState:
                ref.watch(showBNBProvider)?
                CrossFadeState.showFirst: CrossFadeState.showSecond
            ),
            ),

      ]),


      // bottomNavigationBar:
      // AnimatedCrossFade(duration: Duration(milliseconds: 234),
      //   firstChild:
      // BottomNavigationBar(
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
      //   ],
      // ),
      //   secondChild: Container(height: 100, width: 100,),
      //     crossFadeState:
      //     ref.watch(showBNBProvider)?
      //     CrossFadeState.showFirst: CrossFadeState.showSecond
      // ),
    ));
  }
}






class AccountRequiredTab extends StatelessWidget {
  const AccountRequiredTab({super.key,
  required this.tabIndex,
  required this.title
  });
  final int tabIndex;
  final String title;

  final double titleHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
          mainAxisSize: MainAxisSize.max,
          children:[
            Container(
                color: Theme.of(context).scaffoldBackgroundColor,
            height: titleHeight,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(child:Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )),
            ),

            Expanded(child:Center(child:
            Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: Gss.width * .03, vertical: Gss.width * .03),
                      child:Text("You must create an account to access this feature",)),
                  CreateAccountRequiredButton()

                ])
            ))



          ])
    );
  }
}


class CreateAccountRequiredButton extends StatelessWidget {
  const CreateAccountRequiredButton({super.key});

  @override
  Widget build(BuildContext context) {
    return
      LayoutBuilder(
        builder: (context, constraints)
    {
      final w = math.min(constraints.maxWidth * 0.88, 555.0);
      return Center(
        child: SizedBox(
          width: w,
          child: RoundedOutlineButton(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
            },
            label: 'Go to Login',
          ),
        ),
      );
    });

  }
}


class CustomFloatingActionButton extends ConsumerWidget {
  const CustomFloatingActionButton({super.key,
  required this.size
  });
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // double boxSize = (Gss.width * .18) * ( 1 / 1.sr);
    return
      ClipRect( // Optional: ClipRect can be used to contain the effect to the child's bounds
          child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0, // Adjust the blur intensity horizontally
                sigmaY: 5.0, // Adjust the blur intensity vertically
              ),
              child:
              Container(
        height:size,
        width: size ,
      color:
      ref.watch(darkModeProv)?
      Colors.black.withValues(alpha:0.5):
                  Colors.white.withValues(alpha:0.5)
                  ,
      child: Center(child:Icon(Icons.arrow_drop_up, size: size * .7,))
    )));
  }
}


class CustomBottomNavBarItem extends ConsumerWidget {
  const CustomBottomNavBarItem({super.key,
    required this.index,
  required this.icon,
     this.label
  });

  final int index;
  final IconData icon;
  final String? label;


  @override
  Widget build(BuildContext context, WidgetRef ref) {


    double boxWidth = Gss.width / 4;
    // double boxHeight = (boxWidth) * ( 1 / 1.sr);

    return
      InkWell(
          onTap:(){
            ref.read(tabIndexProvider.notifier).state = index;
                // ref.read(showFABProvider.notifier).state = false;
                ref.read(tabIndexProvider.notifier).state = index;
                if (index == 0) {
                  ref.read(scrollControllerProvider.notifier).state = homeScrollController;
                }
                else if (index == 1) {
                  ref.read(scrollControllerProvider.notifier).state = bookingUpcomingScrollController;
                }
          },
          child:
      ClipRect( // Optional: ClipRect can be used to contain the effect to the child's bounds
          child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0, // Adjust the blur intensity horizontally
                sigmaY: 5.0, // Adjust the blur intensity vertically
              ),
              child:
              Container(
                  // height:size,
                  width: boxWidth ,
                  color:
                  ref.watch(darkModeProv)?
                      Colors.black.withValues(alpha:0.88):
                  Colors.white.withValues(alpha:0.88),
                  child: Center(child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     Icon(icon,
                     color: index == ref.watch(tabIndexProvider)? appPrimarySwatch[800]: null,
                     ),
                     label!=null?
                      Text(label!,
                           style:TextStyle(
                           color: index == ref.watch(tabIndexProvider)? appPrimarySwatch[800]: null,
                           )
                     ):Container()
                    ],)
                  )
              ))));
  }
}