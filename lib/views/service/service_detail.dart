import 'dart:async';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/image_widgets/future_firebase_image.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/methods/saved_services.dart';
import 'package:connectme_app/models/reviews/completed_review.dart';
import 'package:connectme_app/models/services/services.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/models/user/vendor_user_meta.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/providers/user.dart';
import 'package:connectme_app/requests/ratings/ratings.dart';
import 'package:connectme_app/requests/user/user_meta.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/client_app/calendar/calendar_page.dart';
import 'package:connectme_app/views/client_app/home/client_home_tab.dart';
import 'package:connectme_app/views/client_app/profile/view_vendor_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/ui/etc/tab_page_header.dart';
import '../../util/etc.dart';


final bookNowServiceProv = StateProvider<ServiceOffered?>((ref) {return null;});


final reviewsForServiceProvider =
FutureProvider.family<List<CompletedReview>, String>((ref, serviceId) async {
  final user = ref.watch(userAuthProv)!;

  // lg.t("[reviewsForServiceProvider] calling getRatingsForService");
  Future<List<CompletedReview>> rfs = getRatingsForService(
    user.userId,
    user.userToken,
    serviceId,
  );

return rfs;

});


class ServiceDetail extends ConsumerStatefulWidget {
  const ServiceDetail({super.key,
    required this.service
  });

  final ServiceOffered service;

  @override
  ConsumerState<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends ConsumerState<ServiceDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final reviewsForService = ref.watch(reviewsForServiceProvider(widget.service.serviceId));

    return Scaffold(
        // appBar: AppBar(title: const Text('Details')),
        body: ListView(children: [
          PageHeaderWithBack(titleString:"Details"),
          Container(
              width: double.infinity,
              // height: Gss.width*.67 + 120,
              child:
              GalleryImageBuilderFromFutureUrl(
                imagePathSlugs:widget.service.imageIds,
                height: Gss.width*.67,
                width: Gss.width,
              )),

          SizedBox(height: Gss.height * .02,),
          ServiceDetailItemPadding(
              child:Text(widget.service.name ,
                style:Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
              )),

          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                SizedBox(width: Gss.width * .06,),
                ServiceListItemCategoryChip(
                    categoryString: widget.service.category
                )]),

          ServiceDetailItemPadding(
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    GestureDetector(
                      onTap:()async{

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => Center(child:
                          CircularProgressIndicator(color: appPrimarySwatch,)),
                        );

                        try {
                          await getUserMeta(
                            widget.service.vendorUserId,
                            // ref.read(userAuthProv)!.userToken
                          ).then((resp) async {

                            if (resp["success"] == true) {
                              VendorUserMeta vum = VendorUserMeta.fromJson(
                                  resp["data"]);

                              String? getProfilePicUrl = await getFirebaseProfileImageUrl(
                                  widget.service.vendorUserId);
                              Navigator.pop(gNavigatorKey.currentContext!);
                              Navigator.of(gNavigatorKey.currentContext!).push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return
                                      VendorProfilePublicPage(
                                        vendorUserMeta: vum,
                                        vendorUserId: widget.service
                                            .vendorUserId,
                                        profileImageDownloadUrl: getProfilePicUrl,
                                        showSaveButton: true,
                                      );
                                  },
                                  // builder: (_) => DayViewPageDemo(),
                                ),
                              );
                            }
                            else{
                              throw Exception("Error fetching user meta");
                            }
                          });
                        }catch(e){
                          lg.w("err caught getting user meta, did ${widget.service.vendorUserId} delete their account?");
                          lg.e(e.toString());
                          Navigator.pop(gNavigatorKey.currentContext!);

                        }



                      },
                    child:Container(
                        width: Gss.width *.67 , /// could probably change
                        child:Row(children:[Flexible(child:Text(widget.service.vendorBusinessName,
                      style:Theme.of(context).textTheme.titleMedium!.
                      copyWith(fontWeight: FontWeight.w600,
                      color: appPrimarySwatch[700],
                      ),
                    ))]))),

                    ref.watch(userTypeProv) == UserType.client?
                    IconButton(onPressed: ()async{
                      ref.watch(savedServiceProviderProv).contains(widget.service.vendorUserId)?
                      updateSavedServices(ref, widget.service.vendorUserId, remove:true)
                          :updateSavedServices(ref, widget.service.vendorUserId);
                    },
                        icon:
                        ref.watch(savedServiceProviderProv).contains(widget.service.vendorUserId)?
                        Icon(Icons.favorite,
                        color: appPrimarySwatch[700],
                        ):
                        Icon(Icons.favorite_border)
                    ):Container()

                  ])),

              ServiceDetailItemPadding(
                  child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Text("⌖ "+ widget.service.site ,
                          style: Theme.of(context).textTheme.titleLarge,
                        )

                      ])),

                  widget.service.address!=null?
                  ServiceDetailItemPadding(
                  child:
                    Text("\u{1F4CD} " + widget.service.address!,
                    style: Theme.of(context).textTheme.titleLarge,
                    )
                  ):Container(),

          Divider(height: 1,),
          ServiceDetailItemPadding(
              child:
              Text(widget.service.description,
                style: Theme.of(context).textTheme.titleLarge,
              )),

          // ServiceDetailItemPadding(
          //     child:
          //     Text( "Keywords: " + widget.service.keywords.join(", "),
          //       style:Theme.of(context).textTheme.bodyLarge,
          //     )),
        SizedBox(height: Gss.height * .0225),
          ServiceDetailItemPadding(
              child:
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                SI_BubbleWrap(wordList: widget.service.keywords,)])),

          SizedBox(height: Gss.height * .0225),
          ServiceDetailItemPadding(
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(Icons.access_time_rounded,
                      size: 18,
                    ),
                    SizedBox(width: Gss.width * .01),
                    // Text(widget.service.timeLength.toString() + " minutes",
                    //   style:Theme.of(context).textTheme.bodySmall,
                    // ),
                    widget.service.timeLength != 0 && widget.service.timeLength != null?
                    Text(formatMinutesToHours(widget.service.timeLength!),
                        style: TextStyle(fontSize: 12.sr,
                          fontWeight: FontWeight.w300,
                        )):
                    Text("No time limit",
                      style: TextStyle(fontSize: 12.sr,
                        fontWeight: FontWeight.w300,
                      ),),
                    SizedBox(width: Gss.width * .24),

                    Text(formatCents(widget.service.priceCents),
                        style:TextStyle(fontSize: 18.sr, fontWeight: FontWeight.w700,
                          color: appPrimarySwatch[600],
                        )),

                  ])),
          // ServiceDetailItemPadding(
          // child:
          // Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children:[
          // Padding(padding: EdgeInsets.symmetric(horizontal: Gss.width * .04),
          //       child:Text("\$"+(widget.service.priceCents / 100).toStringAsFixed(0),
          // style:TextStyle(fontSize: 18.sr, fontWeight: FontWeight.w700,
          // color: appPrimarySwatch,
          // ))),
          //     SizedBox(width: Gss.width * .04),
          //     ],
          // ),
          // ),
          SizedBox(height: Gss.height * .05),
          ref.watch(userTypeProv) == UserType.client?
          ServiceDetailItemPadding(
          child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[ SizedBox(width: Gss.width * .04),
                RoundedOutlineButton(

                  onTap: (){

                  ref.read(bookNowServiceProv.notifier).state = widget.service;

                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ClientBookingCalendarPage(
                      vendorUserId: widget.service.vendorUserId,
                    );
                  }));
                },

                  label: "Book Now",
                  fontSize: 15.sr,
                  width: Gss.width*.88,
                  paddingVertical: 6.sr,
                  // width: Gss.width * .58,
                  // paddingVertical: Gss.height * .01,
                )])):Container(),

          SizedBox(height: Gss.height * .04),
          ServiceDetailItemPadding(
              child:
              Text("Rating",
                style:Theme.of(context).textTheme.titleMedium,
              )),

          widget.service.rating != null && widget.service.rating! > 0?
          // Expanded(
          //   child:

          Padding(
            /// slightly more than detail item padding
            padding: EdgeInsets.symmetric(horizontal:  Gss.width * .045),
          child:Row(children:[
          RatingBar.builder(
              initialRating: widget.service.rating??0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              unratedColor: Colors.grey[300],
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                // setState(() {
                //   _rating = rating;
                // });
                // ref.read(ratingFilterProvider.notifier).state = rating;
              },
              ignoreGestures: true,

          ),
        Text("${widget.service.rating}/5 (${widget.service.ratingCount})",
          style:Theme.of(context).textTheme.bodyLarge,
        ),
          ])):
          ServiceDetailItemPadding(
              child:
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("No ratings yet",
                style: Theme.of(context).textTheme.bodyLarge)])),

      SizedBox(height: Gss.height * .02),

          ServiceDetailItemPadding(
              child:
              Text("Reviews",
                style:Theme.of(context).textTheme.headlineSmall,
              )),

                    reviewsForService.when(
                      data: (List<CompletedReview> cReviews ){
                        lg.t("reviews for service data len ~ " + cReviews.length.toString());
                      if (cReviews.isNotEmpty){
                        return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cReviews.length,
                        itemBuilder: (context, index)
                      {
                        lg.t("building service review listtile");
                        return
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Gss.height * .01),
                        child:
                          ListTile(
                          title: Row(children: [
                            Text("${cReviews[index].clientUserName}",
                              style:Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(width: Gss.width * .03),
                            RatingBar.builder(
                              initialRating: cReviews[index].rating
                                  // ??0
                              ,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 12.sr,
                              unratedColor: Colors.grey[300],
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {
                                // setState(() {
                                //   _rating = rating;
                                // });
                                // ref.read(ratingFilterProvider.notifier).state = rating;
                              },
                              ignoreGestures: true,

                            ),
                            SizedBox(width: Gss.width * .03),
                            Text("${humanReadableDateTime(cReviews[index].createTime)}",
                              style:Theme.of(context).textTheme.titleMedium,
                            ),
                          ],),
                            // style:Theme.of(context).textTheme.bodyLarge,),
                          subtitle:
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Gss.height * .01),
                        child:
                          Text(
                      // "${cReviews[index].rating.toStringAsFixed(1)}/5 "
                      "${cReviews[index].ratingComment}",
                      style:Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500))),
                          // trailing:
                        ));
                      });
                      }
                      else{
                      return   ServiceDetailItemPadding(
                            child:
                            Text("No reviews yet",
                              style:Theme.of(context).textTheme.bodyLarge,
                            ));
                      }
                        },
                      loading: () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[Center(child:CircularProgressIndicator())]),
                      error: (err, stack) => Text('Error: $err'),
                    ),

          SizedBox(height: Gss.height * .02),





          // Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children:[
          // RoundedOutlineButton(onTap: (){
          //   // Navigator.of(context).pop();
          // },
          //   label: "Book Now",
          //   width: Gss.width * .45,
          //   paddingVertical: Gss.height * .01,
          // )]),

          SizedBox(height: Gss.height * .1),
        ])
    );
  }
}

class ServiceDetailItemPadding extends StatelessWidget {
  const ServiceDetailItemPadding({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.symmetric(
        vertical: Gss.width * .03,
        horizontal: Gss.width * .035),
        child:
        Row(children: [
          Flexible(child: child)
        ])
        );
  }
}

class ServiceListItemCategoryChip extends StatelessWidget {
  const ServiceListItemCategoryChip({super.key, required this.categoryString});
  final String categoryString;

  @override
  Widget build(BuildContext context) {
    return
      FittedBox(
        fit: BoxFit.scaleDown,
        child:  Container( decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          // border: Border.all(color: Theme.of(context).colorScheme.primary),
          border: Border.all(color: Theme.of(context).textTheme.titleSmall!.color!),
          // borderRadius: BorderRadius.circular(3.sr), /// should be same as parent Image wrap
         borderRadius:
            BorderRadius.all( Radius.circular(Theme.of(context).textTheme.bodyMedium!.fontSize! * .4),
          // topRight: Radius.circular(16)
        ),
        ),
      child:Padding(
      padding:  EdgeInsets.symmetric(vertical: 1.sr, horizontal: 6.sr),
      child:
      Text(categoryString,
        style:Theme.of(context).textTheme.bodyMedium,
      ),
      ),
    ));
  }
}