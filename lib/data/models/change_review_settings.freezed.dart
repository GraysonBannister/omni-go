// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_review_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChangeReviewSettings _$ChangeReviewSettingsFromJson(Map<String, dynamic> json) {
  return _ChangeReviewSettings.fromJson(json);
}

/// @nodoc
mixin _$ChangeReviewSettings {
  bool get enabled => throw _privateConstructorUsedError;
  ChangeReviewMode get mode => throw _privateConstructorUsedError;

  /// Serializes this ChangeReviewSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeReviewSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeReviewSettingsCopyWith<ChangeReviewSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeReviewSettingsCopyWith<$Res> {
  factory $ChangeReviewSettingsCopyWith(ChangeReviewSettings value,
          $Res Function(ChangeReviewSettings) then) =
      _$ChangeReviewSettingsCopyWithImpl<$Res, ChangeReviewSettings>;
  @useResult
  $Res call({bool enabled, ChangeReviewMode mode});
}

/// @nodoc
class _$ChangeReviewSettingsCopyWithImpl<$Res,
        $Val extends ChangeReviewSettings>
    implements $ChangeReviewSettingsCopyWith<$Res> {
  _$ChangeReviewSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangeReviewSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ChangeReviewMode,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeReviewSettingsImplCopyWith<$Res>
    implements $ChangeReviewSettingsCopyWith<$Res> {
  factory _$$ChangeReviewSettingsImplCopyWith(_$ChangeReviewSettingsImpl value,
          $Res Function(_$ChangeReviewSettingsImpl) then) =
      __$$ChangeReviewSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enabled, ChangeReviewMode mode});
}

/// @nodoc
class __$$ChangeReviewSettingsImplCopyWithImpl<$Res>
    extends _$ChangeReviewSettingsCopyWithImpl<$Res, _$ChangeReviewSettingsImpl>
    implements _$$ChangeReviewSettingsImplCopyWith<$Res> {
  __$$ChangeReviewSettingsImplCopyWithImpl(_$ChangeReviewSettingsImpl _value,
      $Res Function(_$ChangeReviewSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangeReviewSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
  }) {
    return _then(_$ChangeReviewSettingsImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ChangeReviewMode,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeReviewSettingsImpl implements _ChangeReviewSettings {
  const _$ChangeReviewSettingsImpl(
      {this.enabled = true, this.mode = ChangeReviewMode.all});

  factory _$ChangeReviewSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangeReviewSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final ChangeReviewMode mode;

  @override
  String toString() {
    return 'ChangeReviewSettings(enabled: $enabled, mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeReviewSettingsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, mode);

  /// Create a copy of ChangeReviewSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeReviewSettingsImplCopyWith<_$ChangeReviewSettingsImpl>
      get copyWith =>
          __$$ChangeReviewSettingsImplCopyWithImpl<_$ChangeReviewSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeReviewSettingsImplToJson(
      this,
    );
  }
}

abstract class _ChangeReviewSettings implements ChangeReviewSettings {
  const factory _ChangeReviewSettings(
      {final bool enabled,
      final ChangeReviewMode mode}) = _$ChangeReviewSettingsImpl;

  factory _ChangeReviewSettings.fromJson(Map<String, dynamic> json) =
      _$ChangeReviewSettingsImpl.fromJson;

  @override
  bool get enabled;
  @override
  ChangeReviewMode get mode;

  /// Create a copy of ChangeReviewSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeReviewSettingsImplCopyWith<_$ChangeReviewSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ChangeReviewStatusResponse _$ChangeReviewStatusResponseFromJson(
    Map<String, dynamic> json) {
  return _ChangeReviewStatusResponse.fromJson(json);
}

/// @nodoc
mixin _$ChangeReviewStatusResponse {
  bool get enabled => throw _privateConstructorUsedError;
  ChangeReviewMode get mode => throw _privateConstructorUsedError;

  /// Serializes this ChangeReviewStatusResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeReviewStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeReviewStatusResponseCopyWith<ChangeReviewStatusResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeReviewStatusResponseCopyWith<$Res> {
  factory $ChangeReviewStatusResponseCopyWith(ChangeReviewStatusResponse value,
          $Res Function(ChangeReviewStatusResponse) then) =
      _$ChangeReviewStatusResponseCopyWithImpl<$Res,
          ChangeReviewStatusResponse>;
  @useResult
  $Res call({bool enabled, ChangeReviewMode mode});
}

/// @nodoc
class _$ChangeReviewStatusResponseCopyWithImpl<$Res,
        $Val extends ChangeReviewStatusResponse>
    implements $ChangeReviewStatusResponseCopyWith<$Res> {
  _$ChangeReviewStatusResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangeReviewStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ChangeReviewMode,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeReviewStatusResponseImplCopyWith<$Res>
    implements $ChangeReviewStatusResponseCopyWith<$Res> {
  factory _$$ChangeReviewStatusResponseImplCopyWith(
          _$ChangeReviewStatusResponseImpl value,
          $Res Function(_$ChangeReviewStatusResponseImpl) then) =
      __$$ChangeReviewStatusResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enabled, ChangeReviewMode mode});
}

/// @nodoc
class __$$ChangeReviewStatusResponseImplCopyWithImpl<$Res>
    extends _$ChangeReviewStatusResponseCopyWithImpl<$Res,
        _$ChangeReviewStatusResponseImpl>
    implements _$$ChangeReviewStatusResponseImplCopyWith<$Res> {
  __$$ChangeReviewStatusResponseImplCopyWithImpl(
      _$ChangeReviewStatusResponseImpl _value,
      $Res Function(_$ChangeReviewStatusResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangeReviewStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
  }) {
    return _then(_$ChangeReviewStatusResponseImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ChangeReviewMode,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeReviewStatusResponseImpl implements _ChangeReviewStatusResponse {
  const _$ChangeReviewStatusResponseImpl(
      {required this.enabled, this.mode = ChangeReviewMode.all});

  factory _$ChangeReviewStatusResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ChangeReviewStatusResponseImplFromJson(json);

  @override
  final bool enabled;
  @override
  @JsonKey()
  final ChangeReviewMode mode;

  @override
  String toString() {
    return 'ChangeReviewStatusResponse(enabled: $enabled, mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeReviewStatusResponseImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, mode);

  /// Create a copy of ChangeReviewStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeReviewStatusResponseImplCopyWith<_$ChangeReviewStatusResponseImpl>
      get copyWith => __$$ChangeReviewStatusResponseImplCopyWithImpl<
          _$ChangeReviewStatusResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeReviewStatusResponseImplToJson(
      this,
    );
  }
}

abstract class _ChangeReviewStatusResponse
    implements ChangeReviewStatusResponse {
  const factory _ChangeReviewStatusResponse(
      {required final bool enabled,
      final ChangeReviewMode mode}) = _$ChangeReviewStatusResponseImpl;

  factory _ChangeReviewStatusResponse.fromJson(Map<String, dynamic> json) =
      _$ChangeReviewStatusResponseImpl.fromJson;

  @override
  bool get enabled;
  @override
  ChangeReviewMode get mode;

  /// Create a copy of ChangeReviewStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeReviewStatusResponseImplCopyWith<_$ChangeReviewStatusResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
