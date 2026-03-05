import 'package:freezed_annotation/freezed_annotation.dart';

import 'etc.dart';

part 'client_user_meta.freezed.dart';
part 'client_user_meta.g.dart';


/// Remember to keep all this data public because it is used for various purposes by other users
@freezed
abstract class  ClientUserMeta with _$ClientUserMeta {
  const factory ClientUserMeta({

    /// should be created at account creation
    required String userName,
    required UserType userType,

    /// user location data gets populated from "address"
    /// should all be set or all null
    String? geoHash,
    Map<String, dynamic>? location,
    String? address,
    String? addressGeoHash,
    Map<String, dynamic>? addressLocation

  }) = _ClientUserMeta;

  factory ClientUserMeta.fromJson(Map<String, dynamic> json) =>
      _$ClientUserMetaFromJson(json);

}