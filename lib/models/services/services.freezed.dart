// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'services.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceOffered {
  String? get address;
  String get category;
  DateTime get createTime;
  String get description;
  String? get email;
  String get featureImageId;
  String? get geoHash;
  List get imageIds;
  List<String> get keywords;
  Map<String, dynamic>? get location;
  String get name;
  String? get phoneNumber;
  int get priceCents;
  int? get radius;
  double? get rating;
  int? get ratingCount;
  String get serviceId;
  String get site;

  /// on-site, client-site, remote, delivery
  int? get timeLength;
  String get vendorUserId;
  String get vendorBusinessName;
  String get vendorUserName;

  /// Create a copy of ServiceOffered
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ServiceOfferedCopyWith<ServiceOffered> get copyWith =>
      _$ServiceOfferedCopyWithImpl<ServiceOffered>(
          this as ServiceOffered, _$identity);

  /// Serializes this ServiceOffered to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ServiceOffered &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.featureImageId, featureImageId) ||
                other.featureImageId == featureImageId) &&
            (identical(other.geoHash, geoHash) || other.geoHash == geoHash) &&
            const DeepCollectionEquality().equals(other.imageIds, imageIds) &&
            const DeepCollectionEquality().equals(other.keywords, keywords) &&
            const DeepCollectionEquality().equals(other.location, location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.timeLength, timeLength) ||
                other.timeLength == timeLength) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName) &&
            (identical(other.vendorUserName, vendorUserName) ||
                other.vendorUserName == vendorUserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        address,
        category,
        createTime,
        description,
        email,
        featureImageId,
        geoHash,
        const DeepCollectionEquality().hash(imageIds),
        const DeepCollectionEquality().hash(keywords),
        const DeepCollectionEquality().hash(location),
        name,
        phoneNumber,
        priceCents,
        radius,
        rating,
        ratingCount,
        serviceId,
        site,
        timeLength,
        vendorUserId,
        vendorBusinessName,
        vendorUserName
      ]);

  @override
  String toString() {
    return 'ServiceOffered(address: $address, category: $category, createTime: $createTime, description: $description, email: $email, featureImageId: $featureImageId, geoHash: $geoHash, imageIds: $imageIds, keywords: $keywords, location: $location, name: $name, phoneNumber: $phoneNumber, priceCents: $priceCents, radius: $radius, rating: $rating, ratingCount: $ratingCount, serviceId: $serviceId, site: $site, timeLength: $timeLength, vendorUserId: $vendorUserId, vendorBusinessName: $vendorBusinessName, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class $ServiceOfferedCopyWith<$Res> {
  factory $ServiceOfferedCopyWith(
          ServiceOffered value, $Res Function(ServiceOffered) _then) =
      _$ServiceOfferedCopyWithImpl;
  @useResult
  $Res call(
      {String? address,
      String category,
      DateTime createTime,
      String description,
      String? email,
      String featureImageId,
      String? geoHash,
      List imageIds,
      List<String> keywords,
      Map<String, dynamic>? location,
      String name,
      String? phoneNumber,
      int priceCents,
      int? radius,
      double? rating,
      int? ratingCount,
      String serviceId,
      String site,
      int? timeLength,
      String vendorUserId,
      String vendorBusinessName,
      String vendorUserName});
}

/// @nodoc
class _$ServiceOfferedCopyWithImpl<$Res>
    implements $ServiceOfferedCopyWith<$Res> {
  _$ServiceOfferedCopyWithImpl(this._self, this._then);

  final ServiceOffered _self;
  final $Res Function(ServiceOffered) _then;

  /// Create a copy of ServiceOffered
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? category = null,
    Object? createTime = null,
    Object? description = null,
    Object? email = freezed,
    Object? featureImageId = null,
    Object? geoHash = freezed,
    Object? imageIds = null,
    Object? keywords = null,
    Object? location = freezed,
    Object? name = null,
    Object? phoneNumber = freezed,
    Object? priceCents = null,
    Object? radius = freezed,
    Object? rating = freezed,
    Object? ratingCount = freezed,
    Object? serviceId = null,
    Object? site = null,
    Object? timeLength = freezed,
    Object? vendorUserId = null,
    Object? vendorBusinessName = null,
    Object? vendorUserName = null,
  }) {
    return _then(_self.copyWith(
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      featureImageId: null == featureImageId
          ? _self.featureImageId
          : featureImageId // ignore: cast_nullable_to_non_nullable
              as String,
      geoHash: freezed == geoHash
          ? _self.geoHash
          : geoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      imageIds: null == imageIds
          ? _self.imageIds
          : imageIds // ignore: cast_nullable_to_non_nullable
              as List,
      keywords: null == keywords
          ? _self.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      priceCents: null == priceCents
          ? _self.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      radius: freezed == radius
          ? _self.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingCount: freezed == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _self.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      timeLength: freezed == timeLength
          ? _self.timeLength
          : timeLength // ignore: cast_nullable_to_non_nullable
              as int?,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserName: null == vendorUserName
          ? _self.vendorUserName
          : vendorUserName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ServiceOffered implements ServiceOffered {
  const _ServiceOffered(
      {this.address,
      required this.category,
      required this.createTime,
      required this.description,
      this.email,
      required this.featureImageId,
      this.geoHash,
      required final List imageIds,
      required final List<String> keywords,
      final Map<String, dynamic>? location,
      required this.name,
      this.phoneNumber,
      required this.priceCents,
      this.radius,
      this.rating,
      this.ratingCount,
      required this.serviceId,
      required this.site,
      this.timeLength,
      required this.vendorUserId,
      required this.vendorBusinessName,
      required this.vendorUserName})
      : _imageIds = imageIds,
        _keywords = keywords,
        _location = location;
  factory _ServiceOffered.fromJson(Map<String, dynamic> json) =>
      _$ServiceOfferedFromJson(json);

  @override
  final String? address;
  @override
  final String category;
  @override
  final DateTime createTime;
  @override
  final String description;
  @override
  final String? email;
  @override
  final String featureImageId;
  @override
  final String? geoHash;
  final List _imageIds;
  @override
  List get imageIds {
    if (_imageIds is EqualUnmodifiableListView) return _imageIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageIds);
  }

  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

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
  final String name;
  @override
  final String? phoneNumber;
  @override
  final int priceCents;
  @override
  final int? radius;
  @override
  final double? rating;
  @override
  final int? ratingCount;
  @override
  final String serviceId;
  @override
  final String site;

  /// on-site, client-site, remote, delivery
  @override
  final int? timeLength;
  @override
  final String vendorUserId;
  @override
  final String vendorBusinessName;
  @override
  final String vendorUserName;

  /// Create a copy of ServiceOffered
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ServiceOfferedCopyWith<_ServiceOffered> get copyWith =>
      __$ServiceOfferedCopyWithImpl<_ServiceOffered>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ServiceOfferedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ServiceOffered &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.featureImageId, featureImageId) ||
                other.featureImageId == featureImageId) &&
            (identical(other.geoHash, geoHash) || other.geoHash == geoHash) &&
            const DeepCollectionEquality().equals(other._imageIds, _imageIds) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.timeLength, timeLength) ||
                other.timeLength == timeLength) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.vendorBusinessName, vendorBusinessName) ||
                other.vendorBusinessName == vendorBusinessName) &&
            (identical(other.vendorUserName, vendorUserName) ||
                other.vendorUserName == vendorUserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        address,
        category,
        createTime,
        description,
        email,
        featureImageId,
        geoHash,
        const DeepCollectionEquality().hash(_imageIds),
        const DeepCollectionEquality().hash(_keywords),
        const DeepCollectionEquality().hash(_location),
        name,
        phoneNumber,
        priceCents,
        radius,
        rating,
        ratingCount,
        serviceId,
        site,
        timeLength,
        vendorUserId,
        vendorBusinessName,
        vendorUserName
      ]);

  @override
  String toString() {
    return 'ServiceOffered(address: $address, category: $category, createTime: $createTime, description: $description, email: $email, featureImageId: $featureImageId, geoHash: $geoHash, imageIds: $imageIds, keywords: $keywords, location: $location, name: $name, phoneNumber: $phoneNumber, priceCents: $priceCents, radius: $radius, rating: $rating, ratingCount: $ratingCount, serviceId: $serviceId, site: $site, timeLength: $timeLength, vendorUserId: $vendorUserId, vendorBusinessName: $vendorBusinessName, vendorUserName: $vendorUserName)';
  }
}

/// @nodoc
abstract mixin class _$ServiceOfferedCopyWith<$Res>
    implements $ServiceOfferedCopyWith<$Res> {
  factory _$ServiceOfferedCopyWith(
          _ServiceOffered value, $Res Function(_ServiceOffered) _then) =
      __$ServiceOfferedCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? address,
      String category,
      DateTime createTime,
      String description,
      String? email,
      String featureImageId,
      String? geoHash,
      List imageIds,
      List<String> keywords,
      Map<String, dynamic>? location,
      String name,
      String? phoneNumber,
      int priceCents,
      int? radius,
      double? rating,
      int? ratingCount,
      String serviceId,
      String site,
      int? timeLength,
      String vendorUserId,
      String vendorBusinessName,
      String vendorUserName});
}

/// @nodoc
class __$ServiceOfferedCopyWithImpl<$Res>
    implements _$ServiceOfferedCopyWith<$Res> {
  __$ServiceOfferedCopyWithImpl(this._self, this._then);

  final _ServiceOffered _self;
  final $Res Function(_ServiceOffered) _then;

  /// Create a copy of ServiceOffered
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? address = freezed,
    Object? category = null,
    Object? createTime = null,
    Object? description = null,
    Object? email = freezed,
    Object? featureImageId = null,
    Object? geoHash = freezed,
    Object? imageIds = null,
    Object? keywords = null,
    Object? location = freezed,
    Object? name = null,
    Object? phoneNumber = freezed,
    Object? priceCents = null,
    Object? radius = freezed,
    Object? rating = freezed,
    Object? ratingCount = freezed,
    Object? serviceId = null,
    Object? site = null,
    Object? timeLength = freezed,
    Object? vendorUserId = null,
    Object? vendorBusinessName = null,
    Object? vendorUserName = null,
  }) {
    return _then(_ServiceOffered(
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createTime: null == createTime
          ? _self.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      featureImageId: null == featureImageId
          ? _self.featureImageId
          : featureImageId // ignore: cast_nullable_to_non_nullable
              as String,
      geoHash: freezed == geoHash
          ? _self.geoHash
          : geoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      imageIds: null == imageIds
          ? _self._imageIds
          : imageIds // ignore: cast_nullable_to_non_nullable
              as List,
      keywords: null == keywords
          ? _self._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _self._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      priceCents: null == priceCents
          ? _self.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      radius: freezed == radius
          ? _self.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingCount: freezed == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceId: null == serviceId
          ? _self.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _self.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      timeLength: freezed == timeLength
          ? _self.timeLength
          : timeLength // ignore: cast_nullable_to_non_nullable
              as int?,
      vendorUserId: null == vendorUserId
          ? _self.vendorUserId
          : vendorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorBusinessName: null == vendorBusinessName
          ? _self.vendorBusinessName
          : vendorBusinessName // ignore: cast_nullable_to_non_nullable
              as String,
      vendorUserName: null == vendorUserName
          ? _self.vendorUserName
          : vendorUserName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
