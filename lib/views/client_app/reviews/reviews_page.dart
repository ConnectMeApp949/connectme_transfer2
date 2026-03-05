import 'dart:async';
import 'dart:convert';

import 'package:connectme_app/config/globals.dart';
import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/models/reviews/completed_review.dart';
import 'package:connectme_app/models/reviews/unused_review.dart';
import 'package:connectme_app/providers/auth.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:connectme_app/views/client_app/reviews/review_submit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';




Future<List> fetchReviews(String userId, String authToken, String reviewType) async {
  lg.t("[fetchReviews] called");
  final response = await http.post(Uri.parse(get_reviews_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "userId": userId,
        "authToken": authToken,
        "ratingStatus": reviewType
      }));

  lg.t("[fetchReviews] got response ");
  if (response.statusCode != 200) {
    throw Exception('Failed to load completed reviews');
  }

  lg.t("[fetchReviews] deocded response ");

  final List<dynamic> data = jsonDecode(response.body)["ratings"];

  lg.t("[fetchReviews] test deocded response length ~ " + data.length.toString());
  if (reviewType == "completed") {
    lg.t("[fetchReviews] completed call from json ~ ");
    lg.t("[fetchReviews] ~ " + data.toString());
    return data.map((json_date) => CompletedReview.fromJson(json_date)).toList();
  }
  else if (reviewType == "unused"){
    lg.t("[fetchReviews] unused call from json ~");
    return data.map((json_date) => UnusedReview.fromJson(json_date)).toList();
  }
  lg.t("[fetchReviews] returning empty list");
  return [];
}


final reviewsProvider = FutureProvider<List<dynamic>>((ref) async {

  lg.t("reviews provider called");
  var completed = [];
  var unused = [];
  try {
    completed = await fetchReviews(
        ref.read(userAuthProv)!.userId,
        ref.read(userAuthProv)!.userToken,
        "completed");
     unused = await fetchReviews(
        ref.read(userAuthProv)!.userId,
        ref.read(userAuthProv)!.userToken,
        "unused");
  }catch(e){
    lg.e("error fetching reviews ~ " + e.toString());
  }

  lg.t("fetched reviews combine");
  final all = <dynamic>[
    ...completed,
    ...unused,
  ];

  lg.t("sort reviews");
  all.sort((a, b) => b.createTime.compareTo(a.createTime)); // newest first
  lg.t("sort reviews done");
  return all;
});

class ReviewsPage extends ConsumerStatefulWidget {
  const ReviewsPage({super.key});

  @override
  ConsumerState<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends ConsumerState<ReviewsPage> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final reviewsAsync = ref.watch(reviewsProvider);

    return reviewsAsync.when(
      loading: () => Scaffold(
          appBar: AppBar(title: const Text('Reviews')),
          body:Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
          appBar: AppBar(title: const Text('Reviews'),
              actions: [ IconButton(onPressed: ()async{
                ref.invalidate(reviewsProvider);
                var refresh = ref.refresh(reviewsProvider);
                lg.t("wants to use refresh ~ " + refresh.toString());
              },
                  icon: Icon(Icons.refresh)
              )],
          ),
          body:Center(child: Text('Error: $err'))),
      data: (reviewList) {
        if (reviewList.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Reviews'),
            actions: [ IconButton(onPressed: (){
              var refresh = ref.refresh(reviewsProvider);
              lg.t("wants to use refresh ~ " + refresh.toString());
            },
                icon: Icon(Icons.refresh)
            )]),
            body: const Center(child: Text("Nothing here yet")),
          );
        }
        return Scaffold(
            appBar: AppBar(title: const Text('Reviews'),
            actions: [ IconButton(onPressed: (){
              var refresh = ref.refresh(reviewsProvider);
              lg.t("wants to use refresh ~ " + refresh.toString());
            },
                icon: Icon(Icons.refresh)
            )],
            ),
            body:
            ListView(
              children: reviewList.map((review) {
                // lg.t("build review list tile ~ "+ review.toString());
                if (review is CompletedReview) {
                  return ListTile(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReviewEditPage(
                              review: review,
                            ),
                          ),
                        );
                      },
                    title: Text('✅ ${review.serviceName}',
                      style:Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text('${DateFormat('MMMM d, y').format(review.createTime.toLocal())} ' +
                        review.ratingComment.toString() ,
                    style:Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing:
                        SizedBox(width: Gss.width * .4,
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:[
                    RatingBar.builder(
                      initialRating: review.rating
                          // ??0,
                      ,
                      allowHalfRating: true,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 24,
                      unratedColor: Colors.grey[300],
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,

                    ),
                      Text("${review.rating}/5"),
                      ]))
                  );
                } else if (review is UnusedReview) {
                  return ListTile(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ReviewSubmitPage(
                            review: review,
                          ),
                        ),
                      );
                    },
                    title: Text('⬜️ ${review.serviceName}',
                      style:Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text('${DateFormat('MMMM d, y').format(review.createTime.toLocal())}',
                      style:Theme.of(context).textTheme.bodyLarge,
                    ),

                    trailing: Text("Review",
                    style:Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }).toList(),
            ),
        );
      },
    );
  }
}




