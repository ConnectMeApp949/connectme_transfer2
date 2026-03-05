// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_user_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientUserMeta {
  /// should be created at account creation
  String get userName;
  UserType get userType;

  /// user location data gets populated from "address"
  /// should all be set or all null
  String? get geoHash;
  Map<String, dynamic>? get location;
  String? get address;
  String? get addressGeoHash;
  Map<String, dynamic>? get addressLocation;

  /// Create a copy of ClientUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClientUserMetaCopyWith<ClientUserMeta> get copyWith =>
      _$ClientUserMetaCopyWithImpl<ClientUserMeta>(
          this as ClientUserMeta, _$identity);

  /// Serializes this ClientUserMeta to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClientUserMeta &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.geoHash, geoHash) || other.geoHash == geoHash) &&
            const DeepCollectionEquality().equals(other.location, location) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.addressGeoHash, addressGeoHash) ||
                other.addressGeoHash == addressGeoHash) &&
            const DeepCollectionEquality()
                .equals(other.addressLocation, addressLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userName,
      userType,
      geoHash,
      const DeepCollectionEquality().hash(location),
      address,
      addressGeoHash,
      const DeepCollectionEquality().hash(addressLocation));

  @override
  String toString() {
    return 'ClientUserMeta(userName: $userName, userType: $userType, geoHash: $geoHash, location: $location, address: $address, addressGeoHash: $addressGeoHash, addressLocation: $addressLocation)';
  }
}

/// @nodoc
abstract mixin class $ClientUserMetaCopyWith<$Res> {
  factory $ClientUserMetaCopyWith(
          ClientUserMeta value, $Res Function(ClientUserMeta) _then) =
      _$ClientUserMetaCopyWithImpl;
  @useResult
  $Res call(
      {String userName,
      UserType userType,
      String? geoHash,
      Map<String, dynamic>? location,
      String? address,
      String? addressGeoHash,
      Map<String, dynamic>? addressLocation});
}

/// @nodoc
class _$ClientUserMetaCopyWithImpl<$Res>
    implements $ClientUserMetaCopyWith<$Res> {
  _$ClientUserMetaCopyWithImpl(this._self, this._then);

  final ClientUserMeta _self;
  final $Res Function(ClientUserMeta) _then;

  /// Create a copy of ClientUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? userType = null,
    Object? geoHash = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? addressGeoHash = freezed,
    Object? addressLocation = freezed,
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
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      addressGeoHash: freezed == addressGeoHash
          ? _self.addressGeoHash
          : addressGeoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLocation: freezed == addressLocation
          ? _self.addressLocation
          : addressLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ClientUserMeta implements ClientUserMeta {
  const _ClientUserMeta(
      {required this.userName,
      required this.userType,
      this.geoHash,
      final Map<String, dynamic>? location,
      this.address,
      this.addressGeoHash,
      final Map<String, dynamic>? addressLocation})
      : _location = location,
        _addressLocation = addressLocation;
  factory _ClientUserMeta.fromJson(Map<String, dynamic> json) =>
      _$ClientUserMetaFromJson(json);

  /// should be created at account creation
  @override
  final String userName;
  @override
  final UserType userType;

  /// user location data gets populated from "address"
  /// should all be set or all null
  @override
  final String? geoHash;
  final Map<String, dynamic>? _location;
  @override
  Map<String, dynamic>? get location {
    final value = _location;
    if (value == null) return null;
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? address;
  @override
  final String? addressGeoHash;
  final Map<String, dynamic>? _addressLocation;
  @override
  Map<String, dynamic>? get addressLocation {
    final value = _addressLocation;
    if (value == null) return null;
    if (_addressLocation is EqualUnmodifiableMapView) return _addressLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of ClientUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClientUserMetaCopyWith<_ClientUserMeta> get copyWith =>
      __$ClientUserMetaCopyWithImpl<_ClientUserMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClientUserMetaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClientUserMeta &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.geoHash, geoHash) || other.geoHash == geoHash) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.addressGeoHash, addressGeoHash) ||
                other.addressGeoHash == addressGeoHash) &&
            const DeepCollectionEquality()
                .equals(other._addressLocation, _addressLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userName,
      userType,
      geoHash,
      const DeepCollectionEquality().hash(_location),
      address,
      addressGeoHash,
      const DeepCollectionEquality().hash(_addressLocation));

  @override
  String toString() {
    return 'ClientUserMeta(userName: $userName, userType: $userType, geoHash: $geoHash, location: $location, address: $address, addressGeoHash: $addressGeoHash, addressLocation: $addressLocation)';
  }
}

/// @nodoc
abstract mixin class _$ClientUserMetaCopyWith<$Res>
    implements $ClientUserMetaCopyWith<$Res> {
  factory _$ClientUserMetaCopyWith(
          _ClientUserMeta value, $Res Function(_ClientUserMeta) _then) =
      __$ClientUserMetaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userName,
      UserType userType,
      String? geoHash,
      Map<String, dynamic>? location,
      String? address,
      String? addressGeoHash,
      Map<String, dynamic>? addressLocation});
}

/// @nodoc
class __$ClientUserMetaCopyWithImpl<$Res>
    implements _$ClientUserMetaCopyWith<$Res> {
  __$ClientUserMetaCopyWithImpl(this._self, this._then);

  final _ClientUserMeta _self;
  final $Res Function(_ClientUserMeta) _then;

  /// Create a copy of ClientUserMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userName = null,
    Object? userType = null,
    Object? geoHash = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? addressGeoHash = freezed,
    Object? addressLocation = freezed,
  }) {
    return _then(_ClientUserMeta(
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
      location: freezed == location
          ? _self._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      addressGeoHash: freezed == addressGeoHash
          ? _self.addressGeoHash
          : addressGeoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLocation: freezed == addressLocation
          ? _self._addressLocation
          : addressLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
