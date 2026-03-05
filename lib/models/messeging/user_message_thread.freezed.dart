// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_message_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserMessageThread {
  String get lastMessage;
  DateTime get lastUpdated;
  String get otherUserId;
  String get otherUserName;
  String get threadId;
  List? get unread;
  List? get wantBlock;

  /// Create a copy of UserMessageThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserMessageThreadCopyWith<UserMessageThread> get copyWith =>
      _$UserMessageThreadCopyWithImpl<UserMessageThread>(
          this as UserMessageThread, _$identity);

  /// Serializes this UserMessageThread to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserMessageThread &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.otherUserId, otherUserId) ||
                other.otherUserId == otherUserId) &&
            (identical(other.otherUserName, otherUserName) ||
                other.otherUserName == otherUserName) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            const DeepCollectionEquality().equals(other.unread, unread) &&
            const DeepCollectionEquality().equals(other.wantBlock, wantBlock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastMessage,
      lastUpdated,
      otherUserId,
      otherUserName,
      threadId,
      const DeepCollectionEquality().hash(unread),
      const DeepCollectionEquality().hash(wantBlock));

  @override
  String toString() {
    return 'UserMessageThread(lastMessage: $lastMessage, lastUpdated: $lastUpdated, otherUserId: $otherUserId, otherUserName: $otherUserName, threadId: $threadId, unread: $unread, wantBlock: $wantBlock)';
  }
}

/// @nodoc
abstract mixin class $UserMessageThreadCopyWith<$Res> {
  factory $UserMessageThreadCopyWith(
          UserMessageThread value, $Res Function(UserMessageThread) _then) =
      _$UserMessageThreadCopyWithImpl;
  @useResult
  $Res call(
      {String lastMessage,
      DateTime lastUpdated,
      String otherUserId,
      String otherUserName,
      String threadId,
      List? unread,
      List? wantBlock});
}

/// @nodoc
class _$UserMessageThreadCopyWithImpl<$Res>
    implements $UserMessageThreadCopyWith<$Res> {
  _$UserMessageThreadCopyWithImpl(this._self, this._then);

  final UserMessageThread _self;
  final $Res Function(UserMessageThread) _then;

  /// Create a copy of UserMessageThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastMessage = null,
    Object? lastUpdated = null,
    Object? otherUserId = null,
    Object? otherUserName = null,
    Object? threadId = null,
    Object? unread = freezed,
    Object? wantBlock = freezed,
  }) {
    return _then(_self.copyWith(
      lastMessage: null == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      otherUserId: null == otherUserId
          ? _self.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserName: null == otherUserName
          ? _self.otherUserName
          : otherUserName // ignore: cast_nullable_to_non_nullable
              as String,
      threadId: null == threadId
          ? _self.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      unread: freezed == unread
          ? _self.unread
          : unread // ignore: cast_nullable_to_non_nullable
              as List?,
      wantBlock: freezed == wantBlock
          ? _self.wantBlock
          : wantBlock // ignore: cast_nullable_to_non_nullable
              as List?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserMessageThread implements UserMessageThread {
  const _UserMessageThread(
      {required this.lastMessage,
      required this.lastUpdated,
      required this.otherUserId,
      required this.otherUserName,
      required this.threadId,
      final List? unread,
      final List? wantBlock})
      : _unread = unread,
        _wantBlock = wantBlock;
  factory _UserMessageThread.fromJson(Map<String, dynamic> json) =>
      _$UserMessageThreadFromJson(json);

  @override
  final String lastMessage;
  @override
  final DateTime lastUpdated;
  @override
  final String otherUserId;
  @override
  final String otherUserName;
  @override
  final String threadId;
  final List? _unread;
  @override
  List? get unread {
    final value = _unread;
    if (value == null) return null;
    if (_unread is EqualUnmodifiableListView) return _unread;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List? _wantBlock;
  @override
  List? get wantBlock {
    final value = _wantBlock;
    if (value == null) return null;
    if (_wantBlock is EqualUnmodifiableListView) return _wantBlock;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of UserMessageThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserMessageThreadCopyWith<_UserMessageThread> get copyWith =>
      __$UserMessageThreadCopyWithImpl<_UserMessageThread>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserMessageThreadToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserMessageThread &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.otherUserId, otherUserId) ||
                other.otherUserId == otherUserId) &&
            (identical(other.otherUserName, otherUserName) ||
                other.otherUserName == otherUserName) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            const DeepCollectionEquality().equals(other._unread, _unread) &&
            const DeepCollectionEquality()
                .equals(other._wantBlock, _wantBlock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastMessage,
      lastUpdated,
      otherUserId,
      otherUserName,
      threadId,
      const DeepCollectionEquality().hash(_unread),
      const DeepCollectionEquality().hash(_wantBlock));

  @override
  String toString() {
    return 'UserMessageThread(lastMessage: $lastMessage, lastUpdated: $lastUpdated, otherUserId: $otherUserId, otherUserName: $otherUserName, threadId: $threadId, unread: $unread, wantBlock: $wantBlock)';
  }
}

/// @nodoc
abstract mixin class _$UserMessageThreadCopyWith<$Res>
    implements $UserMessageThreadCopyWith<$Res> {
  factory _$UserMessageThreadCopyWith(
          _UserMessageThread value, $Res Function(_UserMessageThread) _then) =
      __$UserMessageThreadCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String lastMessage,
      DateTime lastUpdated,
      String otherUserId,
      String otherUserName,
      String threadId,
      List? unread,
      List? wantBlock});
}

/// @nodoc
class __$UserMessageThreadCopyWithImpl<$Res>
    implements _$UserMessageThreadCopyWith<$Res> {
  __$UserMessageThreadCopyWithImpl(this._self, this._then);

  final _UserMessageThread _self;
  final $Res Function(_UserMessageThread) _then;

  /// Create a copy of UserMessageThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lastMessage = null,
    Object? lastUpdated = null,
    Object? otherUserId = null,
    Object? otherUserName = null,
    Object? threadId = null,
    Object? unread = freezed,
    Object? wantBlock = freezed,
  }) {
    return _then(_UserMessageThread(
      lastMessage: null == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      otherUserId: null == otherUserId
          ? _self.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserName: null == otherUserName
          ? _self.otherUserName
          : otherUserName // ignore: cast_nullable_to_non_nullable
              as String,
      threadId: null == threadId
          ? _self.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      unread: freezed == unread
          ? _self._unread
          : unread // ignore: cast_nullable_to_non_nullable
              as List?,
      wantBlock: freezed == wantBlock
          ? _self._wantBlock
          : wantBlock // ignore: cast_nullable_to_non_nullable
              as List?,
    ));
  }
}

// dart format on
