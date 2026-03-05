
import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/modals/delete_account_dialog.dart';
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
import 'package:intl/intl.dart';


class BookingDetail extends ConsumerStatefulWidget {
  const BookingDetail({super.key,
    required this.booking
  });

  final Booking booking;

  @override
  ConsumerState<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends ConsumerState<BookingDetail> {

  double bookingDetailItemIconSize = 13.sr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Detail'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body:
    Padding(padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
    child:
      ListView(children: [
    SizedBox(height: Gss.height * .04),
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
            children:[Text(widget.booking.serviceName,
              style: TextStyle(fontSize: 17.sr, fontWeight: FontWeight.w500),
            ),]),
        SizedBox(height: Gss.height * .02),
        BookingInfoListItem(
            icon:Text(""),
            child: Row(children:[Text("Vendor: ",
              style: TextStyle(fontSize: 15.sr)),
                Flexible(child:Text( widget.booking.vendorBusinessName,
                  style: TextStyle(fontSize: 15.sr,
                    color: appPrimarySwatch[800],
                    fontWeight: FontWeight.w700,
                  ),
                ))
            ])),
        SizedBox(height: Gss.height * .02),
        BookingInfoListItem(
          icon:Text(""),
            child:Row(children:[Text("Status: ",
                style: TextStyle(fontSize: 15.sr)),
              BookingStatusIndicator(status: widget.booking.status,
                  textStyle: TextStyle(color:Colors.white, fontSize: 13.sr)
              ),
            ])),
        SizedBox(height: Gss.height * .02),
        BookingInfoListItem(
          icon:Text("𝄜",
          style: TextStyle(fontSize: bookingDetailItemIconSize),
          ),
            child:
            Text(" " + DateFormat('MMMM d, y h:mm a').format(widget.booking.bookingTime.toLocal()),
              style: TextStyle(fontSize: 16.sr),
            )),

        SizedBox(height: Gss.height * .03),
        BookingInfoListItem(
            icon: Icon(Icons.access_time_outlined,
            size: bookingDetailItemIconSize,
            ),
            child:
            widget.booking.timeLength != 0
                // && widget.booking.timeLength != null
                ?
            Text(" Duration: " + formatMinutesToHours(widget.booking.timeLength),
              style: TextStyle(fontSize: 15.sr),
            ):
            Text(" Duration: No time limit",
              style: TextStyle(fontSize: 15.sr,
              ),)
        ),
        SizedBox(height: Gss.height * .02),
        BookingInfoListItem(
          icon:Text("✧ ",
            style: TextStyle(fontSize: bookingDetailItemIconSize),
          ),
            child:
          // \u{1F30E}
            Text(" Site: " + widget.booking.site,
              style: TextStyle(fontSize: 15.sr),
            )),
        SizedBox(height: Gss.height * .02),
        widget.booking.address != null ?
        BookingInfoListItem(
            icon : Text("\u{1F4CD}",
              style: TextStyle(fontSize: bookingDetailItemIconSize),
            ),
            child:
            Text(" Address: " + widget.booking.address!,
              style: TextStyle(fontSize: 15.sr),
            )): Container(),
        SizedBox(height: Gss.height * .02),
        BookingInfoListItem(
          icon: Icon(Icons.receipt_long,
          size: bookingDetailItemIconSize
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

        // SizedBox(height: Gss.height * .02),
        // DashedLine(
        //   color: Colors.blueGrey[900]!,
        // ),
        // SizedBox(height: Gss.height * .01),
        // BookingInfoListItem(
        //     child:
        //     Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children:[
        //           SizedBox(width: Gss.width * .02,),
        //           Text(formatCents(widget.booking.priceCents),
        //             style: TextStyle(fontSize: 18.sr,
        //               color: appPrimarySwatch[600],
        //               fontWeight: FontWeight.w600,
        //             ),
        //
        //           )])),

        SizedBox(height: Gss.height * .045),

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
              widget.booking.vendorUserId,
                  widget.booking.clientUserName,
              widget.booking.vendorUserName,
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
          label: "Message Vendor",
          width: Gss.width * .7,
          paddingVertical: Gss.height * .01,
        ),
        SizedBox(height: Gss.height * .05),

        widget.booking.status == "confirmed" ||
        widget.booking.status == "pending"
        ?
        RoundedOutlineButton(onTap: (){

          BuildContext pageContext = context;

          // showDialog(
          // context: context,
          // builder: (context) {
          // return Center(
          // child: ListView(shrinkWrap: true, children: [
          //   AlertDialog(
          //     title: Text("Cancel Booking?"),
          //     content: Text(
          //       widget.booking.status == "confirmed"?
          //       "Are you sure you want to cancel this booking? An 8% fee of the service price: ${ formatCents((widget.booking.priceCents * .08).round())} will be withheld. You will receive a refund of ${ formatCents((widget.booking.priceCents - (widget.booking.priceCents * .08)).round())}":
          //       widget.booking.status == "pending"?
          //       "Are you sure you want to cancel this booking?":
          //       "",/// shouldnt reach,
          //     style: Theme.of(context).textTheme.titleLarge,
          //     ),
          //     actions: [
          //       RoundedOutlineButton(
          //           onTap: () {
          //             Navigator.of(context).pop();
          //           },
          //           label: "No, go back"),
          //
          //       Padding(
          //           padding: EdgeInsets.symmetric(vertical: 12.sr),
          //           child: RoundedOutlineButton(
          //             color: Colors.redAccent,
          //               onTap: () async{
          //                 await _cancelRoutine(pageContext, ref, widget.booking.bookingId);
          //               },
          //               label: "Yes, cancel")),
          //     ],
          //   )]));});

          showConfirmCancelBookingDialog(context,ref, username: ref.read(userAuthProv)!.userName,
              onConfirm:()async{ await _cancelRoutine(pageContext, ref, widget.booking.bookingId); },
              booking: widget.booking);

        },
          label: "Cancel",
          width: Gss.width * .7,
          paddingVertical: Gss.height * .01,
          color: Colors.redAccent,
        ):Container(),
        SizedBox(height: Gss.height * .05),

      ])),
    );
  }
}

_cancelRoutine(BuildContext context, WidgetRef ref, String bookingId) async {
  lg.t("[_cancelRoutine] called");
  Navigator.of(context, rootNavigator: true).pop();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  await cancelBooking(
      ref.read(userAuthProv)!.userToken,
      ref.read(userAuthProv)!.userId,
      "client", /// this page is for clients
      bookingId);

  lg.t("pop loading spinner");
  Navigator.of(gNavigatorKey.currentContext!, rootNavigator: true).pop();
  lg.t("push success screen");
  Navigator.of(gNavigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(builder: (context)
  {
    return SuccessScreen(
      message: "Booking Cancelled",
      continueCallback: () {
        lg.t("refresh upcoming bookings");
        var refresh = ref.refresh(bookingsUpcomingProvider);
        lg.t("wants to use refresh ~ " + refresh.toString());
        // ref.refresh(bookingsPastProvider);
        lg.t("push client home");
        Navigator
            .of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(
          "/client_home",
              (route) => false,
        ); // Remove loading dialog
      },
    );
    }));
}

class BookingInfoListItem extends StatelessWidget {
  const BookingInfoListItem({super.key,
    required this.child,
    required this.icon
  });

  final Widget child;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return
      IntrinsicHeight(
      child:Row(children:[
        Container(
            // color: Colors.green,
        child:Column(
            mainAxisSize: MainAxisSize.max,
            children:[
              SizedBox(height: 6.sr + 4.sr,), /// 7.sr half of font size for items
              icon])),

        Flexible(child: Padding(padding: EdgeInsets.symmetric(vertical: 6.sr),
            child: child))
      ]));
  }
}



  Future<void> showConfirmCancelBookingDialog(
      BuildContext context,
      WidgetRef ref,
      {
        required String username,
        required Future<void> Function() onConfirm,
        required Booking booking
      }) {
    final TextEditingController controller = TextEditingController();
    final ValueNotifier<bool> isMatch = ValueNotifier(false);
    final isLoading = ValueNotifier(false);

    return showDialog(
      context: context,
      barrierDismissible: !isLoading.value,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Cancel'),
          content:
          SingleChildScrollView(
              child: ListBody(
                  children: <Widget>[
                    Text(
                            booking.status == "confirmed"?
                            "Are you sure you want to cancel this booking? An 8% fee of the service price: ${ formatCents((booking.priceCents * .08).round())} will be withheld. You will receive a refund of ${ formatCents((booking.priceCents - (booking.priceCents * .08)).round())}":
                            booking.status == "pending"?
                            "Are you sure you want to cancel this booking?":
                            "",/// shouldnt reach,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    Text('Type your username $username to confirm deletion:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Username',
                      ),
                      onChanged: (value) {
                        isMatch.value = value.trim() == username.trim();
                      },
                    ),
                    SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: isLoading,
                      builder: (context, loading, _) {
                        if (loading) {
                          return Column(
                            children: [
                              SizedBox(height: 8),
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),

                  ])

          ),

          actions: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  ValueListenableBuilder<bool>(
                    valueListenable: isLoading,
                    builder: (context, loading, _) {
                      return TextButton(
                        onPressed: loading ? null : () => Navigator.of(context).pop(),
                        child: Text('Go back'),
                      );
                    },
                  ),
                  ValueListenableBuilder2<bool, bool>(
                    first: isMatch,
                    second: isLoading,
                    builder: (context, match, loading, _) {
                      return ElevatedButton(
                          onPressed: (match && !loading)
                              ? () async {
                            isLoading.value = true;
                            try {
                              lg.t("start onConfirm");
                              await onConfirm();
                              Navigator.of(gNavigatorKey.currentContext!).pop();
                            } catch (e) {
                              lg.e("Exp caught in cancel booking press ~ " + e.toString());
                              isLoading.value = false;
                              Navigator.of(gNavigatorKey.currentContext!).pop();
                              ScaffoldMessenger.of(gNavigatorKey.currentContext!).showSnackBar(
                                SnackBar(content: Text('Failed to delete: $e')),
                              );
                            }
                          }
                              : null,
                          style:  ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        child: Text('Cancel it',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  )]),
          ],
        );
      },
    );
  }