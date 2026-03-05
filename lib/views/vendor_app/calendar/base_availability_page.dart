import 'dart:async';
import 'dart:convert';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/availability.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/scheduling/base_availability.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;



// getBaseAvailability(String userId, String authToken, String serviceId)async {
//   var response = await http.post(Uri.parse(get_base_availability_url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'userId': userId,
//         'authToken': authToken,
//       }));
//
//   if (response.statusCode != 200) {
//     // throw Exception('Failed to load');
//     return {"success":false};
//   }
//   return jsonDecode(response.body)["availability"];
// }


/// [availability, dayEnabled, doubleBookingEnabled]
// final saveAvailabilityArgsProv = StateProvider<List>((ref) {
//   return [];
// });

saveAvailabilityCB(WidgetRef ref) async {
  lg.t("[saveAvailabilityCB] called");
  /// Cannot type tighter... error ~ type '_Map<dynamic, dynamic>' is not a subtype of type 'Map<String, dynamic>'
  // var updateBA = updateBaseAvailabilityObject(availability, dayEnabled);

  // var updateBA = updateBaseAvailabilityObject(sa_ap[0], sa_ap[1]);
  // ref.read(baseAvailabilityResponseProv.notifier).state = updateBA; /// moved into save
  // await saveBaseAvailability(ref.read(userAuthProv)!.userId,
  // ref.read(userAuthProv)!.userToken, availability, dayEnabled, doubleBookingEnabled);

  // //var sa_ap = ref.read(saveAvailabilityArgsProv).toList();

  // //lg.t("show saap~ " + sa_ap.toString());
  // //Map<String,TimeRange> build_new_availability_object = sa_ap[0] as Map<String,TimeRange>;

  // // // build_new_availability_object["double_booking_enabled"] = sa_ap[2];
  // // // ref.read(baseAvailabilityResponseProv.notifier).state =

  //lg.t("saveBaseAvailability called with baseAvailabilityResponse ~ " + build_new_availability_object.toString());
  // var baseAvailabilityResponseToSave = updateBaseAvailabilityObject(build_new_availability_object, sa_ap[1], sa_ap[2]);
  //lg.t("saveBaseAvailability baseAvailabilityResponseToSave ~ " + baseAvailabilityResponseToSave.toString());

  var baseAvailabilityResponseToSave = todImplToBaseAvailabilityAll(ref.read(baseAvailabilityResponseProv));
  lg.t("saving ~ " + baseAvailabilityResponseToSave.toString());

  var pdata = {
    "userId": ref.read(userAuthProv)!.userId,
    "authToken": ref.read(userAuthProv)!.userToken,
    "baseAvailability": baseAvailabilityResponseToSave
  };

  var resp = await http.post(Uri.parse(set_base_availability_url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pdata));

  return resp;


  // await saveBaseAvailability(ref.read(userAuthProv)!.userId,
  //     ref.read(userAuthProv)!.userToken, sa_ap[0], sa_ap[1], sa_ap[2]);
}


class BaseAvailabilityPage extends ConsumerStatefulWidget {
  const BaseAvailabilityPage({super.key});

  @override
  ConsumerState<BaseAvailabilityPage> createState() => _BaseAvailabilityPageState();
}

class _BaseAvailabilityPageState extends ConsumerState<BaseAvailabilityPage> {



  @override
  Widget build(BuildContext context) {
    return
      SafeArea(child:Scaffold(
        appBar: AppBar(
          leading:BackButton(
            onPressed: () async {
          // Log the back button press here
          lg.d('Back button pressed from AppBar!');
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            try {
              await saveAvailabilityCB(ref);
            }catch(e){
              lg.e("Exp caught saving availability ~ " + e.toString());
              //TODO need to show dialog if err
            }

          Navigator.pop(gNavigatorKey.currentContext!); /// pop dialog
          Navigator.pop(gNavigatorKey.currentContext!); /// go back
        },
          ),
          title: const Text('Base Availability'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_merge_outlined),
            onPressed: () {
              showLinkCalendarDialog(context);
            },
          ),
        ],
        ),
    body: WeeklyAvailabilitySelector(),
    ));
  }
}



// saveBaseAvailability(userID, userToken, Map<String,TimeRange> baseAvailabilityObject, Map<String,bool> dayEnabled, bool doubleBookingEnabled) async {
//
//   lg.t("saveBaseAvailability called with baseAvailabilityResponse ~ " + baseAvailabilityObject.toString());
//   var baseAvailabilityResponseToSave = updateBaseAvailabilityObject(baseAvailabilityObject, dayEnabled, doubleBookingEnabled);
//   lg.t("saveBaseAvailability baseAvailabilityResponseToSave ~ " + baseAvailabilityResponseToSave.toString());
//
//   var pdata = {
//     "userId": userID,
//     "authToken": userToken,
//     "baseAvailability": baseAvailabilityResponseToSave
//   };
//
//   var resp = await http.post(Uri.parse(set_base_availability_url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(pdata));
//
//   return resp;
//
// }





class WeeklyAvailabilitySelector extends ConsumerStatefulWidget {
  const WeeklyAvailabilitySelector({super.key});

  @override
  ConsumerState<WeeklyAvailabilitySelector> createState() =>
      _WeeklyAvailabilitySelectorState();
}

class _WeeklyAvailabilitySelectorState
    extends ConsumerState<WeeklyAvailabilitySelector> {

  // bool doubleBookingEnabled = false;
  Map<String, bool> dayEnabled = {};
  final Map<String, TimeRange> availabilityTroImpl = {};

  bool loading = true;



  @override
  void initState() {
    super.initState();

    lg.t("WeeklyAvailabilitySelector initState");
    scheduleMicrotask(() async {

    await loadBaseAvailabilityToTroImpl();

      lg.t("init with base prov complete ~ " );
      // if (ref.read(baseAvailabilityResponseProv).containsKey("double_booking_enabled")){
      //   lg.t("found double booking in init ~ " );
      //   // doubleBookingEnabled = ref.read(baseAvailabilityResponseProv)["double_booking_enabled"];
      //   // lg.t("found double booking in init ~ " + doubleBookingEnabled.toString() );
      // }

      //   lg.t("loop complete");
      loading = false;
    setState(() {});
    });
  }

  loadBaseAvailabilityToTroImpl() async{
    lg.t("[loadBaseAvailabilityToTroImpl] called with base prov ~ " );
    lg.t(ref.read(baseAvailabilityResponseProv).toString());

    /// init if they come in here before anywhere else and this is empty
    if (ref.read(baseAvailabilityResponseProv).isEmpty){
      lg.t("baseAvailabilityResponseProv empty init with getBaseAvailability");
      var gba_resp =
          await getBaseAvailability(ref.read(userAuthProv)!.userId);
      lg.t("got gba_resp ~ " + gba_resp.toString());
      ref.read(baseAvailabilityResponseProv.notifier).state = Map.from(gba_resp);
    }

    for (String Uday in days_full) {
      String lDay = Uday.toLowerCase();
      // lg.t("[WeeklyAvailabilitySelector] initstate check Lday ~ " + lDay.toString());
      if (ref.read(baseAvailabilityResponseProv).containsKey(lDay)){
        if (ref.read(baseAvailabilityResponseProv)[lDay].isNotEmpty) {
          dayEnabled[lDay] = true;
          availabilityTroImpl[lDay] = TimeRange(
            start: TimeOfDay(hour: ref.read(
                baseAvailabilityResponseProv)[lDay]![0]["hour"],
                minute: ref.read(
                    baseAvailabilityResponseProv)[lDay]![0]["minute"]
            ),
            end: TimeOfDay(hour: ref.read(
                baseAvailabilityResponseProv)[lDay]![1]["hour"],
                minute: ref.read(
                    baseAvailabilityResponseProv)[lDay]![1]["minute"]
            ),
          );
        }else{
          dayEnabled[lDay] = false;
          availabilityTroImpl[lDay] = TimeRange(
            start: const TimeOfDay(hour: 0, minute: 0),
            end: const TimeOfDay(hour: 20, minute: 30),
          );
          /// might save their last entry not sure
        }

      }else {
        lg.t("didnt find key in baseAvailabilityResponse");
        dayEnabled[lDay] = false;
        availabilityTroImpl[lDay] = TimeRange(
          start: const TimeOfDay(hour: 0, minute: 0),
          end: const TimeOfDay(hour: 20, minute: 30),
        );
      }
    }
  }




  Future<void> pickTime(
      BuildContext context,
      String day, /// made lower case
      bool isStart,
      availabilityTroImpl
      ) async {

    final current = isStart
        ? availabilityTroImpl[day]!.start
        : availabilityTroImpl[day]!.end;

    // final picked = await showTimePicker(
    //   context: context,
    //   initialTime: current,
    // );

    var picked = TimeOfDay(hour: current.hour, minute: current.minute);

    showCustomTimePicker(context, TimeOfDay.now(), (ret_picked) {
      lg.t("showCustomTimePicker callback called ret_picked " + ret_picked.toString());
      lg.t("full ref.read(baseAvailabilityResponseProv) ~ " + ref.read(baseAvailabilityResponseProv).toString());
          picked = ret_picked;
            List? availabilityProperFormatItem;

            if (isStart) {
              lg.t("got is start");
              // var availabilityProperFormatItem = [{"hour":0, "minute":0}, {"hour":20, "minute":0},]; /// cant put outside becuase one or other initializes
                if (timeOfDayIsBefore(picked, availabilityTroImpl[day]!.end)) {
                  availabilityTroImpl[day]!.start = picked;

                  Map availabilityOtherItem = {"hour": 20, "minute": 30}; /// init to the default
                  if (ref.read(baseAvailabilityResponseProv)[day].isNotEmpty) {
                    lg.t("start found day in base avail set otheritem");
                    availabilityOtherItem = ref.read(
                        baseAvailabilityResponseProv)[day][1];
                  }
                  availabilityProperFormatItem = [{"hour": picked.hour, "minute": picked.minute}, availabilityOtherItem];
                }
                else{
                  showErrorDialog(context, "Start time must be before end time");
                }
              } else {
              lg.t("not is start");
              // var availabilityProperFormatItem = [{"hour":0, "minute":0}, {"hour":20, "minute":0},]; /// cant put outside becuase one or other initializes
                if (timeOfDayIsBefore(availabilityTroImpl[day]!.start, picked)) {
                  availabilityTroImpl[day]!.end = picked;

                  Map availabilityOtherItem = {"hour": 20, "minute": 30}; /// init to the default
                  if (ref.read(baseAvailabilityResponseProv)[day].isNotEmpty) {
                    lg.t("not start found day in base avail set otheritem");
                    availabilityOtherItem = ref.read(
                        baseAvailabilityResponseProv)[day][0];
                  }
                  availabilityProperFormatItem = [availabilityOtherItem, {"hour": picked.hour, "minute": picked.minute}];
                }
                else{
                  showErrorDialog(context, "End time must be after start time");
                }
              }



            if (availabilityProperFormatItem == null){
              lg.w("picker is null returning");
              return;
            }

            /// should be ok without microtask, not sure where I thought it needed it
            // scheduleMicrotask(() {
              lg.t("update base with new time");
              var oldAVObj = Map.of(ref.read(baseAvailabilityResponseProv));
              lg.t("[oldAVObj] ~ " + oldAVObj.toString());
              oldAVObj[day] = availabilityProperFormatItem;
              ref
                  .read(baseAvailabilityResponseProv.notifier)
                  .state = todImplToBaseAvailabilityWithDayEnabledMod(
                oldAVObj, dayEnabled,);
              lg.t("[newVObj] LOOK FOR MISSING KEY ~ " +
                  ref.read(baseAvailabilityResponseProv).toString());

      loadBaseAvailabilityToTroImpl();

      setState(() {});

            // });
    });



    // ref.read(saveAvailabilityArgsProv.notifier).state = [availability, dayEnabled, ref.read(doubleBookingEnabledProv)];
    /// place to convert form data into baseAv
  }

  @override
  Widget build(BuildContext context) {

    if (loading){
      return Center(child: CircularProgressIndicator());
    }

    return
      // ListView(
      //     children: [
      // Expanded(
      // child:

            ListView(
          shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: days_full.map((Uday) {
          String lDay = Uday.toLowerCase();
          final enabled = dayEnabled[lDay]!;
          final timeRange = availabilityTroImpl[lDay]!;

          return Column(
            key: ValueKey(lDay),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: enabled,
                    onChanged: (value) async {
                      var new_day_enb = dayEnabled;
                      new_day_enb[lDay] = value!;

                        var oldAVObj = Map.of(
                            ref.read(baseAvailabilityResponseProv));
                        var buildNewAVObj = todImplToBaseAvailabilityWithDayEnabledMod(
                          oldAVObj, new_day_enb,);

                        lg.t("build new AV Obj LOOK FOR MISSING KEY ~ " + buildNewAVObj.toString());
                        ref
                            .read(baseAvailabilityResponseProv.notifier)
                            .state = buildNewAVObj;

                      await loadBaseAvailabilityToTroImpl();

                      setState((){ dayEnabled = new_day_enb; });



                      lg.t("set with day ~ " + ref.watch(baseAvailabilityResponseProv).toString());
                    },
                  ),
                  Text(
                    Uday,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              if (enabled)
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => pickTime(context, lDay, true, availabilityTroImpl),
                        child: Text('Start: ${formatTimeHH_MM_AM(timeRange.start)}'),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () => pickTime(context, lDay, false, availabilityTroImpl),
                        child: Text('End: ${formatTimeHH_MM_AM(timeRange.end)}'),
                      ),
                    ],
                  ),
                ),
        ]);
        }).toList()..add(Column(children:[
          SizedBox(height: Gss.height * .01),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: ref.watch(baseAvailabilityResponseProv)["double_booking_enabled"],
                            onChanged: (value) {
                              // setState(() {
                              //   doubleBookingEnabled = value!;
                              // });
                              // ref.read(doubleBookingEnabledProv.notifier).state = value!;
                              // ref.read(saveAvailabilityArgsProv.notifier).state = [availability, dayEnabled, ref.read(doubleBookingEnabledProv)];

                              var oldAVObj = Map.of(ref.read(baseAvailabilityResponseProv));
                              oldAVObj["double_booking_enabled"] = value;


                              // ref.read(baseAvailabilityResponseProv.notifier).state = todImplToBaseAvailabilityAll(oldAVObj);
                              ref.read(baseAvailabilityResponseProv.notifier).state = oldAVObj;
                            },
                          ),
                          Text(
                            "Allow Double Booking",
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.question_mark, size: Theme.of(context).textTheme.bodyMedium!.fontSize,),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true, // dismiss when tapping outside
                                builder: (context) => AlertDialog(
                                  title: Text('Double Booking',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  content:  Text('This option allows clients to schedule regardless of the existing bookings. It is still your choice to confirm these booking requests... for example for deliveries that may be flexible in timing.',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),

          SizedBox(height: Gss.height * .03),

          // updateAvailability?
          // RoundedOutlineButton(onTap: () async {
          //
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (_) => const Center(child: CircularProgressIndicator()),
          //   );
          //
          //   /// Cannot type tighter... error ~ type '_Map<dynamic, dynamic>' is not a subtype of type 'Map<String, dynamic>'
          //   var updateBA = updateBaseAvailabilityObject(availability, dayEnabled);
          //
          //   ref.read(baseAvailabilityResponseProv.notifier).state = updateBA;
          //
          //   await saveBaseAvailability(ref.read(userAuthProv)!.userId,
          //       ref.read(userAuthProv)!.userToken, availability, dayEnabled, doubleBookingEnabled);
          //
          //   Navigator.of(context).pop();
          //
          //   setState(() {
          //     updateAvailability = false;
          //   });
          // },
          //   label: "Save",
          //   width: Gss.width * .88,
          //   paddingVertical: Gss.height * .01,
          // ):Container(),

          SizedBox(height: Gss.height*.0224,)

        ])));


        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        // children: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(vertical: 8.sr, horizontal: 8.sr),
        //   child:Row(children: [
        //   Text("Current Block Outs: None",
        //   style: Theme.of(context).textTheme.bodyLarge,
        //   ),]))
        // ]),
        //
        // Padding(
        // padding: const EdgeInsets.all(16),
        // child: OutlinedButton(
        // style: OutlinedButton.styleFrom(
        // shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.circular(24),
        // ),
        // padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        // ),
        // onPressed: () {
        //   showErrorDialog(context, "This feature will be available soon");
        // },
        // child: const Text('Add Block Out'),
        // ),
        // ),
        // ],
        // );

  }
}

void showCustomTimePicker(BuildContext context, TimeOfDay initialTime, Function(TimeOfDay) onAccepted) {
  int hour12 = initialTime.hourOfPeriod == 0 ? 12 : initialTime.hourOfPeriod;
  int minute = initialTime.minute;
      // - (initialTime.minute % 15);
  String period = initialTime.period == DayPeriod.am ? 'AM' : 'PM';

  TimeOfDay selected = initialTime;

  showModalBottomSheet(
    context: context,
    builder: (_) {
      int selectedHour = hour12;
      int selectedMinute = minute;
      String selectedPeriod = period;

      void updateSelected() {
        int hour24 = selectedHour % 12;
        if (selectedPeriod == 'PM') hour24 += 12;
        if (selectedHour == 12 && selectedPeriod == 'AM') hour24 = 0; // midnight
        selected = TimeOfDay(hour: hour24, minute: selectedMinute);
      }

      return StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(
                          initialItem: (hour12 - 1)),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedHour = index + 1;
                          updateSelected();
                        });
                      },
                      children: List.generate(12, (index) {
                        final h = index + 1;
                        return Center(child: Text(h.toString()));
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(
                          initialItem: (minute )),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMinute = index * 15;
                          updateSelected();
                        });
                      },
                      children: List.generate(4, (index) {
                        final m = (index * 15).toString().padLeft(2, '0');
                        return Center(child: Text(m));
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(
                          initialItem: period == 'AM' ? 0 : 1),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedPeriod = index == 0 ? 'AM' : 'PM';
                          updateSelected();
                        });
                      },
                      children: const [
                        Center(child: Text('AM')),
                        Center(child: Text('PM')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //     onAccepted(selected);
            //   },
            //   child: const Text('Accept'),
            // ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.sr,vertical: 2.sr),
            child:RoundedOutlineButton(
            onTap: () {
              Navigator.pop(context);
              onAccepted(selected);
            },
            label: "Accept",
            // width: Gss.width * .88,
            paddingVertical: Gss.height * .01,
          )),
            SizedBox(height: Gss.height * .01),
          ],
        ),
      );
    },
  );
}


void showLinkCalendarDialog(BuildContext context) {
  String selected = 'Google'; // Default selection

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Link Calendar'),
          content:
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
              RadioListTile<String>(
                title: const Text('Apple'),
                value: 'Apple',
                groupValue: selected,
                onChanged: (value) => setState(() => selected = value!),
              ),
              RadioListTile<String>(
                title: const Text('Google'),
                value: 'Google',
                groupValue: selected,
                onChanged: (value) => setState(() => selected = value!),
              ),
            ],
          )),
          actions: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog

              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text('Cancel'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                lg.d('Selected: $selected');
                showErrorDialog(context, "This feature will be available soon");
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text('Link'),
            )]),
          ],
        ),
      );
    },
  );
}
