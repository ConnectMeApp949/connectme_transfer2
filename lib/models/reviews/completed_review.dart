import 'package:freezed_annotation/freezed_annotation.dart';
part 'completed_review.freezed.dart';
part 'completed_review.g.dart';

@freezed
abstract class CompletedReview with _$CompletedReview {
  const factory CompletedReview({
    required DateTime createTime,
    required String bookingId,
    required String clientUserId,
    required String clientUserName,
    required double rating,
    required String ratingComment,
    required String ratingId,
    required String serviceId,
    required String serviceName,
    required DateTime bookingTime,
    required String vendorUserId,
    required String vendorUserName,
  }) = _CompletedReview;

  factory CompletedReview.fromJson(Map<String, dynamic> json) => _$CompletedReviewFromJson(json);

}

