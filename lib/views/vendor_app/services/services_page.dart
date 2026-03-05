import 'dart:async';

import 'package:connectme_app/components/ui/image_widgets/future_firebase_image.dart';
import 'package:connectme_app/components/ui/modals/delete_account_dialog.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/settings.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/requests/services/services.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/etc.dart';
import 'package:connectme_app/views/service/service_detail.dart';

import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:connectme_app/views/vendor_app/profile/business_information.dart';

import 'package:flutter/material.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/services.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/logger.dart';
import 'add_service_page.dart';
import 'edit_service_page.dart';


class VendorServicesPage extends ConsumerStatefulWidget {
  const VendorServicesPage({super.key});

  @override
  ConsumerState<VendorServicesPage> createState() => _VendorServicesPageState();
}

class _VendorServicesPageState extends ConsumerState<VendorServicesPage> {

  /// users might be able to press button after set to true but before new added services are loaded
  /// but just do this for now
  bool canAddMoreServices = false;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(vendorServicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Services'),
      actions:[

      //   IconButton(onPressed: (){
      //   ref.read(vendorServicesProvider.notifier).refresh();
      // },
      //   icon: const Icon(Icons.refresh)
      // )

        IconButton(onPressed: (){

          if (!canAddMoreServices){
            showErrorDialog(context, "You have already added the limit of ${vendorServicesLimit} services. Please delete a service before adding more.");
            return;
          }

          if (ref.watch(vendorUserMetaProv)!.businessName == null){
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: const Text('Please finish updating profile before creating a service'),
                content: const Text(""),
                actions: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return const BusinessInformation();
                                }));
                          },
                          child: const Text('Update Information'),
                        )
                      ])
                ],
              );
            });
            return;
          }

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddServicePage();
          }));
        },
            icon: const Icon(Icons.add_circle_outline)
        )

      ]
      ),
      body:
         servicesAsync.when(
        data: (services) {

          /// check limit on services
          if (services.isNotEmpty){
            if (services.length < vendorServicesLimit){
              setState(() {
                canAddMoreServices = true;
              });
            }
            else{
              setState(() {
                canAddMoreServices = false;
              });
            }
          }
          else if (services.isEmpty){
            setState(() {
              canAddMoreServices = true;
            });
          }

          return
          servicesAsync.value!.isNotEmpty?
           ListView.builder(
          itemCount: servicesAsync.value!.length,
          itemBuilder: (_, index) {
            final service = ref.watch(vendorServicesProvider).value?[index];
            return
              Padding(
                  key: ValueKey(service!.serviceId),
                  padding: EdgeInsets.symmetric(vertical: Gss.width * .01),
              child:GestureDetector(

              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ServiceDetail(service: service);
                }));
              },
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ImageBuilderFromFutureUrl(path: service.featureImageId,
                  width: Gss.width,
                  height: Gss.width * .67,
                  ),

                    Container(

                      decoration:BoxDecoration(
                          color: Theme.of(context).canvasColor,
                        boxShadow:[
                        ref.watch(darkModeProv) ?
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ):BoxShadow(
                          color: Colors.black.withValues(alpha:.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]),
                      padding: EdgeInsets.symmetric(vertical: Gss.width * .05,
                      horizontal: Gss.width * .015
                      ),
                        child:Column(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Gss.width * .015),
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Expanded(child:Center(child:
                                Text(service.name,
                              style: TextStyle(fontSize: 16.sr,
                                fontWeight: FontWeight.w800,
                              ),))),
                                // IconButton(onPressed: (){
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                // },
                                //     icon: const Icon(Icons.edit_note_sharp)
                                // )
                                PopupMenuButton<String>(
                                  onSelected: (value) async{
                                    if (value == 'Delete'){
                                      // showDialog(
                                      //   context: context,
                                      //   barrierDismissible: false,
                                      //   builder: (_) => const Center(child: CircularProgressIndicator()),
                                      // );

                                      await showConfirmDeleteDialog(context,
                                        username: ref.read(userAuthProv)!.userName,
                                        onConfirm: ()async{
                                        try {
                                          await deleteService(
                                              ref.read(userAuthProv)!.userId,
                                              ref.read(userAuthProv)!.userToken,
                                              service.serviceId);
                                        }catch(e){
                                          lg.e("error deleting service ~ " + e.toString());
                                        }
                                          ref.read(vendorServicesProvider.notifier).refresh();
                                          // Navigator.of(context).pop();
                                        });
                                    }
                                    if (value == 'Edit'){
                                      Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
                                        return EditServicePage(service: service);
                                      }));
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                     PopupMenuItem<String>(
                                      value: 'Edit',
                                      child: Text('Edit',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                     PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Text('Delete',
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                  child: IconButton(
                                    onPressed: null, // Use the PopupMenuButton's own tap
                                    icon:  Icon(Icons.edit_note_sharp,
                                    size: 15.sr,
                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                    )
                                  ),
                                )
                              ])),
                          SizedBox(height: Gss.height * .01),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
                          child:
                          Row(children: [
                            Icon(Icons.access_time_rounded,
                            size: 15.sr,
                            ),
                            SizedBox(width: Gss.width * .01),
                            service.timeLength != 0 && service.timeLength != null?
                            // Text(service.timeLength.toString() + " minutes",
                            //   style: TextStyle(fontSize: 12.sr,
                            //     fontWeight: FontWeight.w300,
                            //   ),):
                            Text(formatMinutesToHours(service.timeLength!),
                              style: TextStyle(fontSize: 12.sr,
                                    fontWeight: FontWeight.w300,
                              )):
                            Text("No time limit",
                              style: TextStyle(fontSize: 12.sr,
                                fontWeight: FontWeight.w300,
                              ),)
                            ,
                        ])),
                          SizedBox(height: Gss.height * .01),

                          Padding(
                          padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
                          child:
                          service.rating != null?
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                          // Expanded(
                          // child:
                          // SizedBox(width: Gss.width * .6,
                                Expanded(child:Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:[RatingBar.builder(
                          initialRating: service.rating??0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5, // 5 stars
                            itemSize: 14.sr  ,
                            unratedColor: Colors.grey[300],
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0.sr),
                            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rating) {
                              // setState(() {
                              //   _rating = rating;
                              // });
                              // ref.read(ratingFilterProvider.notifier).state = rating;
                            },
                            ignoreGestures: true,
                      ),
                                      Text("${service.rating}/5 (${service.ratingCount})",
                                        style:Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ])),
                        SizedBox(width: Gss.width * .18,
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children:[
                            Flexible(
                              child:Text(formatCents(service.priceCents) ,
                              style: TextStyle(fontSize: 18.sr,
                                fontWeight: FontWeight.w500,
                                color: appPrimarySwatch,
                              ),))])),

                          ]):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Text("No ratings yet",
                          style: TextStyle(fontSize: 12.sr,
                            fontWeight: FontWeight.w300,
                          ),),

                            Expanded(
                            child:Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:[
                                  Flexible(
                                      child:Text(formatCents(service.priceCents) ,
                                        style: TextStyle(fontSize: 18.sr,
                                          fontWeight: FontWeight.w500,
                                          color: appPrimarySwatch[600],
                                        ),))]))

                          ])
                          ),
                  ],),
              ),
            ])
            ));
          }):
          Container(height: double.infinity,
              child: Center(child: Text(nothingHereYetMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              )));
          },
             loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(default_error_message),
              const SizedBox(height: 8),
             ])
              )
         )

    );
  }
}



Future<void> showConfirmDeleteDialog(
    BuildContext context, {
      required String username,
      required Future<void> Function() onConfirm,
    }) {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<bool> isMatch = ValueNotifier(false);
  final isLoading = ValueNotifier(false);

  return showDialog(
    context: context,
    barrierDismissible: !isLoading.value,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content:

        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
        Text('Are you sure you want to delete this service?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Text('Type your username $username to confirm:',
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
          ]),
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
                child: Text('Cancel'),
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
                    await onConfirm();
                    Navigator.of(gNavigatorKey.currentContext!).pop();
                  } catch (e) {
                    isLoading.value = false;
                    Navigator.of(gNavigatorKey.currentContext!).pop();
                    ScaffoldMessenger.of(gNavigatorKey.currentContext!).showSnackBar(
                      SnackBar(content: Text('Failed to delete: $e')),
                    );
                  }
                }
                    : null,
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: Text('Delete',
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

