import 'dart:async';
import 'dart:convert';

import 'package:connectme_app/components/ui/buttons/rounded_outline_button.dart';
import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/views/client_app/reviews/reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:connectme_app/models/reviews/completed_review.dart';
import 'package:connectme_app/models/reviews/unused_review.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/util/screen_util.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../config/logger.dart';

// "createTime": datetime.now(timezone.utc),
// "bookingId": pdata.get("bookingId"),
// "clientUserId": pdata.get("clientUserId"),
// "clientUserName": pdata.get("clientUserName"),
// 'rating': pdata.get("rating"),
// 'ratingComment': pdata.get("ratingComment"),
// 'ratingId': rating_id,
// "serviceId": pdata.get("serviceId"),
// "serviceName": pdata.get("serviceName"),
// "vendorUserId": pdata.get("vendorUserId"),
// "vendorUserName": pdata.get("vendorUserName"),

Future submitReview(Map reviewData) async {
lg.t("[submitReview] called");
  final response = await http.post(
    Uri.parse(create_review_url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(reviewData),
  );

  if (response.statusCode != 200) {
    lg.e("[submitReview] something went wrong ~ " + response.body.toString());

  }
  return jsonDecode(response.body);
}

class ReviewSubmitPage extends ConsumerStatefulWidget {
  const ReviewSubmitPage({super.key,
  required this.review
  });
  final UnusedReview review;

  @override
  ConsumerState<ReviewSubmitPage> createState() => _ReviewSubmitPageState();
}

class _ReviewSubmitPageState extends ConsumerState<ReviewSubmitPage> {

  double _rating = 5;
  String _reviewText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: ListView(children: [
        SizedBox(height: Gss.height * .04),
        ReviewInfoListItem(
            child:
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Flexible(
              child:Text(widget.review.serviceName,
              style: TextStyle(fontSize: 18.sr, fontWeight: FontWeight.w500),
            )),])),
        ReviewInfoListItem(
            child:
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Flexible(
                      child:
            Text("Vendor: " + widget.review.vendorUserName,
              style: TextStyle(fontSize: 17.sr),
            ))])),
        ReviewInfoListItem(
            child:
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Flexible(
                      child:
            Text("Time: " + DateFormat('MMMM d, y h:mm a').format(widget.review.bookingTime.toLocal()),
              style: TextStyle(fontSize: 17.sr),
            ))])),

        SizedBox(height: Gss.height * .1),

        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[Text("Rate:",
              style: TextStyle(fontSize: 19.sr, fontWeight: FontWeight.w700),
            ),]),
        SizedBox(height: Gss.height * .05),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
        RatingBar.builder(
          initialRating: 5,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 30,
          unratedColor: Colors.grey[300],
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        )]),
        SizedBox(height: Gss.height * .1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text("Review message: ",
              style: TextStyle(fontSize: 19.sr),
            )]),
        SizedBox(height: Gss.height * .05),
        ReviewInfoListItem(
            child:
        TextField(
          minLines: 3,
          maxLines: 5,
          maxLength: 300,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your review here',
              hintStyle:TextStyle(fontSize: 15.sr)
          ),
          onChanged: (val){
            setState(() {
              _reviewText = val;
            });
          })),

        SizedBox(height: Gss.height * .1),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
        child: RoundedOutlineButton(onTap: ()async{

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          lg.t("Build review data");

          /// No idea how this passed my tests before without the toIso8601String()
          Map reviewData = {
            "userId": ref.read(userAuthProv)!.userId,
            "authToken": ref.read(userAuthProv)!.userToken,
            "bookingId": widget.review.bookingId,
            "clientUserId": widget.review.clientUserId,
            "clientUserName": widget.review.clientUserName,
            "createTime": widget.review.createTime.toIso8601String(),
            'rating': _rating,
            'ratingComment': _reviewText,
            'ratingId': widget.review.ratingId,
            "serviceId": widget.review.serviceId,
            "serviceName": widget.review.serviceName,
            "bookingTime": widget.review.bookingTime.toIso8601String(),
            "vendorUserId": widget.review.vendorUserId,
            "vendorUserName": widget.review.vendorUserName,
          };

          lg.t("Submit review");

          await submitReview(
            reviewData
          );

          lg.t("pop if mounted");

          if (context.mounted) {
            var refresh = ref.refresh(reviewsProvider);
            lg.t("wants to use refresh ~ " + refresh.toString());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
          label: "Submit",
          width: Gss.width * .88,
          paddingVertical: Gss.height * .01,
        )),
      ]));
  }
}

class ReviewInfoListItem extends StatelessWidget {
  const ReviewInfoListItem({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return
      Padding(
          padding: EdgeInsets.symmetric(vertical: 6.sr,
          horizontal: Gss.width * .03),
      child: child);
  }
}





class ReviewEditPage extends ConsumerStatefulWidget {
  const ReviewEditPage({super.key,
    required this.review
  });
  final CompletedReview review;

  @override
  ConsumerState<ReviewEditPage> createState() => _ReviewEditPageState();
}

class _ReviewEditPageState extends ConsumerState<ReviewEditPage> {

  double _rating = 5;
  String _reviewText = "";

  TextEditingController reviewTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(()async {
      setState(() {
        _rating = widget.review.rating;
        _reviewText = widget.review.ratingComment;
        reviewTextController.text = _reviewText;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    reviewTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit Review')),
        body: ListView(children: [
          SizedBox(height: Gss.height * .04),
          ReviewInfoListItem(
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Flexible(
                        child:Text(widget.review.serviceName,
                          style: TextStyle(fontSize: 18.sr, fontWeight: FontWeight.w500),
                        )),])),
          ReviewInfoListItem(
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Flexible(
                        child:
                        Text("Vendor: " + widget.review.vendorUserName,
                          style: TextStyle(fontSize: 17.sr),
                        ))])),
          ReviewInfoListItem(
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Flexible(
                        child:
                        Text("Time: " + DateFormat('MMMM d, y h:mm a').format(widget.review.bookingTime.toLocal()),
                          style: TextStyle(fontSize: 17.sr),
                        ))])),

          SizedBox(height: Gss.height * .1),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[Text("Rate:",
                style: TextStyle(fontSize: 19.sr, fontWeight: FontWeight.w700),
              ),]),
          SizedBox(height: Gss.height * .05),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30,
                  unratedColor: Colors.grey[300],
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                )]),
          SizedBox(height: Gss.height * .1),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("Review message: ",
                  style: TextStyle(fontSize: 19.sr),
                )]),
          SizedBox(height: Gss.height * .05),
          ReviewInfoListItem(
              child:
              TextField(
                 controller: reviewTextController,
                  style: TextStyle(fontSize: 15.sr),
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 300,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle:TextStyle(fontSize: 15.sr)
                  ),
                  onChanged: (val){
                    setState(() {
                      _reviewText = val;
                    });
                  })),

          SizedBox(height: Gss.height * .1),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: Gss.width * .03),
              child: RoundedOutlineButton(onTap: ()async{

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                lg.t("Build review data");

                /// No idea how this passed my tests before without the toIso8601String()
                Map reviewData = {
                  "userId": ref.read(userAuthProv)!.userId,
                  "authToken": ref.read(userAuthProv)!.userToken,
                  "bookingId": widget.review.bookingId,
                  "clientUserId": widget.review.clientUserId,
                  "clientUserName": widget.review.clientUserName,
                  "createTime": widget.review.createTime.toIso8601String(),
                  'rating': _rating,
                  'ratingComment': _reviewText,
                  'ratingId': widget.review.ratingId,
                  "serviceId": widget.review.serviceId,
                  "serviceName": widget.review.serviceName,
                  "bookingTime": widget.review.bookingTime.toIso8601String(),
                  "vendorUserId": widget.review.vendorUserId,
                  "vendorUserName": widget.review.vendorUserName,
                };

                lg.t("Submit review");

                await submitReview(
                    reviewData
                );

                lg.t("pop if mounted");

                if (context.mounted) {
                  var refresh = ref.refresh(reviewsProvider);
                  lg.t("wants to use refresh ~ " + refresh.toString());
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
                label: "Submit",
                width: Gss.width * .88,
                paddingVertical: Gss.height * .01,
              )),
        ]));
  }
}