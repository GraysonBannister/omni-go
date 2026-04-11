// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_manager_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TerminalManagerState {
  Map<String, TerminalSession> get terminals =>
      throw _privateConstructorUsedError;
  String? get activeTerminalId => throw _privateConstructorUsedError;
  int get terminalCounter => throw _privateConstructorUsedError;

  /// Create a copy of TerminalManagerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TerminalManagerStateCopyWith<TerminalManagerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TerminalManagerStateCopyWith<$Res> {
  factory $TerminalManagerStateCopyWith(TerminalManagerState value,
          $Res Function(TerminalManagerState) then) =
      _$TerminalManagerStateCopyWithImpl<$Res, TerminalManagerState>;
  @useResult
  $Res call(
      {Map<String, TerminalSession> terminals,
      String? activeTerminalId,
      int terminalCounter});
}

/// @nodoc
class _$TerminalManagerStateCopyWithImpl<$Res,
        $Val extends TerminalManagerState>
    implements $TerminalManagerStateCopyWith<$Res> {
  _$TerminalManagerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TerminalManagerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? terminals = null,
    Object? activeTerminalId = freezed,
    Object? terminalCounter = null,
  }) {
    return _then(_value.copyWith(
      terminals: null == terminals
          ? _value.terminals
          : terminals // ignore: cast_nullable_to_non_nullable
              as Map<String, TerminalSession>,
      activeTerminalId: freezed == activeTerminalId
          ? _value.activeTerminalId
          : activeTerminalId // ignore: cast_nullable_to_non_nullable
              as String?,
      terminalCounter: null == terminalCounter
          ? _value.terminalCounter
          : terminalCounter // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TerminalManagerStateImplCopyWith<$Res>
    implements $TerminalManagerStateCopyWith<$Res> {
  factory _$$TerminalManagerStateImplCopyWith(_$TerminalManagerStateImpl value,
          $Res Function(_$TerminalManagerStateImpl) then) =
      __$$TerminalManagerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, TerminalSession> terminals,
      String? activeTerminalId,
      int terminalCounter});
}

/// @nodoc
class __$$TerminalManagerStateImplCopyWithImpl<$Res>
    extends _$TerminalManagerStateCopyWithImpl<$Res, _$TerminalManagerStateImpl>
    implements _$$TerminalManagerStateImplCopyWith<$Res> {
  __$$TerminalManagerStateImplCopyWithImpl(_$TerminalManagerStateImpl _value,
      $Res Function(_$TerminalManagerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TerminalManagerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? terminals = null,
    Object? activeTerminalId = freezed,
    Object? terminalCounter = null,
  }) {
    return _then(_$TerminalManagerStateImpl(
      terminals: null == terminals
          ? _value._terminals
          : terminals // ignore: cast_nullable_to_non_nullable
              as Map<String, TerminalSession>,
      activeTerminalId: freezed == activeTerminalId
          ? _value.activeTerminalId
          : activeTerminalId // ignore: cast_nullable_to_non_nullable
              as String?,
      terminalCounter: null == terminalCounter
          ? _value.terminalCounter
          : terminalCounter // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TerminalManagerStateImpl
    with DiagnosticableTreeMixin
    implements _TerminalManagerState {
  const _$TerminalManagerStateImpl(
      {final Map<String, TerminalSession> terminals = const {},
      this.activeTerminalId,
      this.terminalCounter = 0})
      : _terminals = terminals;

  final Map<String, TerminalSession> _terminals;
  @override
  @JsonKey()
  Map<String, TerminalSession> get terminals {
    if (_terminals is EqualUnmodifiableMapView) return _terminals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_terminals);
  }

  @override
  final String? activeTerminalId;
  @override
  @JsonKey()
  final int terminalCounter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TerminalManagerState(terminals: $terminals, activeTerminalId: $activeTerminalId, terminalCounter: $terminalCounter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TerminalManagerState'))
      ..add(DiagnosticsProperty('terminals', terminals))
      ..add(DiagnosticsProperty('activeTerminalId', activeTerminalId))
      ..add(DiagnosticsProperty('terminalCounter', terminalCounter));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TerminalManagerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._terminals, _terminals) &&
            (identical(other.activeTerminalId, activeTerminalId) ||
                other.activeTerminalId == activeTerminalId) &&
            (identical(other.terminalCounter, terminalCounter) ||
                other.terminalCounter == terminalCounter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_terminals),
      activeTerminalId,
      terminalCounter);

  /// Create a copy of TerminalManagerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TerminalManagerStateImplCopyWith<_$TerminalManagerStateImpl>
      get copyWith =>
          __$$TerminalManagerStateImplCopyWithImpl<_$TerminalManagerStateImpl>(
              this, _$identity);
}

abstract class _TerminalManagerState implements TerminalManagerState {
  const factory _TerminalManagerState(
      {final Map<String, TerminalSession> terminals,
      final String? activeTerminalId,
      final int terminalCounter}) = _$TerminalManagerStateImpl;

  @override
  Map<String, TerminalSession> get terminals;
  @override
  String? get activeTerminalId;
  @override
  int get terminalCounter;

  /// Create a copy of TerminalManagerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TerminalManagerStateImplCopyWith<_$TerminalManagerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
