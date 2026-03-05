import 'dart:async';

import 'package:connectme_app/config/globals.dart';

import 'package:connectme_app/models/bookings/booking.dart';
import 'package:connectme_app/models/user/etc.dart';

import 'package:connectme_app/providers/bookings.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/bookings/booking_detail.dart';

import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:connectme_app/views/vendor_app/appointments/appointment_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:intl/intl.dart';



enum BookingTimeType{
  upcoming,
  past
}

final bookingSelectedProvider = StateProvider<BookingTimeType>(
        (ref) => BookingTimeType.upcoming);



class BookingsTab extends ConsumerStatefulWidget {
  const BookingsTab ({super.key,
    required this.tabIndex,
    required this.ownerType,
  });
  final int tabIndex;
  final UserType ownerType;

  @override
  ConsumerState<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends ConsumerState<BookingsTab> {

  // final ScrollController _scrollController = ScrollController();

  final double titleInitHeight = 60.0;
  double subtitleInitHeight = 60.0;

  final double maxHeaderHeight = 160.0; // all items added together
  double titleHeight = 60.0;
  double subtitleHeight = 60.0;


  bool showFAB = false;

  double _lastOffset = 0;
  double _headerOffset = 0;
  // double lastTitleHeight = 0;

  final titleHeightNotifier = ValueNotifier<double>(60.0); /// titleInitHeight
  final subtitleHeightNotifier = ValueNotifier<double>(60.0); /// subtitleInitHeight

  late VoidCallback bookingUpcomingScrollListener;
  late VoidCallback bookingPastScrollListener;

  Timer? _debounceTimer;

  bool _moreBookingItemsLoading = false;

  @override
  void initState() {
    super.initState();
    lg.t("Booking tab scroll controller initState");

    void handleScroll(WidgetRef ref, ScrollController scrollController) {
      final offset = scrollController.offset;

      final scrollDelta = offset - _lastOffset;
      _lastOffset = offset;

      _headerOffset -= scrollDelta;
      _headerOffset = _headerOffset.clamp(0.0, maxHeaderHeight);

      // Animate section heights based on header offset
      final remaining = _headerOffset;

      titleHeight = remaining > 100 ? titleInitHeight :
      (remaining - subtitleInitHeight).clamp(0, titleHeight);
      subtitleHeight = remaining > titleInitHeight ? subtitleInitHeight :
      (remaining ).clamp(0, subtitleInitHeight);

      titleHeightNotifier.value = titleHeight;
      subtitleHeightNotifier.value = subtitleHeight;

      // for FAB
      // bool shouldShowFAB = offset > 100;
      // if (shouldShowFAB != showFAB) {
      //   showFAB = shouldShowFAB;
      //   ref.read(showFABProvider.notifier).state = showFAB;
      // }

      /// trigger pagination
      if (ref.watch(scrollControllerProvider).hasClients) {
        if (ref
            .watch(scrollControllerProvider)
            .position
            .pixels >=
            ref.watch(scrollControllerProvider).position.maxScrollExtent ) {

          if (_debounceTimer?.isActive ?? false) return;

          if (ref.watch(bookingSelectedProvider) == BookingTimeType.upcoming) {
            if (!ref.read(upcomingHasMoreNotifierProvider)){
              return;
            }
          }
          else if (ref.watch(bookingSelectedProvider) == BookingTimeType.past) {
            if (!ref.read(pastHasMoreNotifierProvider)){
              return;
            }
          }

          _debounceTimer = Timer(const Duration(milliseconds: 1300), () {
            setState(() {
              _moreBookingItemsLoading = true;
            });
            Future.delayed(Duration(milliseconds: 1300), () {
              setState(() {
                _moreBookingItemsLoading = false;
              });
            });

              if (ref.watch(bookingSelectedProvider) == BookingTimeType.upcoming) {
                ref.read(bookingsUpcomingProvider.notifier).loadMore();
              }
              else if (ref.watch(bookingSelectedProvider) == BookingTimeType.past) {
                ref.read(bookingsPastProvider.notifier).loadMore();
              }
          });

        }
      }

    }

    /// force upcoming tab to be selected on init
    scheduleMicrotask(() {
      ref.read(bookingSelectedProvider.notifier).state = BookingTimeType.upcoming;
    });

    bookingUpcomingScrollListener = () => handleScroll(ref, bookingUpcomingScrollController);
    bookingUpcomingScrollController.addListener(bookingUpcomingScrollListener);
    bookingPastScrollListener = () => handleScroll(ref, bookingPastScrollController);
    bookingPastScrollController.addListener(bookingPastScrollListener);
    _headerOffset = titleHeight + subtitleHeight;
  }

  @override
  void dispose() {
    try {bookingPastScrollController.removeListener(bookingPastScrollListener);}catch(e) {
      lg.e("error removing booking past scroll listener ~ " + e.toString());
    }
    try{bookingUpcomingScrollController.removeListener(bookingUpcomingScrollListener);} catch(e) {
      lg.e("error removing booking upcoming scroll listener ~ " + e.toString());
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    lg.t("build bookings tab main build");
    final asyncPastItems = ref.watch(bookingsPastProvider);
    final asyncUpcomingItems = ref.watch(bookingsUpcomingProvider);

    return
      Column(
          children: [
        ValueListenableBuilder<double>(
        valueListenable: titleHeightNotifier,
        builder: (context, value, child) {
          return AnimatedContainer(
            color: Theme.of(context).scaffoldBackgroundColor,
              duration: Duration(milliseconds: 200),
              height: titleHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child:Text(
                widget.ownerType == UserType.client ? "Bookings" : "Appointments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              )),
            ); }),
            ValueListenableBuilder<double>(
            valueListenable: subtitleHeightNotifier,
            builder: (context, value, child) {
              return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: subtitleHeight,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                            child:Row(children: [
                              Expanded(child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Flexible(child:Text(widget.ownerType == UserType.client ? "Your Bookings" : "Your Appointments",
                                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  // )),
                                ],)
                              ),
                              IconButton(onPressed: ()async {
                                // ref.refresh(bookingsUpcomingProvider);
                                // ref.refresh(bookingsPastProvider);
                                await ref.read(bookingsUpcomingProvider.notifier).reload();
                                await ref.read(bookingsPastProvider.notifier).reload();
                              },
                                  icon: Icon(Icons.refresh)
                              )
                             ])));
                  }),
            Container(
              decoration: BoxDecoration(
                color:
                ref.read(darkModeProv)?
                Theme.of(context).scaffoldBackgroundColor:
                Theme.of(context).appBarTheme.backgroundColor,
                  boxShadow: [
                  BoxShadow(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: -2.sr,
                  )]
              ),
                // padding:EdgeInsets.symmetric(horizontal: 16),
                child:
                Row(children: [
                  Expanded(child:
                  InkWell(
                    splashColor: appPrimarySwatch.withValues(alpha:0.2),
                    onTap: (){
                      ref.read(bookingSelectedProvider.notifier).state = BookingTimeType.upcoming;
                      ref.read(scrollControllerProvider.notifier).state = bookingUpcomingScrollController;
                    },
                  child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.elliptical(8.sr, 2.sr)),
                      border:ref.watch(bookingSelectedProvider) == BookingTimeType.upcoming ?
                      Border(bottom:BorderSide(color: appPrimarySwatch, width: 2.sr))
                              : null
                    ),
                    // height: 55.sr,
                  child:Center(child:
                  Padding(
                      padding: EdgeInsets.symmetric(vertical:6.sr ),
                      child:Text("Upcoming",
                      style: Theme.of(context).textTheme.bodyLarge,
                      )))))),
                  Expanded(child:
                  InkWell(
                  splashColor: appPrimarySwatch.withValues(alpha:0.2),
                  onTap: (){
                    ref.read(bookingSelectedProvider.notifier).state = BookingTimeType.past;
                    ref.read(scrollControllerProvider.notifier).state = bookingPastScrollController;
                  },
                  child:
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(8.sr, 2.sr)),
                          border:ref.watch(bookingSelectedProvider) == BookingTimeType.past ?
                          Border(bottom:BorderSide(color: appPrimarySwatch, width: 2.sr))
                              : null
                      ),
                      // height: 55.sr,
                      child:Center(child:
                      Padding(
                      padding: EdgeInsets.symmetric(vertical:6.sr ),
                      child:Text("Past",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ))))))
                ])
            ),
    Builder(builder:(context){
    lg.t("build bookings tab mid sized box ");
            return SizedBox(height: Gss.height * .02);
    }),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
                  child:

                ref.watch(bookingSelectedProvider) == BookingTimeType.past ?
                  asyncPastItems.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e_obj, e_stacktracke){
                  lg.e("[BookingsTab asyncItems] error ~ " + e_obj.toString());
                  lg.e(e_stacktracke.toString());
                  return Center(child: Text('Error: Please try again later'));},
                  data: (items) {
                    if (items.isEmpty) {
                      return Container(height: Gss.height * .44,
                          child: Center(child: Text(nothingHereYetMessage,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )));
                    }
                    if (items.isNotEmpty) {
                      lg.t("past items len ~ " + items.length.toString());
                      return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          controller: bookingPastScrollController,
                          itemCount: items.length + 1,
                          itemBuilder: (_, i) {
                            lg.t("build bli ~ " + i.toString());

                            if (i == items.length){ /// add little space at bottom for bottom nav bar overlap
                              return SizedBox(height: Gss.height*.23,);
                            }

                            return BookingsListItem(booking: items[i],
                                ownerType: widget.ownerType
                            );
                          }
                      );
                    }
                    lg.e("thing not able to build");
                    return Container();
                  }
                  ):
                ref.watch(bookingSelectedProvider) == BookingTimeType.upcoming ?
                  asyncUpcomingItems.when(
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (e_obj, e_stacktracke){
                      lg.e("[BookingsTab asyncItems] error ~ " + e_obj.toString());
                      lg.e(e_stacktracke.toString());
                      return Center(child: Text('Error: Please try again later'));},
                      data: (items) {
                      if (items.isEmpty) {
                      return Container(height: Gss.height * .44,
                      child: Center(child: Text(nothingHereYetMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                      )));
                      }
                      if (items.isNotEmpty) {
                        lg.t("upcoming items len ~ " + items.length.toString());

                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                      controller: bookingUpcomingScrollController,
                      itemCount: items.length + 1,
                      itemBuilder: (_, i){

                        if (i == items.length){ /// add little space at bottom for bottom nav bar overlap
                          return SizedBox(height: Gss.height*.23,);
                        }

                        return BookingsListItem(
                            key: ValueKey(items[i].bookingId),
                            booking: items[i],
                        ownerType: widget.ownerType
                        );
                      }
                      );
                      }

                      /// ignore linter
                      lg.e("thing not able to build");
                      return Container();

                      }
                    ):
                Container(), /// never reach
                  )
            ),

            _moreBookingItemsLoading ?Container(
              height: Gss.height * .15,
              child: Center(child: CircularProgressIndicator()),
            ):Container(),

    Builder(builder:(context){
    lg.t("bookings tab end build ");
    return Container();})
          ]);
  }
}


class BookingsListItem extends ConsumerWidget {
  const BookingsListItem({super.key,
    required this.booking,
    required this.ownerType
  });

  final Booking booking;
  final UserType ownerType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // lg.t("pre check conv date time to local ~ " + booking.bookingTime.toString());
    // String checkConvDateTimeToLocal = DateFormat('MMMM d, y h:mm a').format(booking.bookingTime.toLocal());
    // lg.t("checkConvDateTimeToLocal ~ " + checkConvDateTimeToLocal);

    return
      Padding(
        padding: EdgeInsets.symmetric(vertical: Gss.width * .015),
        child:
      GestureDetector(
       behavior: HitTestBehavior.opaque,
        onTap: (){
          if (ownerType == UserType.client){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BookingDetail(booking: booking);
            }));
          }
          if (ownerType == UserType.vendor){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AppointmentDetail(booking: booking);
            }));
          }
        },
      child:Container(
        width: Gss.width *.8,
        decoration: BoxDecoration(
          color:
          ref.read(darkModeProv)?
          Theme.of(context).scaffoldBackgroundColor:
          Theme.of(context).appBarTheme.backgroundColor,
          boxShadow: [
            ref.watch(darkModeProv) ?
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ):BoxShadow(
              color: Colors.black.withValues(alpha:.3),
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child:
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.sr),
        child:Column(children:[
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Flexible(
             child:Text(booking.serviceName ,
           style:Theme.of(context).textTheme.titleLarge,
           )),
              BookingStatusIndicator(status: booking.status)
         ],),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 3.sr,
                horizontal: 12.sr
                ),
                child:
          Row(children: [
            ownerType == UserType.client ?
          Text("With " + booking.vendorBusinessName
              // ?? "Unknown"
            ,
            style:Theme.of(context).textTheme.bodyLarge,
          ):
            Text("For " + booking.clientUserName
                // ?? "Unknown",
            ,
              style:Theme.of(context).textTheme.bodyLarge,
            ),
          ],)),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 4.sr,
                    horizontal: 16.sr
                ),
                child:
          Row(children: [
            Text( DateFormat('MMMM d, y h:mm a').format(booking.bookingTime.toLocal())  ),
          ],)),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 4.sr,
                    horizontal: 16.sr
                ),
                child:
          Row(children: [
            Icon(Icons.access_time_rounded,
            size:18),
            SizedBox(width: Gss.width * .01),
            // booking.timeLength != null &&
                booking.timeLength != 0 ?
            Text( formatMinutesToHours(booking.timeLength)):
            Text( " Duration: No time limit")
            ,
          ]),),
          SizedBox(height: Gss.height * .03),
        ]
        )))));
  }
}






class BookingStatusIndicator extends StatelessWidget {
  const BookingStatusIndicator({super.key, required this.status,
  this.textStyle
  });

  final String status;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
     Color statusColor = Colors.grey;
    if (status == "pending"){
      statusColor = Colors.blue[700]!;
    }
     if (status == "confirmed"){
       statusColor = Colors.green[700]!;
     }
     if (status == "complete"){
       statusColor = Theme.of(context).colorScheme.primary;
     }
     if (status == "cancelled"){
       statusColor = Colors.blueGrey[900]!;
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
        child:Center(child:Text(status,
      style:textStyle?? TextStyle(color:Colors.white,
      )
      ))
    ));
  }
}
