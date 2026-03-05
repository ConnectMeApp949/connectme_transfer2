import 'dart:async';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/availability.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/requests/bookings/bookings.dart';
import 'package:connectme_app/requests/scheduling/base_availability.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/views/vendor_app/appointments/appointment_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectme_app/components/calendar_view_fork/calendar_view.dart';
import 'package:intl/intl.dart';

import '../../../config/logger.dart';




class VendorCalendarPage extends ConsumerStatefulWidget {
  const VendorCalendarPage({super.key});

  @override
  ConsumerState<VendorCalendarPage> createState() => _VendorCalendarPageState();
}

class _VendorCalendarPageState extends ConsumerState<VendorCalendarPage> {

  String chosenCalendarGranularity = "week";


  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    updateCalendarEventsItems(context, ref, now, ref.read(userTypeProv)!);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Text('Calendar'),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.crisis_alert),
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //       return BaseAvailabilityPage();
              //     }));
              //   },
              // ),
            ],
        ),
        body:
        // ListView(children: [
        //   chosenCalendarGranularity == "month" ?
            VendorMonthViewWidget()
            // :WeekViewWidget(),

                    );
                    }
  }

class VendorMonthViewWidget extends ConsumerStatefulWidget {

  const VendorMonthViewWidget({
    super.key,
    this.state,
    this.width,
  });

  final GlobalKey<MonthViewState>? state;
  final double? width;

  @override
  createState() => _VendorMonthViewWidgetState();
}

class _VendorMonthViewWidgetState extends ConsumerState<VendorMonthViewWidget> {

  final dayViewKey = GlobalKey<DayViewState>();

  bool loading = true;

  DateTime currentMonth = DateTime.now();


  @override
  initState() {
    super.initState();
    scheduleMicrotask(() async {
      var gba_resp =
      await getBaseAvailability(ref.read(userAuthProv)!.userId);
      // I/flutter (12951): 🔦️  got gba_resp ~ [{sunday: [TimeOfDay(00:00), TimeOfDay(20:00)], monday: [TimeOfDay(00:00), TimeOfDay(20:00)], tuesday: [TimeOfDay(00:00), TimeOfDay(20:00)], wednesday: [TimeOfDay(00:00), TimeOfDay(20:00)], thursday: [TimeOfDay(00:00), TimeOfDay(20:00)], friday: [TimeOfDay(00:00), TimeOfDay(20:00)], saturday: [TimeOfDay(00:00), TimeOfDay(20:00)]}, false]
      lg.t("[VendorMonthViewWidget initState] got gba_resp ~ " + gba_resp.toString());
      ref.read(baseAvailabilityResponseProv.notifier).state = Map.from(gba_resp);
      // ref.read(doubleBookingEnabledProv.notifier).state = gba_resp[1];

      setState(() {loading = false;});
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading){
      return Center(child: CircularProgressIndicator());
    }

    return MonthView(
      key: widget.state,
      width: widget.width,
      borderColor: appPrimarySwatch,
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: Theme.of(context).canvasColor),
        headerTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),
        leftIconConfig: IconDataConfig(color: Theme.of(context).textTheme.headlineSmall!.color!),
        rightIconConfig: IconDataConfig(color: Theme.of(context).textTheme.headlineSmall!.color!),
      ),
      headerStringBuilder: (DateTime date, {secondaryDate}){
        return DateFormat.yMMMM().format(date);
      },
      showWeekends: true,
      initialMonth: currentMonth,
      startDay: WeekDays.sunday,
      useAvailableVerticalSpace: true,
      onPageChange: (DateTime switchDate, int page){
        lg.t("onHeaderTitleTap called w switchDate ~ " + switchDate.toString());
        updateCalendarEventsItems(context, ref, switchDate, ref.read(userTypeProv)!);
        setState(() {
          currentMonth = switchDate;
        });
      },
      onCellTap: (events, date) {

        // final calendarController = CalendarControllerProvider.of(context).controller;

        if (date.month != currentMonth.month) {
          lg.t("avoid loading day without data");
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DayViewPage(date: date),
            // builder: (_) => DayViewPageDemo(),
          ),
        );
      },
      onEventTap: (event, date) {

        if (date.month != currentMonth.month) {
          lg.t("avoid loading day without data");
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DayViewPage(date: date),
            // builder: (_) => DayViewPageDemo(),
          ),
        );
      },
      // onEventLongTap: (event, date) {
      //   SnackBar snackBar = SnackBar(content: Text("on LongTap"));
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // },
    );
  }
}

class DayViewPage extends ConsumerStatefulWidget {
  const DayViewPage({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<DayViewPage> createState() => _DayViewPageState();
}

class _DayViewPageState extends ConsumerState<DayViewPage> {


  bool loading = true;
  TimeRange? dayAvailability;


  @override
  initState() {
    super.initState();
    scheduleMicrotask(() async {

      /// switch 1 based monday to 0 based sunday
      String day = days_full[widget.date.weekday % 7];
      dayAvailability = defaultAvailabilityTimeRange; /// init to default
      lg.t("loop days");
      try {
        if (ref.read(baseAvailabilityResponseProv).containsKey(
            day.toLowerCase())) {
          lg.d(
              "[DayViewPage] found key in baseAvailabilityResponse use dangerous null check");

          /// avoid double booking entry
          if (ref.read(baseAvailabilityResponseProv)[
          day.toLowerCase()] is List &&
              ref.read(baseAvailabilityResponseProv)[
              day.toLowerCase()].isNotEmpty
          ) {
            dayAvailability = TimeRange(
              start:
              TimeOfDay(hour:
              ref.read(baseAvailabilityResponseProv)[day
                  .toLowerCase()]![0]["hour"],
                  minute: ref.read(baseAvailabilityResponseProv)[day
                      .toLowerCase()]![0]["minute"]),
              end: TimeOfDay(hour:
              ref.read(baseAvailabilityResponseProv)[day
                  .toLowerCase()]![1]["hour"],
                  minute: ref.read(baseAvailabilityResponseProv)[day
                      .toLowerCase()]![1]["minute"]),
            );
          }
          else if (ref.read(baseAvailabilityResponseProv)[
          day.toLowerCase()].isEmpty){
            dayAvailability = null; /// shows not available
          }
          else {
            dayAvailability = defaultAvailabilityTimeRange;
            lg.t("[DayViewPage] thing is not list");
          }
          lg.t("build with dayAvailability ~ " + dayAvailability.toString());
          loading = false;
          setState(() {});
          return;
        } else {
          lg.t("didnt find key in baseAvailabilityResponse");
        }

        loading = false;
        setState(() {});
      }catch(e){
        lg.e("Exp caught building vendor app calendar initstate");
      }

    });
  }


  @override
  Widget build(BuildContext context) {

    lg.d( "Calendar events for day ~ " +
        CalendarControllerProvider.of(context).controller.getEventsOnDay(widget.date).toString()
    );



    return Scaffold(
      appBar: AppBar(title: const Text('Availability')),
      body:
      loading? Center(child: CircularProgressIndicator()):
      (dayAvailability == null) ?
      Center(child: Text("Not Available",
        style: Theme.of(context).textTheme.headlineSmall,
      ))
          :
      DayView(

        showHalfHours: true,
        showQuarterHours: true,
        heightPerMinute: 3,
        timeLineOffset: -55,
        minuteSlotSize: MinuteSlotSize.minutes15,
        initialDay: widget.date,
        startHour:  dayAvailability!.start.hour,
        endHour: dayAvailability!.end.hour,
        startMinute: dayAvailability!.start.minute,
        endMinute: dayAvailability!.end.minute,
        eventTileBuilder: customEventTileBuilderVendor,
        backgroundColor: Theme.of(context).canvasColor,

        headerStyle: HeaderStyle(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          headerTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),
          leftIconConfig: IconDataConfig(color: Theme.of(context).textTheme.headlineSmall!.color!),
          rightIconConfig: IconDataConfig(color: Theme.of(context).textTheme.headlineSmall!.color!),
        ),
        dateStringBuilder: (DateTime date, {secondaryDate}){
          return med_length_full_date_formatter(date);
        },
        onEventTap: (events, date) {
          lg.t("onEventTap");
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (_) => VendorEventViewPage(events: events),
          //     // builder: (_) => DayViewPageDemo(),
          //   ),
          // );
          if (events[0].booking != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AppointmentDetail(booking: events[0].booking!),
                // builder: (_) => DayViewPageDemo(),
              ),
            );
          }else{
            lg.e("booking null for calendar event error");
          }

        },
      ),
    );
  }
}


Widget customEventTileBuilderVendor(
    DateTime date,
    List<CalendarEventData<Object?>> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
    ) {
  return
    /// seems to work without this
    // Positioned(
    // top: boundary.top,
    // left: boundary.left,
    // right: boundary.right,
    // height: boundary.height,
    // child:
    Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: appPrimarySwatch,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: events.map((e) {
            return Text(
              e.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ),
      ),
    );
}






