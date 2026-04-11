// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TerminalSession _$TerminalSessionFromJson(Map<String, dynamic> json) {
  return _TerminalSession.fromJson(json);
}

/// @nodoc
mixin _$TerminalSession {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get buffer => throw _privateConstructorUsedError;
  String get currentInput => throw _privateConstructorUsedError;
  List<String> get history => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  int get cols => throw _privateConstructorUsedError;
  int get rows => throw _privateConstructorUsedError;
  String? get cwd => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TerminalSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TerminalSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TerminalSessionCopyWith<TerminalSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TerminalSessionCopyWith<$Res> {
  factory $TerminalSessionCopyWith(
          TerminalSession value, $Res Function(TerminalSession) then) =
      _$TerminalSessionCopyWithImpl<$Res, TerminalSession>;
  @useResult
  $Res call(
      {String id,
      String name,
      String buffer,
      String currentInput,
      List<String> history,
      bool isConnected,
      int cols,
      int rows,
      String? cwd,
      DateTime? createdAt});
}

/// @nodoc
class _$TerminalSessionCopyWithImpl<$Res, $Val extends TerminalSession>
    implements $TerminalSessionCopyWith<$Res> {
  _$TerminalSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TerminalSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? buffer = null,
    Object? currentInput = null,
    Object? history = null,
    Object? isConnected = null,
    Object? cols = null,
    Object? rows = null,
    Object? cwd = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      buffer: null == buffer
          ? _value.buffer
          : buffer // ignore: cast_nullable_to_non_nullable
              as String,
      currentInput: null == currentInput
          ? _value.currentInput
          : currentInput // ignore: cast_nullable_to_non_nullable
              as String,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      cols: null == cols
          ? _value.cols
          : cols // ignore: cast_nullable_to_non_nullable
              as int,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      cwd: freezed == cwd
          ? _value.cwd
          : cwd // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TerminalSessionImplCopyWith<$Res>
    implements $TerminalSessionCopyWith<$Res> {
  factory _$$TerminalSessionImplCopyWith(_$TerminalSessionImpl value,
          $Res Function(_$TerminalSessionImpl) then) =
      __$$TerminalSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String buffer,
      String currentInput,
      List<String> history,
      bool isConnected,
      int cols,
      int rows,
      String? cwd,
      DateTime? createdAt});
}

/// @nodoc
class __$$TerminalSessionImplCopyWithImpl<$Res>
    extends _$TerminalSessionCopyWithImpl<$Res, _$TerminalSessionImpl>
    implements _$$TerminalSessionImplCopyWith<$Res> {
  __$$TerminalSessionImplCopyWithImpl(
      _$TerminalSessionImpl _value, $Res Function(_$TerminalSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TerminalSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? buffer = null,
    Object? currentInput = null,
    Object? history = null,
    Object? isConnected = null,
    Object? cols = null,
    Object? rows = null,
    Object? cwd = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$TerminalSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      buffer: null == buffer
          ? _value.buffer
          : buffer // ignore: cast_nullable_to_non_nullable
              as String,
      currentInput: null == currentInput
          ? _value.currentInput
          : currentInput // ignore: cast_nullable_to_non_nullable
              as String,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      cols: null == cols
          ? _value.cols
          : cols // ignore: cast_nullable_to_non_nullable
              as int,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      cwd: freezed == cwd
          ? _value.cwd
          : cwd // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TerminalSessionImpl implements _TerminalSession {
  const _$TerminalSessionImpl(
      {required this.id,
      this.name = 'Terminal',
      this.buffer = '',
      this.currentInput = '',
      final List<String> history = const [],
      this.isConnected = false,
      this.cols = 80,
      this.rows = 24,
      this.cwd,
      this.createdAt})
      : _history = history;

  factory _$TerminalSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TerminalSessionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String buffer;
  @override
  @JsonKey()
  final String currentInput;
  final List<String> _history;
  @override
  @JsonKey()
  List<String> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  @JsonKey()
  final bool isConnected;
  @override
  @JsonKey()
  final int cols;
  @override
  @JsonKey()
  final int rows;
  @override
  final String? cwd;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TerminalSession(id: $id, name: $name, buffer: $buffer, currentInput: $currentInput, history: $history, isConnected: $isConnected, cols: $cols, rows: $rows, cwd: $cwd, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TerminalSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.buffer, buffer) || other.buffer == buffer) &&
            (identical(other.currentInput, currentInput) ||
                other.currentInput == currentInput) &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.cols, cols) || other.cols == cols) &&
            (identical(other.rows, rows) || other.rows == rows) &&
            (identical(other.cwd, cwd) || other.cwd == cwd) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      buffer,
      currentInput,
      const DeepCollectionEquality().hash(_history),
      isConnected,
      cols,
      rows,
      cwd,
      createdAt);

  /// Create a copy of TerminalSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TerminalSessionImplCopyWith<_$TerminalSessionImpl> get copyWith =>
      __$$TerminalSessionImplCopyWithImpl<_$TerminalSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TerminalSessionImplToJson(
      this,
    );
  }
}

abstract class _TerminalSession implements TerminalSession {
  const factory _TerminalSession(
      {required final String id,
      final String name,
      final String buffer,
      final String currentInput,
      final List<String> history,
      final bool isConnected,
      final int cols,
      final int rows,
      final String? cwd,
      final DateTime? createdAt}) = _$TerminalSessionImpl;

  factory _TerminalSession.fromJson(Map<String, dynamic> json) =
      _$TerminalSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get buffer;
  @override
  String get currentInput;
  @override
  List<String> get history;
  @override
  bool get isConnected;
  @override
  int get cols;
  @override
  int get rows;
  @override
  String? get cwd;
  @override
  DateTime? get createdAt;

  /// Create a copy of TerminalSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TerminalSessionImplCopyWith<_$TerminalSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TerminalOutput _$TerminalOutputFromJson(Map<String, dynamic> json) {
  return _TerminalOutput.fromJson(json);
}

/// @nodoc
mixin _$TerminalOutput {
  String get sessionId => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this TerminalOutput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TerminalOutput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TerminalOutputCopyWith<TerminalOutput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TerminalOutputCopyWith<$Res> {
  factory $TerminalOutputCopyWith(
          TerminalOutput value, $Res Function(TerminalOutput) then) =
      _$TerminalOutputCopyWithImpl<$Res, TerminalOutput>;
  @useResult
  $Res call({String sessionId, String data, DateTime? timestamp});
}

/// @nodoc
class _$TerminalOutputCopyWithImpl<$Res, $Val extends TerminalOutput>
    implements $TerminalOutputCopyWith<$Res> {
  _$TerminalOutputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TerminalOutput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? data = null,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TerminalOutputImplCopyWith<$Res>
    implements $TerminalOutputCopyWith<$Res> {
  factory _$$TerminalOutputImplCopyWith(_$TerminalOutputImpl value,
          $Res Function(_$TerminalOutputImpl) then) =
      __$$TerminalOutputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sessionId, String data, DateTime? timestamp});
}

/// @nodoc
class __$$TerminalOutputImplCopyWithImpl<$Res>
    extends _$TerminalOutputCopyWithImpl<$Res, _$TerminalOutputImpl>
    implements _$$TerminalOutputImplCopyWith<$Res> {
  __$$TerminalOutputImplCopyWithImpl(
      _$TerminalOutputImpl _value, $Res Function(_$TerminalOutputImpl) _then)
      : super(_value, _then);

  /// Create a copy of TerminalOutput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? data = null,
    Object? timestamp = freezed,
  }) {
    return _then(_$TerminalOutputImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TerminalOutputImpl implements _TerminalOutput {
  const _$TerminalOutputImpl(
      {required this.sessionId, required this.data, this.timestamp});

  factory _$TerminalOutputImpl.fromJson(Map<String, dynamic> json) =>
      _$$TerminalOutputImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String data;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'TerminalOutput(sessionId: $sessionId, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TerminalOutputImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, data, timestamp);

  /// Create a copy of TerminalOutput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TerminalOutputImplCopyWith<_$TerminalOutputImpl> get copyWith =>
      __$$TerminalOutputImplCopyWithImpl<_$TerminalOutputImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TerminalOutputImplToJson(
      this,
    );
  }
}

abstract class _TerminalOutput implements TerminalOutput {
  const factory _TerminalOutput(
      {required final String sessionId,
      required final String data,
      final DateTime? timestamp}) = _$TerminalOutputImpl;

  factory _TerminalOutput.fromJson(Map<String, dynamic> json) =
      _$TerminalOutputImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get data;
  @override
  DateTime? get timestamp;

  /// Create a copy of TerminalOutput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TerminalOutputImplCopyWith<_$TerminalOutputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
