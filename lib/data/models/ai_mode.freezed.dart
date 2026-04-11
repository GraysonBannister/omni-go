// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIMode _$AIModeFromJson(Map<String, dynamic> json) {
  return _AIMode.fromJson(json);
}

/// @nodoc
mixin _$AIMode {
  /// Unique identifier for the mode (code, architect, review, security, debug)
  String get id => throw _privateConstructorUsedError;

  /// Display name for the mode
  String get name => throw _privateConstructorUsedError;

  /// Short description of the mode's purpose
  String get description => throw _privateConstructorUsedError;

  /// Icon data for the mode
  @IconDataConverter()
  IconData get iconData => throw _privateConstructorUsedError;

  /// Primary color for the mode (matches omni-code-v2 colors)
  @ColorConverter()
  Color get color => throw _privateConstructorUsedError;

  /// Additional system prompt text appended for this mode
  String? get systemPromptAppend => throw _privateConstructorUsedError;

  /// List of tools to disable in this mode (empty means all tools enabled)
  List<String> get disabledTools => throw _privateConstructorUsedError;

  /// Temperature setting for this mode (null means use default)
  double? get temperature => throw _privateConstructorUsedError;

  /// Whether this mode uses plan mode
  bool get planMode => throw _privateConstructorUsedError;

  /// Serializes this AIMode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIMode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIModeCopyWith<AIMode> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIModeCopyWith<$Res> {
  factory $AIModeCopyWith(AIMode value, $Res Function(AIMode) then) =
      _$AIModeCopyWithImpl<$Res, AIMode>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      @IconDataConverter() IconData iconData,
      @ColorConverter() Color color,
      String? systemPromptAppend,
      List<String> disabledTools,
      double? temperature,
      bool planMode});
}

/// @nodoc
class _$AIModeCopyWithImpl<$Res, $Val extends AIMode>
    implements $AIModeCopyWith<$Res> {
  _$AIModeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIMode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconData = null,
    Object? color = null,
    Object? systemPromptAppend = freezed,
    Object? disabledTools = null,
    Object? temperature = freezed,
    Object? planMode = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconData: null == iconData
          ? _value.iconData
          : iconData // ignore: cast_nullable_to_non_nullable
              as IconData,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      systemPromptAppend: freezed == systemPromptAppend
          ? _value.systemPromptAppend
          : systemPromptAppend // ignore: cast_nullable_to_non_nullable
              as String?,
      disabledTools: null == disabledTools
          ? _value.disabledTools
          : disabledTools // ignore: cast_nullable_to_non_nullable
              as List<String>,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      planMode: null == planMode
          ? _value.planMode
          : planMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIModeImplCopyWith<$Res> implements $AIModeCopyWith<$Res> {
  factory _$$AIModeImplCopyWith(
          _$AIModeImpl value, $Res Function(_$AIModeImpl) then) =
      __$$AIModeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      @IconDataConverter() IconData iconData,
      @ColorConverter() Color color,
      String? systemPromptAppend,
      List<String> disabledTools,
      double? temperature,
      bool planMode});
}

/// @nodoc
class __$$AIModeImplCopyWithImpl<$Res>
    extends _$AIModeCopyWithImpl<$Res, _$AIModeImpl>
    implements _$$AIModeImplCopyWith<$Res> {
  __$$AIModeImplCopyWithImpl(
      _$AIModeImpl _value, $Res Function(_$AIModeImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIMode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconData = null,
    Object? color = null,
    Object? systemPromptAppend = freezed,
    Object? disabledTools = null,
    Object? temperature = freezed,
    Object? planMode = null,
  }) {
    return _then(_$AIModeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconData: null == iconData
          ? _value.iconData
          : iconData // ignore: cast_nullable_to_non_nullable
              as IconData,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      systemPromptAppend: freezed == systemPromptAppend
          ? _value.systemPromptAppend
          : systemPromptAppend // ignore: cast_nullable_to_non_nullable
              as String?,
      disabledTools: null == disabledTools
          ? _value._disabledTools
          : disabledTools // ignore: cast_nullable_to_non_nullable
              as List<String>,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      planMode: null == planMode
          ? _value.planMode
          : planMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIModeImpl extends _AIMode {
  const _$AIModeImpl(
      {required this.id,
      required this.name,
      required this.description,
      @IconDataConverter() required this.iconData,
      @ColorConverter() required this.color,
      this.systemPromptAppend,
      final List<String> disabledTools = const [],
      this.temperature,
      this.planMode = false})
      : _disabledTools = disabledTools,
        super._();

  factory _$AIModeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIModeImplFromJson(json);

  /// Unique identifier for the mode (code, architect, review, security, debug)
  @override
  final String id;

  /// Display name for the mode
  @override
  final String name;

  /// Short description of the mode's purpose
  @override
  final String description;

  /// Icon data for the mode
  @override
  @IconDataConverter()
  final IconData iconData;

  /// Primary color for the mode (matches omni-code-v2 colors)
  @override
  @ColorConverter()
  final Color color;

  /// Additional system prompt text appended for this mode
  @override
  final String? systemPromptAppend;

  /// List of tools to disable in this mode (empty means all tools enabled)
  final List<String> _disabledTools;

  /// List of tools to disable in this mode (empty means all tools enabled)
  @override
  @JsonKey()
  List<String> get disabledTools {
    if (_disabledTools is EqualUnmodifiableListView) return _disabledTools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disabledTools);
  }

  /// Temperature setting for this mode (null means use default)
  @override
  final double? temperature;

  /// Whether this mode uses plan mode
  @override
  @JsonKey()
  final bool planMode;

  @override
  String toString() {
    return 'AIMode(id: $id, name: $name, description: $description, iconData: $iconData, color: $color, systemPromptAppend: $systemPromptAppend, disabledTools: $disabledTools, temperature: $temperature, planMode: $planMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIModeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconData, iconData) ||
                other.iconData == iconData) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.systemPromptAppend, systemPromptAppend) ||
                other.systemPromptAppend == systemPromptAppend) &&
            const DeepCollectionEquality()
                .equals(other._disabledTools, _disabledTools) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.planMode, planMode) ||
                other.planMode == planMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      iconData,
      color,
      systemPromptAppend,
      const DeepCollectionEquality().hash(_disabledTools),
      temperature,
      planMode);

  /// Create a copy of AIMode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIModeImplCopyWith<_$AIModeImpl> get copyWith =>
      __$$AIModeImplCopyWithImpl<_$AIModeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIModeImplToJson(
      this,
    );
  }
}

abstract class _AIMode extends AIMode {
  const factory _AIMode(
      {required final String id,
      required final String name,
      required final String description,
      @IconDataConverter() required final IconData iconData,
      @ColorConverter() required final Color color,
      final String? systemPromptAppend,
      final List<String> disabledTools,
      final double? temperature,
      final bool planMode}) = _$AIModeImpl;
  const _AIMode._() : super._();

  factory _AIMode.fromJson(Map<String, dynamic> json) = _$AIModeImpl.fromJson;

  /// Unique identifier for the mode (code, architect, review, security, debug)
  @override
  String get id;

  /// Display name for the mode
  @override
  String get name;

  /// Short description of the mode's purpose
  @override
  String get description;

  /// Icon data for the mode
  @override
  @IconDataConverter()
  IconData get iconData;

  /// Primary color for the mode (matches omni-code-v2 colors)
  @override
  @ColorConverter()
  Color get color;

  /// Additional system prompt text appended for this mode
  @override
  String? get systemPromptAppend;

  /// List of tools to disable in this mode (empty means all tools enabled)
  @override
  List<String> get disabledTools;

  /// Temperature setting for this mode (null means use default)
  @override
  double? get temperature;

  /// Whether this mode uses plan mode
  @override
  bool get planMode;

  /// Create a copy of AIMode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIModeImplCopyWith<_$AIModeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
