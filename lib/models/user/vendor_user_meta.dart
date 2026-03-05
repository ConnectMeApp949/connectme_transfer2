import 'package:freezed_annotation/freezed_annotation.dart';

import 'etc.dart';

part 'vendor_user_meta.freezed.dart';
part 'vendor_user_meta.g.dart';



/// Remember to keep all this data public because it is used for various purposes by other users
@freezed
abstract class  VendorUserMeta with _$VendorUserMeta {
  const factory VendorUserMeta({

    /// should be created at account creation
    required String userName,
    required UserType userType,
    /// user location data gets populated from "address"
    /// should all be set or all null
    String? geoHash,
    String? address,
    Map<String, dynamic>? location, /// {"lat": 39.8282, "lng": -98.5795}


    String? businessName,
    String? email,
    String? phone,
    String? website,
    String? bio,
    double? rating,
    int? ratingCount
  }) = _VendorUserMeta;

  factory VendorUserMeta.fromJson(Map<String, dynamic> json) =>
      _$VendorUserMetaFromJson(json);

}
