import 'dart:async';
import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart' show RoundedOutlineButton;
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/providers/stripe.dart';
import 'package:connectme_app/requests/bookings/bookings.dart';
import 'package:connectme_app/requests/scheduling/base_availability.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/views/client_app/bookings/booking_request_page.dart';
import 'package:connectme_app/views/service/service_detail.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 'package:connectme_app/components/calendar_view_fork/
import 'package:connectme_app/components/calendar_view_fork/calendar_view.dart';
import 'package:intl/intl.dart';

import '../../../components/ui/buttons/action_button.dart';


class ClientBookingCalendarPage extends ConsumerStatefulWidget {
  const ClientBookingCalendarPage({super.key,
  required this.vendorUserId,
  });
  final String vendorUserId;

  @override
  ConsumerState<ClientBookingCalendarPage> createState() => _ClientBookingCalendarPageState();
}

class _ClientBookingCalendarPageState extends ConsumerState<ClientBookingCalendarPage> {


  bool loading = true;

  // Map<String,List<TimeOfDay>>? baseAvailabilityMockResponseFuture;
  // Map<String,List<TimeOfDay>> baseAvailabilityResponse = baseAvailabilityDefaultResponse;


  Map? TodImplAvailabilityResponse; /// supposed to be a Map<String,List<TimeOfDay>>?
  bool doubleBookingEnabled = false;



  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    // DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    // DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    scheduleMicrotask(() async {
      try {

        await updateCalendarEventsItems(context, ref, now, ref.read(userTypeProv)!);

        var gba_resp =
        await getBaseAvailability(widget.vendorUserId);
        // baseAvailabilityResponse = gba_resp[0];
        // doubleBookingEnabled = gba_resp[1];

        var fullTodImplAvailabilityResponse = gba_resp;
        doubleBookingEnabled = gba_resp["double_booking_enabled"]??false;
         fullTodImplAvailabilityResponse.remove("double_booking_enabled");
         // Map<String,List<TimeOfDay>> casted_gba_resp = Map<String,List<TimeOfDay>>.from(fullTodImplAvailabilityResponse);
        // TodImplAvailabilityResponse = casted_gba_resp;
         lg.t("baseAvailabilityResponse ~ " + fullTodImplAvailabilityResponse.toString());
        TodImplAvailabilityResponse = fullTodImplAvailabilityResponse;


      }catch(e){
        lg.e("error fetching calendar bookings");
        lg.e(e.toString());
        showErrorDialog(gNavigatorKey.currentContext!, default_error_message);
      }
      if (context.mounted) {
        setState(() {
          loading = false;
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {

    if (TodImplAvailabilityResponse == null && loading == false){
      return Scaffold(
        appBar: AppBar(title: Text("Availability"),),
        body: Center(child:Text("Something went wrong, please try again later")),
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Availability'),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body:loading?
        Center(child: CircularProgressIndicator()):
        ClientMonthViewWidget(
          TodImplAvailabilityResponse: TodImplAvailabilityResponse!,
          doubleBookingEnabled: doubleBookingEnabled,
        )
    );
  }
}

class ClientMonthViewWidget extends ConsumerStatefulWidget {
  ClientMonthViewWidget({
    super.key,
    required this.TodImplAvailabilityResponse,
    required this.doubleBookingEnabled,
    this.state,
    this.width,
  });

  final Map? TodImplAvailabilityResponse;
  final bool doubleBookingEnabled;
  final GlobalKey<MonthViewState>? state;
  final double? width;
  final dayViewKey = GlobalKey<DayViewState>();



  @override
  ConsumerState<ClientMonthViewWidget> createState() =>
      _ClientMonthViewWidgetState();

}

class _ClientMonthViewWidgetState extends ConsumerState<ClientMonthViewWidget> {

  DateTime currentMonth = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return MonthView(
      key: widget.state,
      width: widget.width,
      showWeekends: true,
      borderColor: appPrimarySwatch,
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: Theme.of(context).canvasColor),
        headerTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
      ),
      headerStringBuilder: (DateTime date, {secondaryDate}){
        return DateFormat.yMMMM().format(date);
      },
      startDay: WeekDays.sunday,
      useAvailableVerticalSpace: true,
      // headerStyle: HeaderStyle(
      //   decoration: BoxDecoration(
      //     // color:Theme.of(context).canvasColor
      //   ),
      //   headerTextStyle: TextStyle(
      //     color:Theme.of(context).colorScheme.onSurface
      //   )
      // ),
      onPageChange: (DateTime switchDate, int page){
        lg.t("onHeaderTitleTap called w switchDate ~ " + switchDate.toString());
        updateCalendarEventsItems(context, ref, switchDate, ref.read(userTypeProv)!);
        setState(() {
          currentMonth = switchDate;
        });
      },
      onCellTap: (events, date) {

        if (date.month != currentMonth.month) {
          lg.t("avoid loading day without data");
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BookingDayViewPage(date: date,
              baseAvailabilityResponse: widget.TodImplAvailabilityResponse!,
              doubleBookingEnabled: widget.doubleBookingEnabled,
            ),
            // builder: (_) => DayViewPageDemo(),
          ),
          // MaterialPageRoute(
          //   builder: (_) => TimeBlockCalendar(
          //     date: date,
          //     startTime:baseAvailabilityResponse[days_full[date.weekday ].toLowerCase()]![0],
          //     endTime: baseAvailabilityResponse[days_full[date.weekday ].toLowerCase()]![1],
          //     events: CalendarControllerProvider.of(context).controller.getEventsOnDay(date),
          //   ),
            // builder: (_) => DayViewPageDemo(),
          // ),
        );
      },
      // onEventTap: (event, date) {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) => BookingDayViewPage(date: date,
      //         baseAvailabilityResponse: baseAvailabilityResponse,
      //         doubleBookingEnabled: doubleBookingEnabled,
      //       ),
      //       // builder: (_) => DayViewPageDemo(),
      //     ),
      //   );
      // },
    );
  }
}





class BookingDayViewPage extends ConsumerStatefulWidget {
  const BookingDayViewPage({super.key,
    required this.date,
    required this.baseAvailabilityResponse,
    required this.doubleBookingEnabled
  });

  final DateTime date;
  final Map baseAvailabilityResponse;
  final bool doubleBookingEnabled;

  @override
  ConsumerState<BookingDayViewPage> createState() => _BookingDayViewPageState();
}

class _BookingDayViewPageState extends ConsumerState<BookingDayViewPage> {
  @override
  Widget build(BuildContext context) {

    List? baseRange = outsideTimeRanges(widget.date, widget.baseAvailabilityResponse); /// supposed to be List<List<TimeOfDay>>?

    String availabilityTitle = "Availability";
    if (baseRange == null){
      availabilityTitle = "Not Available";
    }

    // List<CalendarEventData<Object?>> eventsForDay = CalendarControllerProvider
    //     .of(context)
    //     .controller.getEventsOnDay(widget.date);

    return Scaffold(
      appBar: AppBar(title: Text(availabilityTitle),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body:
      baseRange != null ?
      DayView(
        showHalfHours: true,
        showQuarterHours: true,
        heightPerMinute: 3,
        timeLineOffset: -55,
        minuteSlotSize: MinuteSlotSize.minutes15,
        startHour: baseRange[0][1].hour,
        endHour: baseRange[1][0].hour,
        startMinute: baseRange[0][1].minute,
        endMinute: baseRange[1][0].minute,
        initialDay: widget.date,
        // dayTitleBuilder: (){},

        eventTileBuilder: customEventTileBuilderClient,
        // eventTileBuilder: customEventTileBuilderWithBaseAvailability(widget.baseAvailabilityResponse),
        backgroundColor: Theme.of(context).canvasColor,
        headerStyle: HeaderStyle(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          headerTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          leftIconConfig: IconDataConfig(color: Theme.of(context).textTheme.headlineSmall!.color!),
          rightIconConfig: IconDataConfig(color: Theme.of(context).textTheme.headlineSmall!.color!),
        ),
        dateStringBuilder: (DateTime date, {secondaryDate}){
          return med_length_full_date_formatter(date);
        },
        onEventTap: (events, date) {

        },
        onDateTap: (DateTime date){


            List<CalendarEventData> eventsForDay =
            CalendarControllerProvider
                .of(context)
                .controller
                .getEventsOnDay(date);

            List<TimeRange> eventsTimeRanges = [];
            for (var event in eventsForDay) {
              eventsTimeRanges.add(TimeRange(start:
              TimeOfDay(hour: event.startTime!.hour,
                  minute: event.startTime!.minute),
                end: TimeOfDay(hour: event.endTime!.hour,
                    minute: event.endTime!.minute),));
            }

            int serviceTotalMinutes = ref.watch(bookNowServiceProv)!
                .timeLength!;
            final serviceHours = serviceTotalMinutes ~/ 60;
            final serviceMinutes = serviceTotalMinutes % 60;

            TimeOfDay endRange = TimeOfDay(hour: date.hour + serviceHours,
            minute: date.minute + serviceMinutes);

            TimeRange rangeToCheck = TimeRange(start: TimeOfDay(hour: date.hour,
                minute: date.minute),
                end: endRange);

            TimeOfDay dayEnd = TimeOfDay(hour: baseRange[1][0].hour, minute: baseRange[1][0].minute);

            lg.t("dayEnd ~ " + dayEnd.toString());
            lg.t("endRange ~ " + endRange.toString());

            if (endRange.isAfter(dayEnd)){
                showOverlapsDialog(context, serviceTotalMinutes, "end_range");
                return;
              }

            if (widget.doubleBookingEnabled == false) {
              if (overlapsWithAny(eventsTimeRanges, rangeToCheck)) {
                showOverlapsDialog(context, serviceTotalMinutes, "overlaps");
                return;
              }
          }

          /// Booking is allowed

          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[Text("Book Now",
                    style: Theme.of(context).textTheme.titleMedium,
                  )]),
              content:

              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[

                    SizedBox(height: Gss.height * .015),
                    Text(ref.read(bookNowServiceProv)!.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    SizedBox(height: Gss.height * .03),
                    Text(ref.read(bookNowServiceProv)!.vendorBusinessName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: appPrimarySwatch[700]),
                  ),
                    SizedBox(height: Gss.height * .03),
                  // DashedLine(color: Theme.of(context).textTheme.bodyLarge!.color!,),
                  SizedBox(height: Gss.height * .03),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                        // Icon(Icons.access_time_rounded,
                        //   size: 17.sr,
                        // ),
                        SizedBox(width: Gss.width * .01),
                        ref.watch(bookNowServiceProv)!.timeLength != 0
                            // && ref.watch(bookNowServiceProv)! != null
                        ?
                        Text(formatMinutesToHours(ref.watch(bookNowServiceProv)!.timeLength!),
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w300,
                            )):
                        Text("No time limit",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w300,
                            )),

                        Text(formatCents(ref.read(bookNowServiceProv)!.priceCents),
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                              color: appPrimarySwatch[600],
                            )),

                      ]),
                    SizedBox(height: Gss.height * .03),
                    ref.watch(bookNowServiceProv)!.address != null?
                    Text(ref.watch(bookNowServiceProv)!.address!,
                      style: Theme.of(context).textTheme.bodyLarge
                    ):Container(),

                    SizedBox(height: Gss.height * .02),
                  Text("Time: " + DateFormat('MMMM d, y h:mm a').format(date),
                      style: Theme.of(context).textTheme.bodyLarge
                  ),


                  SizedBox(height: Gss.height * .02),

                ]),
              ),
              actions: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: Gss.width * .03),
                          child:TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          },
                            child:Text( "Cancel",
                            style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                            ))
                            // width: Gss.width * .45,
                            // paddingVertical: Gss.height * .01,
                          )),
                    // ]
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children:[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: Gss.width * .03),
                          child:
                          TextButton(onPressed: ()async {

                            if (ref.read(stripeCustomerIdProv) == null){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                        child: ListView(shrinkWrap: true, children: [
                                          AlertDialog(
                                            title: Text("Please complete payment information the your Profile tab before booking"),
                                            actions: [
                                              ActionButton(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  label: "Ok" ),
                                            ],
                                          )
                                        ]));
                                  });
                              return;
                            }

                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return BookingRequestPage(bookingDate: date);
                            }));

                          },
                          child: Text( "Book",
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: appPrimarySwatch[600],
                              )
                          ))
                      )])
              ],
            );
          });


        },
      ):
      Center(child: Text("Not Available ${humanReadableDateTime(widget.date, format: "long")}",
        style: Theme.of(context).textTheme.headlineSmall,
      )),
    );
  }
}


showOverlapsDialog(BuildContext context, int serviceTotalMinutes, String endRangeVsOverlap ){

  String alert_message ="Please choose a time slot that does not overlap with existing bookings.";
  if (endRangeVsOverlap == "end_range"){
    alert_message ="Please choose a time slot that does not go past the end of the day.";
  }
  if (endRangeVsOverlap == "overlaps"){
     alert_message ="Please choose a time slot that does not overlap with existing bookings.";
  }

  showDialog(context: context, builder: (context) {
    return AlertDialog(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Not Available",
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
            )
            ]),
        content:

        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
        Text(
              alert_message,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
            ),
            SizedBox(height: Gss.height * .02),
            Text(
              "Service requires a window of ${formatMinutesToHours(serviceTotalMinutes)}",
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
            ),
          ],
        )),
        actions: [
          RoundedOutlineButton(
              onTap: () {
                Navigator.pop(context);
              },
              label: "Ok"),
        ]);
  });
}




 Widget customEventTileBuilderClient(
    DateTime date,
    List<CalendarEventData<Object?>> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration
    ) {

  // lg.t("All events ~ " + events.toString());

  return
    Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: events.map((e) {
            return Text(
                DateFormat.jm().format(startDuration) + " - " +
                    DateFormat.jm().format(endDuration)
              ,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ),
      ),
    );
}

