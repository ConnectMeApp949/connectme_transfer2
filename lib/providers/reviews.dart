

import 'package:connectme_app/models/reviews/completed_review.dart';
import 'package:connectme_app/requests/ratings/ratings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth.dart';



final reviewsForVendorProvider =
FutureProvider.family<List<CompletedReview>, String>((ref, vendorUserId) async {
  final user = ref.watch(userAuthProv)!;

  // lg.t("[reviewsForServiceProvider] calling getRatingsForService");
  Future<List<CompletedReview>> rfv = getRatingsForVendor(
    user.userId,
    user.userToken,
    vendorUserId,
  );

  return rfv;
});
