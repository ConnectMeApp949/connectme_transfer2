import 'dart:convert';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/models/bookings/booking.dart';
import 'package:connectme_app/models/messeging/user_message_thread.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/bookings.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/bookings/cancel_booking.dart';
import 'package:connectme_app/requests/messeging/get_or_create_thread.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/bookings/bookings_tab.dart';
import 'package:connectme_app/views/etc/success_screen.dart';
import 'package:connectme_app/views/messaging/chat_page.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


Future confirmBookingAndPay(String userId, String userToken, String bookingId) async{
  var confirmResp = await http.post(Uri.parse(confirm_booking_and_pay_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      "authToken": userToken,
      'bookingId': bookingId,
    }),
  );

  return json.decode(confirmResp.body);
}

class AppointmentDetail extends ConsumerStatefulWidget {
  const AppointmentDetail({super.key,
  required this.booking
  });

  final Booking booking;

  @override
  ConsumerState<AppointmentDetail> createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends ConsumerState<AppointmentDetail> {

  double appointmentDetailItemIconSize = 13.sr;
  @override
  Widget build(BuildContext context) {
    lg.t("build appointment detail main build");
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Detail')),
      body:
      Padding(padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
      child:ListView(children: [
        SizedBox(height: Gss.height * .04),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Flexible(
              child:Text(widget.booking.serviceName,
              style: TextStyle(fontSize: 17.sr, fontWeight: FontWeight.w700),
            )),]),
      SizedBox(height: Gss.height * .02),
        AppointmentInfoListItem(
          icon: Text(""),
        child:
        Row(children:[Text("Client: ",
    style: TextStyle(fontSize: 15.sr,)
    ),
        Flexible(child:Text( widget.booking.clientUserName,
          style: TextStyle(fontSize: 15.sr,
            color: appPrimarySwatch[800],
            fontWeight: FontWeight.w700,
          ),
        ))])),

        AppointmentInfoListItem(
          icon: Text(""),
            child:Row(children:[Text("Status: ",
                style: TextStyle(fontSize: 15.sr)),
              BookingStatusIndicator(status: widget.booking.status,
                  textStyle: TextStyle(color:Colors.white, fontSize: 13.sr)
              ),
            ])),

        SizedBox(height: Gss.height * .01),
        AppointmentInfoListItem(
            icon:Text("𝄜",
              style: TextStyle(fontSize: appointmentDetailItemIconSize),
            ),
          child:
            // \u{1F561}
          Text( DateFormat(' MMMM d, y h:mm a').format(widget.booking.bookingTime.toLocal()),
          style: TextStyle(fontSize: 16.sr),
        )),
          // \u{1F4DF}


        SizedBox(height: Gss.height * .01),
        AppointmentInfoListItem(
            icon: Icon(Icons.access_time_outlined,
              size: appointmentDetailItemIconSize,
            ),
          child:
          // widget.booking.timeLength != null
              // && widget.booking.timeLength != 0
              // ?
          Text(" Duration: " + formatMinutesToHours( widget.booking.timeLength),
          style: TextStyle(fontSize: 15.sr),
        )
          //     :
          // // \u{23F3}
          // Text(" Duration: No time limit",
          //   style: TextStyle(fontSize: 15.sr,
          //   ),)
        ),
        SizedBox(height: Gss.height * .01),
        AppointmentInfoListItem(
            icon:Text("✧ ",
              style: TextStyle(fontSize: appointmentDetailItemIconSize),
            ),
          child:
        // \u{1F30E}
        //   ⌖
        Text(" Site: " + widget.booking.site,
          style: TextStyle(fontSize: 15.sr),
        )),
        SizedBox(height: Gss.height * .01),
        widget.booking.address != null ?
        AppointmentInfoListItem(
            icon : Text("\u{1F4CD}",
              style: TextStyle(fontSize: appointmentDetailItemIconSize),
            ),
            child:
          // ⚲
        Text(" Address: " + widget.booking.address!,
          style: TextStyle(fontSize: 15.sr),
        )): Container(),



        // DashedLine(
        //   color: Colors.blueGrey[900]!,
        // ),
        //
        // SizedBox(height: Gss.height * .01),

        AppointmentInfoListItem(
            icon: Icon(Icons.monetization_on_outlined,
                size: appointmentDetailItemIconSize
            ),
            child:
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Text(" Price: " +formatCents(widget.booking.priceCents),
                    style: TextStyle(
                      fontSize:15.sr,
                      // fontSize: 22.5.sr,
                      // color: appPrimarySwatch[600],
                      // fontWeight: FontWeight.w700,
                    ),
                  )])),
SizedBox(height: Gss.height * .2),


        RoundedOutlineButton(onTap: () async{

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child:
            CircularProgressIndicator(color: appPrimarySwatch,)),
          );

          try {
            UserMessageThread getThread =
            await getOrCreateThread(
              ref,
              ref.read(userAuthProv)!.userId,
              ref.read(userAuthProv)!.userName,
              ref.read(userAuthProv)!.userId,
              widget.booking.clientUserId,
              ref.read(userAuthProv)!.userName,
              widget.booking.clientUserName,
            );
            Navigator.pop(gNavigatorKey.currentContext!);
            Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
              return ChatPage(thread: getThread);
            }));
          }catch(e){
            lg.e("error getting thread ~ " + e.toString());
            Navigator.pop(gNavigatorKey.currentContext!);
            showErrorDialog(gNavigatorKey.currentContext!, default_error_message);
          }

        },
          label: "Message Client",
          width: Gss.width * .7,
          paddingVertical: Gss.height * .01,
        ),
        SizedBox(height: Gss.height * .035),

        widget.booking.status == "pending"?
        RoundedOutlineButton(onTap: ()async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
          var confirmBookingAndPayResp = await confirmBookingAndPay(
              ref.read(userAuthProv)!.userId,
              ref.read(userAuthProv)!.userToken,
              widget.booking.bookingId);

          Navigator.pop(gNavigatorKey.currentContext!);

          lg.t("check parties ready");
          if (confirmBookingAndPayResp["parties_ready"] == false) {
            showErrorDialog(gNavigatorKey.currentContext!, parties_not_ready_message);
          }

          if (confirmBookingAndPayResp["success"] == true) {
            Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
              return SuccessScreen(
                message: "Booking Confirmed. Payment Processing",
                continueCallback: () async {
                  //TODO [optimize]
                  await ref.read(bookingsUpcomingProvider.notifier).reload();
                  Navigator.of(gNavigatorKey.currentContext!, rootNavigator: true).pushNamedAndRemoveUntil(
                    "/vendor_home",
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
          label: "Confirm and Accept Payment",  // "Message Client",
          width: Gss.width * .7,
          paddingVertical: Gss.height * .01,
          color: Colors.green,
        ):Container(),
        SizedBox(height: Gss.height * .038),

        widget.booking.status == "confirmed" ||
        widget.booking.status == "pending"
            ?
        /// hard need to do refund
        RoundedOutlineButton(onTap: ()async {

          BuildContext pageContext = context;

          showDialog(
              context: context,
              builder: (context) {
                return Center(
                    child: ListView(shrinkWrap: true, children: [
                      AlertDialog(
                        title: Text("Cancel Booking?"),
                        content: Text(
                            widget.booking.status == "confirmed"?
                            "Are you sure you want to cancel this booking? A reverse transfer will be initiated for the service price plus the platform fee from your account.":
                            "Are you sure you want to cancel this booking?",
                          style: Theme.of(context).textTheme.titleLarge,

                        ),
                        actions: [
                          RoundedOutlineButton(

                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              label: "No, go back"),

                          //TODO send to type confirm dialog after this
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.sr),
                              child: RoundedOutlineButton(
                                  color: Colors.red,
                                  onTap: () async{
                                    await _cancelRoutine(pageContext, ref, widget.booking.bookingId);
                                  },
                                  label: "Cancel it and Refund")),
                        ],
                      )
                    ]));});

        },
          label: "Cancel",  // "Message Client",
          width: Gss.width * .7,
          paddingVertical: Gss.height * .01,
          color: Colors.redAccent,
        )
            :Container(), /// completed booking no cancel option

        SizedBox(height: Gss.height * .05),


      ])),
    );
  }
}

_cancelRoutine(BuildContext context, WidgetRef ref, String bookingId) async {
  Navigator.of(context, rootNavigator: true).pop();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  await cancelBooking(
      ref.read(userAuthProv)!.userToken,
      ref.read(userAuthProv)!.userId,
      "vendor", /// this page is for vendors
      bookingId);

  Navigator.of(gNavigatorKey.currentContext!, rootNavigator: true).pop();

  Navigator.of(gNavigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(builder: (context)
  {
    return SuccessScreen(
      message: "Booking Cancelled",
      continueCallback: () {
        var refresh = ref.refresh(bookingsUpcomingProvider);
        lg.t("wants to use refresh ~ " + refresh.toString());
        // ref.refresh(bookingsPastProvider);
        Navigator
            .of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(
          "/vendor_home",
              (route) => false,
        ); // Remove loading dialog
      },
    );
  }));
}

class AppointmentInfoListItem extends StatelessWidget {
  const AppointmentInfoListItem({super.key,
  required this.child,
    required this.icon
  });

  final Widget child;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return
    Padding(padding: EdgeInsets.symmetric(vertical: 6.sr),
    child:
    IntrinsicHeight(
        child:
    Row(children:[
      Container(
// color: Colors.green,
          child:Column(
              mainAxisSize: MainAxisSize.max,
              children:[
                SizedBox(height: 6.sr ), /// 7.sr half of font size for items
                icon])),
      Flexible(child:child)])));
  }
}

