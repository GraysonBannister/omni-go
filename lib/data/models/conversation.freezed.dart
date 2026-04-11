// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get id => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;
  String? get mode => throw _privateConstructorUsedError;
  List<Message> get messages => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isStreaming => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {String id,
      String? model,
      String? provider,
      String? mode,
      List<Message> messages,
      bool isLoading,
      bool isStreaming,
      String? error,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? model = freezed,
    Object? provider = freezed,
    Object? mode = freezed,
    Object? messages = null,
    Object? isLoading = null,
    Object? isStreaming = null,
    Object? error = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isStreaming: null == isStreaming
          ? _value.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? model,
      String? provider,
      String? mode,
      List<Message> messages,
      bool isLoading,
      bool isStreaming,
      String? error,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? model = freezed,
    Object? provider = freezed,
    Object? mode = freezed,
    Object? messages = null,
    Object? isLoading = null,
    Object? isStreaming = null,
    Object? error = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isStreaming: null == isStreaming
          ? _value.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl(
      {required this.id,
      this.model,
      this.provider,
      this.mode,
      final List<Message> messages = const [],
      this.isLoading = false,
      this.isStreaming = false,
      this.error,
      this.createdAt,
      this.updatedAt})
      : _messages = messages;

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final String id;
  @override
  final String? model;
  @override
  final String? provider;
  @override
  final String? mode;
  final List<Message> _messages;
  @override
  @JsonKey()
  List<Message> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isStreaming;
  @override
  final String? error;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Conversation(id: $id, model: $model, provider: $provider, mode: $mode, messages: $messages, isLoading: $isLoading, isStreaming: $isStreaming, error: $error, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isStreaming, isStreaming) ||
                other.isStreaming == isStreaming) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      model,
      provider,
      mode,
      const DeepCollectionEquality().hash(_messages),
      isLoading,
      isStreaming,
      error,
      createdAt,
      updatedAt);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation(
      {required final String id,
      final String? model,
      final String? provider,
      final String? mode,
      final List<Message> messages,
      final bool isLoading,
      final bool isStreaming,
      final String? error,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  String get id;
  @override
  String? get model;
  @override
  String? get provider;
  @override
  String? get mode;
  @override
  List<Message> get messages;
  @override
  bool get isLoading;
  @override
  bool get isStreaming;
  @override
  String? get error;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatListResponse _$ChatListResponseFromJson(Map<String, dynamic> json) {
  return _ChatListResponse.fromJson(json);
}

/// @nodoc
mixin _$ChatListResponse {
  List<ConversationSummary> get conversations =>
      throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this ChatListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatListResponseCopyWith<ChatListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatListResponseCopyWith<$Res> {
  factory $ChatListResponseCopyWith(
          ChatListResponse value, $Res Function(ChatListResponse) then) =
      _$ChatListResponseCopyWithImpl<$Res, ChatListResponse>;
  @useResult
  $Res call({List<ConversationSummary> conversations, int count});
}

/// @nodoc
class _$ChatListResponseCopyWithImpl<$Res, $Val extends ChatListResponse>
    implements $ChatListResponseCopyWith<$Res> {
  _$ChatListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversations = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      conversations: null == conversations
          ? _value.conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ConversationSummary>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatListResponseImplCopyWith<$Res>
    implements $ChatListResponseCopyWith<$Res> {
  factory _$$ChatListResponseImplCopyWith(_$ChatListResponseImpl value,
          $Res Function(_$ChatListResponseImpl) then) =
      __$$ChatListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ConversationSummary> conversations, int count});
}

/// @nodoc
class __$$ChatListResponseImplCopyWithImpl<$Res>
    extends _$ChatListResponseCopyWithImpl<$Res, _$ChatListResponseImpl>
    implements _$$ChatListResponseImplCopyWith<$Res> {
  __$$ChatListResponseImplCopyWithImpl(_$ChatListResponseImpl _value,
      $Res Function(_$ChatListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversations = null,
    Object? count = null,
  }) {
    return _then(_$ChatListResponseImpl(
      conversations: null == conversations
          ? _value._conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ConversationSummary>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatListResponseImpl implements _ChatListResponse {
  const _$ChatListResponseImpl(
      {required final List<ConversationSummary> conversations,
      required this.count})
      : _conversations = conversations;

  factory _$ChatListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatListResponseImplFromJson(json);

  final List<ConversationSummary> _conversations;
  @override
  List<ConversationSummary> get conversations {
    if (_conversations is EqualUnmodifiableListView) return _conversations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversations);
  }

  @override
  final int count;

  @override
  String toString() {
    return 'ChatListResponse(conversations: $conversations, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatListResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._conversations, _conversations) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_conversations), count);

  /// Create a copy of ChatListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatListResponseImplCopyWith<_$ChatListResponseImpl> get copyWith =>
      __$$ChatListResponseImplCopyWithImpl<_$ChatListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatListResponseImplToJson(
      this,
    );
  }
}

abstract class _ChatListResponse implements ChatListResponse {
  const factory _ChatListResponse(
      {required final List<ConversationSummary> conversations,
      required final int count}) = _$ChatListResponseImpl;

  factory _ChatListResponse.fromJson(Map<String, dynamic> json) =
      _$ChatListResponseImpl.fromJson;

  @override
  List<ConversationSummary> get conversations;
  @override
  int get count;

  /// Create a copy of ChatListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatListResponseImplCopyWith<_$ChatListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationSummary _$ConversationSummaryFromJson(Map<String, dynamic> json) {
  return _ConversationSummary.fromJson(json);
}

/// @nodoc
mixin _$ConversationSummary {
  String get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;
  String? get mode => throw _privateConstructorUsedError;
  int get messageCount => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ConversationSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationSummaryCopyWith<ConversationSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationSummaryCopyWith<$Res> {
  factory $ConversationSummaryCopyWith(
          ConversationSummary value, $Res Function(ConversationSummary) then) =
      _$ConversationSummaryCopyWithImpl<$Res, ConversationSummary>;
  @useResult
  $Res call(
      {String id,
      String? title,
      String? model,
      String? provider,
      String? mode,
      int messageCount,
      String? lastMessage,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ConversationSummaryCopyWithImpl<$Res, $Val extends ConversationSummary>
    implements $ConversationSummaryCopyWith<$Res> {
  _$ConversationSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? model = freezed,
    Object? provider = freezed,
    Object? mode = freezed,
    Object? messageCount = null,
    Object? lastMessage = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationSummaryImplCopyWith<$Res>
    implements $ConversationSummaryCopyWith<$Res> {
  factory _$$ConversationSummaryImplCopyWith(_$ConversationSummaryImpl value,
          $Res Function(_$ConversationSummaryImpl) then) =
      __$$ConversationSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? title,
      String? model,
      String? provider,
      String? mode,
      int messageCount,
      String? lastMessage,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ConversationSummaryImplCopyWithImpl<$Res>
    extends _$ConversationSummaryCopyWithImpl<$Res, _$ConversationSummaryImpl>
    implements _$$ConversationSummaryImplCopyWith<$Res> {
  __$$ConversationSummaryImplCopyWithImpl(_$ConversationSummaryImpl _value,
      $Res Function(_$ConversationSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? model = freezed,
    Object? provider = freezed,
    Object? mode = freezed,
    Object? messageCount = null,
    Object? lastMessage = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ConversationSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationSummaryImpl implements _ConversationSummary {
  const _$ConversationSummaryImpl(
      {required this.id,
      this.title,
      this.model,
      this.provider,
      this.mode,
      required this.messageCount,
      this.lastMessage,
      this.createdAt,
      this.updatedAt});

  factory _$ConversationSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String? title;
  @override
  final String? model;
  @override
  final String? provider;
  @override
  final String? mode;
  @override
  final int messageCount;
  @override
  final String? lastMessage;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ConversationSummary(id: $id, title: $title, model: $model, provider: $provider, mode: $mode, messageCount: $messageCount, lastMessage: $lastMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, model, provider, mode,
      messageCount, lastMessage, createdAt, updatedAt);

  /// Create a copy of ConversationSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationSummaryImplCopyWith<_$ConversationSummaryImpl> get copyWith =>
      __$$ConversationSummaryImplCopyWithImpl<_$ConversationSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationSummaryImplToJson(
      this,
    );
  }
}

abstract class _ConversationSummary implements ConversationSummary {
  const factory _ConversationSummary(
      {required final String id,
      final String? title,
      final String? model,
      final String? provider,
      final String? mode,
      required final int messageCount,
      final String? lastMessage,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ConversationSummaryImpl;

  factory _ConversationSummary.fromJson(Map<String, dynamic> json) =
      _$ConversationSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String? get title;
  @override
  String? get model;
  @override
  String? get provider;
  @override
  String? get mode;
  @override
  int get messageCount;
  @override
  String? get lastMessage;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ConversationSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationSummaryImplCopyWith<_$ConversationSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
