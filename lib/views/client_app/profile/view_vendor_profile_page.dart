import 'dart:async';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/components/ui/image_widgets/future_firebase_image.dart';
import 'package:connectme_app/components/ui/modals/error_dialog.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/methods/messages.dart';
import 'package:connectme_app/methods/saved_services.dart';
import 'package:connectme_app/models/reviews/completed_review.dart';
import 'package:connectme_app/models/user/etc.dart';
import 'package:connectme_app/models/user/vendor_user_meta.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/providers/etc.dart';
import 'package:connectme_app/providers/purchases.dart';
import 'package:connectme_app/providers/reviews.dart';
import 'package:connectme_app/requests/ratings/ratings.dart';
import 'package:connectme_app/styles/colors.dart';
import 'package:connectme_app/util/datetime_util.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:connectme_app/views/messaging/chat_page.dart';
import 'package:connectme_app/views/strings/ui_message_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class VendorProfilePublicPage extends ConsumerStatefulWidget {
  const VendorProfilePublicPage({super.key,
    required this.vendorUserMeta,
    required this.vendorUserId,
    required this.showSaveButton,
     this.profileImageDownloadUrl
  });

  final VendorUserMeta vendorUserMeta;
  final String vendorUserId;
  final String? profileImageDownloadUrl;
  final bool showSaveButton;

  @override
  ConsumerState<VendorProfilePublicPage> createState() => _VendorProfilePublicPageState();
}

class _VendorProfilePublicPageState extends ConsumerState<VendorProfilePublicPage> {

  Map<String, dynamic> vendorReviewsResp = {
    "vendorRating": 0,
      "vendorRatingCount": 0,
  };

  @override
  void initState() {

    scheduleMicrotask(() async {
      await getVendorRatingsAgg(
           widget.vendorUserId,
      ).then((resp){
        if (resp["success"] == true){
          setState(() {
            vendorReviewsResp = resp;
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final reviewsForVendor = ref.watch(reviewsForVendorProvider(widget.vendorUserId));

    return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: ListView(children: [
          Container(
              width: double.infinity,
              // height: Gss.width*.67 + 120,
              child:
                  widget.profileImageDownloadUrl == null?
                  Image.asset('assets/images/etc/avatar_placeholder.jpeg',
                    height: Gss.width*.67,
                    width: Gss.width,
                  ):
              GalleryImageBuilderFromFutureUrl(
                downloadUrls:[widget.profileImageDownloadUrl],
                height: Gss.width*.67,
                width: Gss.width,
              )),
          SizedBox(height: Gss.height * .02,),
          ServiceDetailItemPadding(
              child:Text(widget.vendorUserMeta.address??"Unlisted",
                style:Theme.of(context).textTheme.bodyLarge,
              )),
          ServiceDetailItemPadding(
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text(widget.vendorUserMeta.businessName??"",
                      style:TextStyle(fontSize: 16.sr, fontWeight: FontWeight.w700,
                        color: appPrimarySwatch,
                      ),
                    ),

                    ref.watch(userTypeProv) == UserType.client && widget.showSaveButton?
                    IconButton(onPressed: ()async{
                      ref.watch(savedServiceProviderProv).contains(widget.vendorUserId)?
                      updateSavedServices(ref, widget.vendorUserId, remove:true)
                          :updateSavedServices(ref, widget.vendorUserId);
                    },
                        icon:
                        ref.watch(savedServiceProviderProv).contains(widget.vendorUserId)?
                        Icon(Icons.favorite,
                          color: appPrimarySwatch,
                        ):
                        Icon(Icons.favorite_border)
                    ):Container()

                  ])),
          SizedBox(height: Gss.height * .02),

          ServiceDetailItemPadding(
              child:
              Text(  widget.vendorUserMeta.bio??"",
                style:Theme.of(context).textTheme.bodyLarge,
              )),

          ServiceDetailItemPadding(
              child:
              Text("📞 " + (widget.vendorUserMeta.phone??"Unlisted"),
                style:Theme.of(context).textTheme.bodyLarge,
              )),

          ServiceDetailItemPadding(
              child:
              Text("🌐 " + (widget.vendorUserMeta.website??"Unlisted"),
                style:Theme.of(context).textTheme.bodyLarge,
              )),

          ServiceDetailItemPadding(
              child:
              Text("📧 " + (widget.vendorUserMeta.email??"Unlisted"),
                style:Theme.of(context).textTheme.bodyLarge,
              )),

          SizedBox(height: Gss.height * .02),
          SizedBox(height: Gss.height * .02),
          ref.watch(userTypeProv) == UserType.client?
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[ SizedBox(width: Gss.width * .04),
                RoundedOutlineButton(onTap: ()async{

                  showDialog(context: context, builder: (context) { return const Center(child: CircularProgressIndicator());});

                  var got_thread = await getThreadForChatPage(context, ref, ref.read(userAuthProv)!.userId, widget.vendorUserId, widget.vendorUserMeta.userName );

                  if (got_thread != null) {
                    Navigator.of(gNavigatorKey.currentContext!).pop();
                    Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) {
                      return ChatPage(thread: got_thread);
                    }));
                  }
                  else{
                    Navigator.of(gNavigatorKey.currentContext!).pop();
                    showErrorDialog(gNavigatorKey.currentContext!, default_error_message);

                    lg.e("got_thread null");
                  }


                },
                  label: "Message",
                  fontSize: 15.sr,
                  width: Gss.width*.88,
                  paddingVertical: 6.sr,
                )]):Container(),

          SizedBox(height: Gss.height * .02),

          ServiceDetailItemPadding(
              child:
              Text("Rating",
                style:Theme.of(context).textTheme.bodyLarge,
              )),

          vendorReviewsResp["vendorRating"] != null &&
              vendorReviewsResp["vendorRating"] > 0?
          // Expanded(
          //   child:
          Row(children:[
            RatingBar.builder(
              initialRating: vendorReviewsResp["vendorRating"]??0,
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
            Text("${vendorReviewsResp["vendorRating"]}/5 (${vendorReviewsResp["vendorRatingCount"]})",
              style:Theme.of(context).textTheme.bodyLarge,
            ),
          ]):
          ServiceDetailItemPadding(
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("No ratings yet",
                      style: Theme.of(context).textTheme.bodyLarge)]))
          ,

          SizedBox(height: Gss.height * .02),

          ServiceDetailItemPadding(
              child:
              Text("Reviews",
                style:Theme.of(context).textTheme.bodyLarge,
              )),

          reviewsForVendor.when(
            data: (List<CompletedReview> cReviews ){
              lg.t("reviews for vendor data len ~ " + cReviews.length.toString());
              if (cReviews.isNotEmpty){
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cReviews.length,
                    itemBuilder: (context, index)
                    {
                      lg.t("building vendor review listtile");
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
                                    style:Theme.of(context).textTheme.titleMedium,)),
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
        child:child);
  }
}
