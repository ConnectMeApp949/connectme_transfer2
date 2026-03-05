// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserAuth {
  String get userName;
  String get userId;
  String get userToken;
  String get email;
  String get accountLevel;
  bool get purchaseEver;

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserAuthCopyWith<UserAuth> get copyWith =>
      _$UserAuthCopyWithImpl<UserAuth>(this as UserAuth, _$identity);

  /// Serializes this UserAuth to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserAuth &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userToken, userToken) ||
                other.userToken == userToken) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.accountLevel, accountLevel) ||
                other.accountLevel == accountLevel) &&
            (identical(other.purchaseEver, purchaseEver) ||
                other.purchaseEver == purchaseEver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userName, userId, userToken,
      email, accountLevel, purchaseEver);

  @override
  String toString() {
    return 'UserAuth(userName: $userName, userId: $userId, userToken: $userToken, email: $email, accountLevel: $accountLevel, purchaseEver: $purchaseEver)';
  }
}

/// @nodoc
abstract mixin class $UserAuthCopyWith<$Res> {
  factory $UserAuthCopyWith(UserAuth value, $Res Function(UserAuth) _then) =
      _$UserAuthCopyWithImpl;
  @useResult
  $Res call(
      {String userName,
      String userId,
      String userToken,
      String email,
      String accountLevel,
      bool purchaseEver});
}

/// @nodoc
class _$UserAuthCopyWithImpl<$Res> implements $UserAuthCopyWith<$Res> {
  _$UserAuthCopyWithImpl(this._self, this._then);

  final UserAuth _self;
  final $Res Function(UserAuth) _then;

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? userId = null,
    Object? userToken = null,
    Object? email = null,
    Object? accountLevel = null,
    Object? purchaseEver = null,
  }) {
    return _then(_self.copyWith(
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userToken: null == userToken
          ? _self.userToken
          : userToken // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      accountLevel: null == accountLevel
          ? _self.accountLevel
          : accountLevel // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseEver: null == purchaseEver
          ? _self.purchaseEver
          : purchaseEver // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserAuth implements UserAuth {
  const _UserAuth(
      {required this.userName,
      required this.userId,
      required this.userToken,
      required this.email,
      required this.accountLevel,
      required this.purchaseEver});
  factory _UserAuth.fromJson(Map<String, dynamic> json) =>
      _$UserAuthFromJson(json);

  @override
  final String userName;
  @override
  final String userId;
  @override
  final String userToken;
  @override
  final String email;
  @override
  final String accountLevel;
  @override
  final bool purchaseEver;

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserAuthCopyWith<_UserAuth> get copyWith =>
      __$UserAuthCopyWithImpl<_UserAuth>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserAuthToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserAuth &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userToken, userToken) ||
                other.userToken == userToken) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.accountLevel, accountLevel) ||
                other.accountLevel == accountLevel) &&
            (identical(other.purchaseEver, purchaseEver) ||
                other.purchaseEver == purchaseEver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userName, userId, userToken,
      email, accountLevel, purchaseEver);

  @override
  String toString() {
    return 'UserAuth(userName: $userName, userId: $userId, userToken: $userToken, email: $email, accountLevel: $accountLevel, purchaseEver: $purchaseEver)';
  }
}

/// @nodoc
abstract mixin class _$UserAuthCopyWith<$Res>
    implements $UserAuthCopyWith<$Res> {
  factory _$UserAuthCopyWith(_UserAuth value, $Res Function(_UserAuth) _then) =
      __$UserAuthCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userName,
      String userId,
      String userToken,
      String email,
      String accountLevel,
      bool purchaseEver});
}

/// @nodoc
class __$UserAuthCopyWithImpl<$Res> implements _$UserAuthCopyWith<$Res> {
  __$UserAuthCopyWithImpl(this._self, this._then);

  final _UserAuth _self;
  final $Res Function(_UserAuth) _then;

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userName = null,
    Object? userId = null,
    Object? userToken = null,
    Object? email = null,
    Object? accountLevel = null,
    Object? purchaseEver = null,
  }) {
    return _then(_UserAuth(
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userToken: null == userToken
          ? _self.userToken
          : userToken // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      accountLevel: null == accountLevel
          ? _self.accountLevel
          : accountLevel // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseEver: null == purchaseEver
          ? _self.purchaseEver
          : purchaseEver // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
