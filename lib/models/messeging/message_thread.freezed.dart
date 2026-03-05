// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageThread {
  String get threadId;
  String get lastMessage;
  DateTime get lastUpdated;
  List<String> get userIds;
  List<String> get userNames;

  /// Create a copy of MessageThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageThreadCopyWith<MessageThread> get copyWith =>
      _$MessageThreadCopyWithImpl<MessageThread>(
          this as MessageThread, _$identity);

  /// Serializes this MessageThread to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageThread &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(other.userIds, userIds) &&
            const DeepCollectionEquality().equals(other.userNames, userNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      threadId,
      lastMessage,
      lastUpdated,
      const DeepCollectionEquality().hash(userIds),
      const DeepCollectionEquality().hash(userNames));

  @override
  String toString() {
    return 'MessageThread(threadId: $threadId, lastMessage: $lastMessage, lastUpdated: $lastUpdated, userIds: $userIds, userNames: $userNames)';
  }
}

/// @nodoc
abstract mixin class $MessageThreadCopyWith<$Res> {
  factory $MessageThreadCopyWith(
          MessageThread value, $Res Function(MessageThread) _then) =
      _$MessageThreadCopyWithImpl;
  @useResult
  $Res call(
      {String threadId,
      String lastMessage,
      DateTime lastUpdated,
      List<String> userIds,
      List<String> userNames});
}

/// @nodoc
class _$MessageThreadCopyWithImpl<$Res>
    implements $MessageThreadCopyWith<$Res> {
  _$MessageThreadCopyWithImpl(this._self, this._then);

  final MessageThread _self;
  final $Res Function(MessageThread) _then;

  /// Create a copy of MessageThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? lastMessage = null,
    Object? lastUpdated = null,
    Object? userIds = null,
    Object? userNames = null,
  }) {
    return _then(_self.copyWith(
      threadId: null == threadId
          ? _self.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userIds: null == userIds
          ? _self.userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userNames: null == userNames
          ? _self.userNames
          : userNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MessageThread implements MessageThread {
  const _MessageThread(
      {required this.threadId,
      required this.lastMessage,
      required this.lastUpdated,
      required final List<String> userIds,
      required final List<String> userNames})
      : _userIds = userIds,
        _userNames = userNames;
  factory _MessageThread.fromJson(Map<String, dynamic> json) =>
      _$MessageThreadFromJson(json);

  @override
  final String threadId;
  @override
  final String lastMessage;
  @override
  final DateTime lastUpdated;
  final List<String> _userIds;
  @override
  List<String> get userIds {
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userIds);
  }

  final List<String> _userNames;
  @override
  List<String> get userNames {
    if (_userNames is EqualUnmodifiableListView) return _userNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userNames);
  }

  /// Create a copy of MessageThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MessageThreadCopyWith<_MessageThread> get copyWith =>
      __$MessageThreadCopyWithImpl<_MessageThread>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageThreadToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MessageThread &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(other._userIds, _userIds) &&
            const DeepCollectionEquality()
                .equals(other._userNames, _userNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      threadId,
      lastMessage,
      lastUpdated,
      const DeepCollectionEquality().hash(_userIds),
      const DeepCollectionEquality().hash(_userNames));

  @override
  String toString() {
    return 'MessageThread(threadId: $threadId, lastMessage: $lastMessage, lastUpdated: $lastUpdated, userIds: $userIds, userNames: $userNames)';
  }
}

/// @nodoc
abstract mixin class _$MessageThreadCopyWith<$Res>
    implements $MessageThreadCopyWith<$Res> {
  factory _$MessageThreadCopyWith(
          _MessageThread value, $Res Function(_MessageThread) _then) =
      __$MessageThreadCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String threadId,
      String lastMessage,
      DateTime lastUpdated,
      List<String> userIds,
      List<String> userNames});
}

/// @nodoc
class __$MessageThreadCopyWithImpl<$Res>
    implements _$MessageThreadCopyWith<$Res> {
  __$MessageThreadCopyWithImpl(this._self, this._then);

  final _MessageThread _self;
  final $Res Function(_MessageThread) _then;

  /// Create a copy of MessageThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? threadId = null,
    Object? lastMessage = null,
    Object? lastUpdated = null,
    Object? userIds = null,
    Object? userNames = null,
  }) {
    return _then(_MessageThread(
      threadId: null == threadId
          ? _self.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userIds: null == userIds
          ? _self._userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userNames: null == userNames
          ? _self._userNames
          : userNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
