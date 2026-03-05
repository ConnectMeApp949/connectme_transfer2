

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/logger.dart';

///| Direction     | Code                                       |
///| ------------- | ------------------------------------------ |
///| Dart → Python | `DateTime.now().toUtc().toIso8601String()` |
///| Python → Dart | `datetime.now(timezone.utc).isoformat()`   |
///| Dart parse    | `DateTime.parse(isoString).toUtc()`        |
///| Python parse  | `datetime.fromisoformat(iso.rstrip('Z'))`  |


class TimeRange {
  TimeOfDay start;
  TimeOfDay end;
  TimeRange({required this.start, required this.end});
  @override
  toString() => "start: ${start.toString()}, end: ${end.toString()}";
}

int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

bool timeRangesOverlap(TimeRange a, TimeRange b) {
  final aStart = toMinutes(a.start);
  final aEnd = toMinutes(a.end);
  final bStart = toMinutes(b.start);
  final bEnd = toMinutes(b.end);

  return aStart < bEnd && aEnd > bStart;
}

bool overlapsWithAny(List<TimeRange> existing, TimeRange newRange) {
  for (final range in existing) {
    if (timeRangesOverlap(range, newRange)) {
      return true;
    }
  }
  return false;
}

bool timeOfDayIsBefore(TimeOfDay a, TimeOfDay b) {
  if (a.hour < b.hour) return true;
  if (a.hour == b.hour && a.minute < b.minute) return true;
  return false;
}

humanReadableDateTime(DateTime dt, {String? format}) {

  format?? "long";

  if (format == "short us") {
    return dt.month.toString() + " " + dt.day.toString() + ", " + dt.year.toString();
  }
  if (format == "long") {
    return months_full[dt.month - 1] + " " + dt.day.toString() + ", " + dt.year.toString();
  }
  return "";
}

List months_full = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

List months_short = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

/// this was a small mistake Dart is monday 1 - 7 based so be careful.. can get away with
/// widget.date.weekday % 7
List days_full = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
];


List days_short = [
  "Sun",
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
];



String formatMinutesToHours(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  if (hours > 1 && minutes > 0) {
    return '$hours hours $minutes minutes';
  }
  else if (hours == 1 && minutes > 0) {
    return '$hours hour $minutes minutes';
  }
  else if (hours == 1 && minutes == 0){
    return '1 hour';
  }
  else if (hours > 1) {
    return '$hours hours';
  }
  else {
    return '$minutes minutes';
  }
}


DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}


/// used from calendar_page for vendor if request errs
// Map baseAvailabilityDefaultResponse ={
//   "sunday":[TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 20, minute: 00)],
//   "monday":[TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 20, minute: 00)],
//   "tuesday":[TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 20, minute: 00)],
//   "wednesday":[TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 20, minute: 00)],
//   "thursday":[TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 20, minute: 00)],
//   "friday":[TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 20, minute: 00)],
//   "saturday":[TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 20, minute: 00)],
//   "double_booking_enabled": false
// };

Map baseAvailabilityDefaultResponse ={
  "sunday":[{"hour": 0, "minute": 0}, {"hour": 23, "minute": 30}],
  "monday":[{"hour": 0, "minute": 0}, {"hour": 23, "minute": 30}],
  "tuesday":[{"hour": 0, "minute": 0}, {"hour": 23, "minute": 30}],
  "wednesday":[{"hour": 0, "minute": 0}, {"hour": 23, "minute": 30}],
  "thursday":[{"hour": 0, "minute": 0}, {"hour": 23, "minute": 30}],
  "friday":[{"hour": 0, "minute": 0}, {"hour": 23, "minute": 30}],
  "saturday":[{"hour": 0, "minute": 0}, {"hour": 23, "minute": 30}],
  "double_booking_enabled": false
};

TimeRange defaultAvailabilityTimeRange = TimeRange(start: TimeOfDay(hour: 0,minute: 0),
end: TimeOfDay(hour: 11,minute: 30));

/// converts to Impl (Time of day)
jsonToBaseAvailabilityTodImpl(Map<String, dynamic> json) {
  lg.t("[jsonToBaseAvailability] called");
  final result = <String, dynamic>{};

  // json.forEach((day, times) {
  for (String dayUpper in days_full) {
    String lDay = dayUpper.toLowerCase();

    if (json.containsKey(lDay)) {
     var times = json[lDay];
      if (times is List && times.length == 2) {
        final start = times[0];
        final end = times[1];

        result[lDay] = [
          TimeOfDay(hour: start['hour'], minute: start['minute']),
          TimeOfDay(hour: end['hour'], minute: end['minute']),
        ];
      }
    }
    else{
      lg.w("[jsonToBaseAvailability] no day in json base avail loop");
      result[lDay] = [];
    }
  }

  if (json.containsKey("double_booking_enabled")){
    result["double_booking_enabled"] = json["double_booking_enabled"];
  }

  lg.t("[jsonToBaseAvailability] result ~ " + result.toString());

  return result;
}

/// converts {sunday: [TimeOfDay(00:00), TimeOfDay(20:00)], monday: [TimeOfDay(00:00), TimeOfDay(20:00)], tuesday: [TimeOfDay(00:00), TimeOfDay(20:00)], wednesday: [TimeOfDay(00:00), TimeOfDay(20:00)], thursday: [TimeOfDay(00:00), TimeOfDay(20:00)], friday: [TimeOfDay(00:00), TimeOfDay(20:00)], saturday: [TimeOfDay(00:00), TimeOfDay(20:00)]}
/// into { friday: [{hour: 0, minute: 0}, {hour: 23, minute: 59}], monday: [{hour: 0, minute: 0}, {hour: 20, minute: 30}], saturday: [{hour: 0, minute: 0}, {hour: 23, minute: 59}], sunday: [{hour: 0, minute: 0}, {hour: 23, minute: 59}], thursday: [{hour: 0, minute: 0}, {hour: 23, minute: 59}], tuesday: [{hour: 0, minute: 0}, {hour: 20, minute: 30}], wednesday: [{hour: 0, minute: 0}, {hour: 4, minute: 45}]}

/// called on save from time picker and save on day enabled/disabled
Map todImplToBaseAvailabilityWithDayEnabledMod(Map baseAvailabilityObject, Map<String,bool> dayEnabled){
  lg.t("[todImplToBaseAvailabilityWithDayEnabledMod] called with baseAvailabilityObject ~ " + baseAvailabilityObject.toString());
  lg.t("[todImplToBaseAvailabilityWithDayEnabledMod] called with dayEnabled ~ " + dayEnabled.toString());
  var baseAvailabilityResponseToSave = {};
  for (String key in baseAvailabilityDefaultResponse.keys){
    lg.t("looping key ~ " + key.toString());
    String lkey = key.toLowerCase();
    if (lkey == "double_booking_enabled"){continue;}
    if (dayEnabled[lkey]!) {
      lg.t("key day enabled ~ ");
      List<Map> times = [];
      if (baseAvailabilityObject.containsKey(lkey) && baseAvailabilityObject[lkey].isNotEmpty) {
        /// should have beginning and end or be empty list for now
        times.add({
          "hour": baseAvailabilityObject[lkey]![0]["hour"],
          "minute": baseAvailabilityObject[lkey]![0]["minute"]
        });
        times.add({
          "hour": baseAvailabilityObject[lkey]![1]["hour"],
          "minute": baseAvailabilityObject[lkey]![1]["minute"]
        });
        baseAvailabilityResponseToSave[lkey] = List.from(times);
      }
      else{ /// reset to default times if not enabled (empty list) could upgrade with localstorage //TODO check localstorage here
          lg.t("Something empty ~ setting to empty");
          baseAvailabilityResponseToSave[lkey] =
              List.from([{"hour": 8, "minute": 0}, {"hour": 20, "minute": 0}]);
          // baseAvailabilityResponseToSave[lkey] = List.from([]);
          continue;
      }
    }
    else{ /// day is disabled
      lg.t("key day not enabled ~ ");
      baseAvailabilityResponseToSave[lkey] = [
        // {"hour": 0, "minute": 0},
        // {"hour": 20, "minute": 0}
      ];
    }
  }
  baseAvailabilityResponseToSave["double_booking_enabled"] = baseAvailabilityObject["double_booking_enabled"]??false;
  lg.t("[todImplToBaseAvailabilityWithDayEnabledMod] returning ~ baseAvailabilityObject ~ " + baseAvailabilityObject.toString());
  return baseAvailabilityResponseToSave;
}

/// called on save full avail object ( when leaving page currently )
Map todImplToBaseAvailabilityAll(Map baseAvailabilityObject){
  lg.t("[todImplToBaseAvailabilityAll] called with baseAvailabilityObject ~ " + baseAvailabilityObject.toString());
  var baseAvailabilityResponseToSave = {};
  for (var key in baseAvailabilityDefaultResponse.keys) {
    String lkey = key.toLowerCase();
    if (lkey != "double_booking_enabled") {
      List<Map> times = [];
      if (baseAvailabilityObject.containsKey(lkey) && baseAvailabilityObject[lkey].isNotEmpty) {  /// should have beginning and end or be empty list for now
          times.add({
            "hour": baseAvailabilityObject[lkey]![0]["hour"],
            "minute": baseAvailabilityObject[lkey]![0]["minute"]
          });
          times.add({
            "hour": baseAvailabilityObject[lkey]![1]["hour"],
            "minute": baseAvailabilityObject[lkey]![1]["minute"]
          });
          baseAvailabilityResponseToSave[lkey] = List.from(times);
        }
      else {
        /// look for disabled day empty list
        baseAvailabilityResponseToSave[lkey] = List.from([]);
        continue;
      }
    }
  }
  baseAvailabilityResponseToSave["double_booking_enabled"] = baseAvailabilityObject["double_booking_enabled"] ?? false;

  lg.t("[todImplToBaseAvailabilityAll] returning ~ " + baseAvailabilityResponseToSave.toString());
  return baseAvailabilityResponseToSave;

}


/// Returns the availability (list of TimeOfDay) for the given [date].
List getAvailabilityForDate(DateTime date, Map baseAvailabilityResponse) { /// List<TimeOfDay>
  // Convert weekday (Monday=1 … Sunday=7) to 0-based (Sunday=0)
  int dayIndex = date.weekday % 7;
  // Get day name and lower case
  String dayKey = days_full[dayIndex].toLowerCase();
  return baseAvailabilityResponse[dayKey]!;
}

/// use 0 0 to indicate not available for now

List? outsideTimeRanges(DateTime date, Map baseAvailabilityResponse) { ///

   List baseRange = getAvailabilityForDate(date, baseAvailabilityResponse); /// supposed to be List<TimeOfDay>
lg.t("baseRange ~ " + baseRange.toString());

   if (baseRange.isEmpty){ /// day disabled
     return null;
   }

  TimeOfDay midnight = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endOfDay = TimeOfDay(hour: 23, minute: 59);

  List<TimeOfDay> range1 = [midnight, TimeOfDay(hour: baseRange[0]["hour"], minute: baseRange[0]["minute"]) ];
  List<TimeOfDay> range2 = [TimeOfDay(hour: baseRange[1]["hour"], minute: baseRange[1]["minute"]), endOfDay];

  return [range1, range2];
}

/// Jan 1, 2025
med_length_full_date_formatter(DateTime date) =>
DateFormat('MMM d, y').format(date);


// Takes a time of day and makes nice format
// 8:00 AM
String formatTimeHH_MM_AM(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat.jm().format(dt); // e.g. "9:00 AM"
}


/// 9:00 AM
// String formatTime(TimeOfDay time) {
//   final now = DateTime.now();
//   final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//   return DateFormat.jm().format(dt); // e.g. "9:00 AM"
// }