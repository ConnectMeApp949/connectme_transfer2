// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_user_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorUserMeta {
  /// should be created at account creation
  String get userName;
  UserType get userType;

  /// user location data gets populated from "address"
  /// should all be set or all null
  String? get geoHash;
  String? get address;
  Map<String, dynamic>? get location;

  /// {"lat": 39.8282, "lng": -98.5795}
  String? get businessName;
  String? get email;
  String? get phone;
  String? get website;
  String? get bio;
  double? get rating;
  int? get ratingCount;

  /// Create a copy of VendorUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorUserMetaCopyWith<VendorUserMeta> get copyWith =>
      _$VendorUserMetaCopyWithImpl<VendorUserMeta>(
          this as VendorUserMeta, _$identity);

  /// Serializes this VendorUserMeta to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorUserMeta &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.geoHash, geoHash) || other.geoHash == geoHash) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other.location, location) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userName,
      userType,
      geoHash,
      address,
      const DeepCollectionEquality().hash(location),
      businessName,
      email,
      phone,
      website,
      bio,
      rating,
      ratingCount);

  @override
  String toString() {
    return 'VendorUserMeta(userName: $userName, userType: $userType, geoHash: $geoHash, address: $address, location: $location, businessName: $businessName, email: $email, phone: $phone, website: $website, bio: $bio, rating: $rating, ratingCount: $ratingCount)';
  }
}

/// @nodoc
abstract mixin class $VendorUserMetaCopyWith<$Res> {
  factory $VendorUserMetaCopyWith(
          VendorUserMeta value, $Res Function(VendorUserMeta) _then) =
      _$VendorUserMetaCopyWithImpl;
  @useResult
  $Res call(
      {String userName,
      UserType userType,
      String? geoHash,
      String? address,
      Map<String, dynamic>? location,
      String? businessName,
      String? email,
      String? phone,
      String? website,
      String? bio,
      double? rating,
      int? ratingCount});
}

/// @nodoc
class _$VendorUserMetaCopyWithImpl<$Res>
    implements $VendorUserMetaCopyWith<$Res> {
  _$VendorUserMetaCopyWithImpl(this._self, this._then);

  final VendorUserMeta _self;
  final $Res Function(VendorUserMeta) _then;

  /// Create a copy of VendorUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? userType = null,
    Object? geoHash = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? businessName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? website = freezed,
    Object? bio = freezed,
    Object? rating = freezed,
    Object? ratingCount = freezed,
  }) {
    return _then(_self.copyWith(
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _self.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      geoHash: freezed == geoHash
          ? _self.geoHash
          : geoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      businessName: freezed == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingCount: freezed == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VendorUserMeta implements VendorUserMeta {
  const _VendorUserMeta(
      {required this.userName,
      required this.userType,
      this.geoHash,
      this.address,
      final Map<String, dynamic>? location,
      this.businessName,
      this.email,
      this.phone,
      this.website,
      this.bio,
      this.rating,
      this.ratingCount})
      : _location = location;
  factory _VendorUserMeta.fromJson(Map<String, dynamic> json) =>
      _$VendorUserMetaFromJson(json);

  /// should be created at account creation
  @override
  final String userName;
  @override
  final UserType userType;

  /// user location data gets populated from "address"
  /// should all be set or all null
  @override
  final String? geoHash;
  @override
  final String? address;
  final Map<String, dynamic>? _location;
  @override
  Map<String, dynamic>? get location {
    final value = _location;
    if (value == null) return null;
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// {"lat": 39.8282, "lng": -98.5795}
  @override
  final String? businessName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? website;
  @override
  final String? bio;
  @override
  final double? rating;
  @override
  final int? ratingCount;

  /// Create a copy of VendorUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorUserMetaCopyWith<_VendorUserMeta> get copyWith =>
      __$VendorUserMetaCopyWithImpl<_VendorUserMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorUserMetaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorUserMeta &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.geoHash, geoHash) || other.geoHash == geoHash) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userName,
      userType,
      geoHash,
      address,
      const DeepCollectionEquality().hash(_location),
      businessName,
      email,
      phone,
      website,
      bio,
      rating,
      ratingCount);

  @override
  String toString() {
    return 'VendorUserMeta(userName: $userName, userType: $userType, geoHash: $geoHash, address: $address, location: $location, businessName: $businessName, email: $email, phone: $phone, website: $website, bio: $bio, rating: $rating, ratingCount: $ratingCount)';
  }
}

/// @nodoc
abstract mixin class _$VendorUserMetaCopyWith<$Res>
    implements $VendorUserMetaCopyWith<$Res> {
  factory _$VendorUserMetaCopyWith(
          _VendorUserMeta value, $Res Function(_VendorUserMeta) _then) =
      __$VendorUserMetaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userName,
      UserType userType,
      String? geoHash,
      String? address,
      Map<String, dynamic>? location,
      String? businessName,
      String? email,
      String? phone,
      String? website,
      String? bio,
      double? rating,
      int? ratingCount});
}

/// @nodoc
class __$VendorUserMetaCopyWithImpl<$Res>
    implements _$VendorUserMetaCopyWith<$Res> {
  __$VendorUserMetaCopyWithImpl(this._self, this._then);

  final _VendorUserMeta _self;
  final $Res Function(_VendorUserMeta) _then;

  /// Create a copy of VendorUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userName = null,
    Object? userType = null,
    Object? geoHash = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? businessName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? website = freezed,
    Object? bio = freezed,
    Object? rating = freezed,
    Object? ratingCount = freezed,
  }) {
    return _then(_VendorUserMeta(
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _self.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      geoHash: freezed == geoHash
          ? _self.geoHash
          : geoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      businessName: freezed == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingCount: freezed == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
