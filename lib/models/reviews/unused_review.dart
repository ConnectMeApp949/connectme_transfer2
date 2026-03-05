import 'package:freezed_annotation/freezed_annotation.dart';
part 'unused_review.freezed.dart';
part 'unused_review.g.dart';

@freezed
abstract class UnusedReview with _$UnusedReview {
  const factory UnusedReview({
    required String bookingId,
    required String clientUserId,
    required String clientUserName,
    required DateTime createTime,
    required String ratingId,
    required String serviceId,
    required String serviceName,
    required DateTime bookingTime,
    required String vendorUserId,
    required String vendorUserName,
  }) = _UnusedReview;

  factory UnusedReview.fromJson(Map<String, dynamic> json) => _$UnusedReviewFromJson(json);

}

