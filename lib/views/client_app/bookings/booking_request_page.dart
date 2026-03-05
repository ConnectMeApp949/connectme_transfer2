

import 'dart:async';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/components/ui/modals/use_suggested_address_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/bookings/create_booking.dart';
import 'package:connectme_app/requests/location/location.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/etc/success_screen.dart';
import 'package:connectme_app/views/service/service_detail.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class BookingRequestPage extends ConsumerStatefulWidget {
  const BookingRequestPage({super.key,
required this.bookingDate
});
  final DateTime bookingDate;


  @override
  ConsumerState<BookingRequestPage> createState() => _BookingRequestPageState();
}

class _BookingRequestPageState extends ConsumerState<BookingRequestPage> {

  final _addressController = TextEditingController();

  String? confirmedAddress;
  bool showSaveAddressButton = false;

  @override
  initState() {
    super.initState();
    scheduleMicrotask(() async {
      _addressController.text = ref.watch(clientUserMetaProv)!.address??"";
      confirmedAddress = ref.watch(clientUserMetaProv)!.address;
    });
  }

  @override
  dispose(){
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Booking Request'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body:
      Padding(padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
          child:
          ListView(children: [
            SizedBox(height: Gss.height * .04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Flexible(
                      child:
                  Text(ref.watch(bookNowServiceProv)!.name,
                    style: TextStyle(fontSize: 17.sr, fontWeight: FontWeight.w700),
                  )),]),
            SizedBox(height: Gss.height * .02),
            BookingInfoListItem(
                child:
                Row(children:[Text("Vendor: " ,
                  style: TextStyle(fontSize: 15.sr,
                  color: appPrimarySwatch[700]
                  ),
                ),
                  Flexible(child:Text( ref.watch(bookNowServiceProv)!.vendorBusinessName,
                    style: TextStyle(fontSize: 15.sr,
                      color: appPrimarySwatch[700],
                      fontWeight: FontWeight.w700,
                    ),
                  ))
                ])),
            SizedBox(height: Gss.height * .02),
            BookingInfoListItem(
                child:
                Text("𝄜 " + DateFormat('MMMM d, y h:mm a').format(widget.bookingDate),
                  style: TextStyle(fontSize: 16.sr),
                )),
            SizedBox(height: Gss.height * .01),
            BookingInfoListItem(
                child:
                ref.watch(bookNowServiceProv)!.timeLength != 0 && ref.watch(bookNowServiceProv)!.timeLength != null?
                Text("⏱ Duration: " + formatMinutesToHours(ref.watch(bookNowServiceProv)!.timeLength!),
                  style: TextStyle(fontSize: 15.sr),
                ):
                Text("⏱ Duration: No time limit",
                  style: TextStyle(fontSize: 17.sr,
                  ),)
            ),
            BookingInfoListItem(
                child:
                Text("Price: " + formatCents(ref.watch(bookNowServiceProv)!.priceCents),
                  style: TextStyle(fontSize: 17.sr,
                    color: appPrimarySwatch[700],
                    fontWeight: FontWeight.w600,
                  ),
                )),
            BookingInfoListItem(
                child:
                Text("✧ Site: " + ref.watch(bookNowServiceProv)!.site,
                  style: TextStyle(fontSize: 15.sr),
                )),

            (ref.watch(bookNowServiceProv)!.site == "on-site"
            )?
            BookingInfoListItem(
                child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Flexible(child:Text("\u{1F4CD} Address: " + (ref.watch(bookNowServiceProv)!.address??""),
                            style: TextStyle(fontSize: 15.sr),
                          )),
                        ])):
            ((ref.watch(bookNowServiceProv)!.site == "client-site" ||
                ref.watch(bookNowServiceProv)!.site == "delivery")
            )?
                Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      BookingInfoListItem(
                          child:
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                          Text("\u{1F4CD} Address: ",
                            style: TextStyle(fontSize: 15.sr),
                          ),
                                showSaveAddressButton?
                                GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        showSaveAddressButton = false;
                                      });
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => const Center(child: CircularProgressIndicator()),
                                      );

                                      var resp = await lookupSuggestedAddress(_addressController.text);

                                      lg.t("lookup address resp ~ " + resp.toString());
                                      if (resp.containsKey("display_name")) {
                                        lg.t("found results");
                                        bool userAccepted = await showUseSuggestedAddressDialog(gNavigatorKey.currentContext!, resp,
                                            ()async {
                                                                 lg.t("Set address controller");
                                                                _addressController.text = resp["display_name"];
                                                                setState(() {
                                                                  confirmedAddress = resp["display_name"];
                                                                });

                                                                /// set as new client address option
                                                                // ClientUserMeta existing = ref.read(
                                                                //     clientUserMetaProv)!;
                                                                // GeoHasher geoHasher = GeoHasher();
                                                                // String geoHash = geoHasher.encode(
                                                                //     double.parse(resp["lon"]), double.parse(resp["lat"]));
                                                                // ClientUserMeta updated = existing.copyWith(
                                                                //   address: resp["display_name"],
                                                                //   geoHash: geoHash,
                                                                //   location: {
                                                                //     "lat": resp["lat"],
                                                                //     "lng": resp["lon"]
                                                                //   },
                                                                // );
                                                                // ref.read(clientUserMetaProv.notifier).state = updated;
                                                                Navigator.of(context).pop(true);
                                        },
                                                ()async {
                                                        _addressController.text = "";
                                                        Navigator.of(context).pop(false);
                                        });
                                        // bool userAccepted = await showDialog(context: context, builder: (context) =>
                                        //     AlertDialog(
                                        //       title: Text("Use Suggested Address?"),
                                        //       content: Text(resp["display_name"]??"Not Found"),
                                        //       actions: [
                                        //         RoundedOutlineButton(
                                        //             onTap: () {
                                        //               _addressController.text = "";
                                        //               Navigator.of(context).pop(false);
                                        //             },
                                        //             label: "Cancel"),
                                        //
                                        //         Padding(
                                        //             padding: EdgeInsets.symmetric(vertical: 12.sr),
                                        //             child: RoundedOutlineButton(
                                        //                 onTap: () async{
                                        //                   print("Set address controller");
                                        //                   _addressController.text = resp["display_name"];
                                        //                   setState(() {
                                        //                     confirmedAddress = resp["display_name"];
                                        //                   });
                                        //
                                        //                   /// set as new client address option
                                        //                   // ClientUserMeta existing = ref.read(
                                        //                   //     clientUserMetaProv)!;
                                        //                   // GeoHasher geoHasher = GeoHasher();
                                        //                   // String geoHash = geoHasher.encode(
                                        //                   //     double.parse(resp["lon"]), double.parse(resp["lat"]));
                                        //                   // ClientUserMeta updated = existing.copyWith(
                                        //                   //   address: resp["display_name"],
                                        //                   //   geoHash: geoHash,
                                        //                   //   location: {
                                        //                   //     "lat": resp["lat"],
                                        //                   //     "lng": resp["lon"]
                                        //                   //   },
                                        //                   // );
                                        //                   // ref.read(clientUserMetaProv.notifier).state = updated;
                                        //                   Navigator.of(context).pop(true);
                                        //
                                        //                 },
                                        //                 label: "Ok")),
                                        //       ],
                                        //     ));

                                        if (userAccepted == false){
                                          Navigator.pop(gNavigatorKey.currentContext!);
                                        }
                                        if (userAccepted == true){
                                          Navigator.pop(gNavigatorKey.currentContext!);
                                        }
                                      }else{
                                        lg.t("didnt find results");
                                        _addressController.text = "";
                                        Navigator.pop(gNavigatorKey.currentContext!);
                                        showErrorDialog(gNavigatorKey.currentContext!, "Address not found");
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color:
                                              (ref.watch(darkModeProv) ?
                                              appPrimarySwatch[900]!:
                                              appPrimarySwatch),
                                              width: 1.sr),
                                          borderRadius: BorderRadius.circular(999)),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4.sr,
                                        horizontal: 8.sr,
                                      ),
                                      child: Center(
                                          child: Text("Save",
                                              style: TextStyle(
                                                fontSize:Theme.of(context).textTheme.bodyLarge!.fontSize,
                                                color:
                                                    (
                                                        Theme.of(context).textTheme.bodyLarge!.color!
                                                    ),
                                              ))),
                                    )):Container()
                              ])),
                      TextField(
                        maxLines: 3,
              style: TextStyle(fontSize: 17.sr),
              controller: _addressController,
              decoration: InputDecoration(

              ),
              autofocus: true,
              onChanged:(val){
                          setState(() {
                            confirmedAddress = null;
                            showSaveAddressButton = true;
                          });
              },
              onSubmitted: (newValue) {
                  lg.t("on submitted called");
              },
              onEditingComplete: () async{
                lg.t("on editing complete called");
                          /// not getting called
              },
            )]):
            Container(), /// for remote,

            ((ref.watch(bookNowServiceProv)!.site == "client-site" ||
                ref.watch(bookNowServiceProv)!.site == "delivery") &&
                confirmedAddress != null
            )?
          BookingInfoListItem(
              child:Text(confirmedAddress!)):
            ((ref.watch(bookNowServiceProv)!.site == "client-site" ||
                ref.watch(bookNowServiceProv)!.site == "delivery") &&
                confirmedAddress == null
            )?
            BookingInfoListItem(
                child:Text("Please confirm address",
                  style: TextStyle(fontSize: 17.sr),
                )):
            Container(),

            SizedBox(height: Gss.height * .1),


            RoundedOutlineButton(onTap: ()async{


              if (ref.watch(bookNowServiceProv)!.site == "client-site" ||
                  ref.watch(bookNowServiceProv)!.site == "delivery"){

                if (confirmedAddress == null){
                  showErrorDialog(context, "Please set address");
                  return;
                }

                if (_addressController.text.isEmpty || _addressController.text == ""){
                  showErrorDialog(context, "Please set address");
                  return;
                }
                else{

                }
              }

              String? useBookingAddress;

              if (ref.watch(bookNowServiceProv)!.site == "on-site"){
                useBookingAddress = ref.watch(bookNowServiceProv)!.address;
              }

              if (ref.watch(bookNowServiceProv)!.site == "client-site" ||
              ref.watch(bookNowServiceProv)!.site == "delivery"){
                useBookingAddress = confirmedAddress;
              }

              if (ref.watch(bookNowServiceProv)!.site == "remote"){
                useBookingAddress = null;
              }


              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  String createBookingId = generateRandomAlphanumeric(15);

                  var createBookingResp = await createBooking(
                  ref.read(userAuthProv)!.userToken,
                  useBookingAddress,
                  ref.read(bookNowServiceProv)!,
                  widget.bookingDate.toUtc(),
                  ref.read(userAuthProv)!.userId,
                  ref.read(userAuthProv)!.userName,
                  createBookingId
                  );

                  if(appConfig.simulateNetworkLatency){
                  await Future.delayed(Duration(milliseconds: 3000), () {});
                  }

                  Navigator.of(gNavigatorKey.currentContext!, rootNavigator: true).pop();

                  if (createBookingResp["parties_ready"] == false) {
                  showErrorDialog(gNavigatorKey.currentContext!, parties_not_ready_message);
                  }

                  if (createBookingResp["success"] == true) {
                  Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
                      return SuccessScreen(
                      message: "Booking Request Submitted",
                      continueCallback: (){
                      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                      "/client_home",
                      (route) => false,
                      ); // Remove loading dialog
                      },
                      );
                      }));
                  }

                  else{
                  showErrorDialog(gNavigatorKey.currentContext!, "Something went wrong. Please try again later");
                  }
            },
              label: "Submit Booking Request",
              width: Gss.width * .7,
              paddingVertical: Gss.height * .01,
            ),
            SizedBox(height: Gss.height * .05),
            // widget.booking.status != "complete"?
            // RoundedOutlineButton(onTap: (){
            //   // Navigator.of(context).pop();
            // },
            //   label: "Cancel",
            //   width: Gss.width * .7,
            //   paddingVertical: Gss.height * .01,
            //   color: Colors.redAccent,
            // ):Container(),
            SizedBox(height: Gss.height * .05),

          ])),
    );
  }
}


class BookingInfoListItem extends StatelessWidget {
  const BookingInfoListItem({super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return
    Row(children:[
      Flexible(child: Padding(padding: EdgeInsets.symmetric(vertical: 6.sr),
          child: child))
    ]);
  }
}










