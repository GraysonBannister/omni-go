// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServerConfig _$ServerConfigFromJson(Map<String, dynamic> json) {
  return _ServerConfig.fromJson(json);
}

/// @nodoc
mixin _$ServerConfig {
  String get url => throw _privateConstructorUsedError;
  String get apiKey => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this ServerConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServerConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServerConfigCopyWith<ServerConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerConfigCopyWith<$Res> {
  factory $ServerConfigCopyWith(
          ServerConfig value, $Res Function(ServerConfig) then) =
      _$ServerConfigCopyWithImpl<$Res, ServerConfig>;
  @useResult
  $Res call(
      {String url,
      String apiKey,
      bool isConnected,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$ServerConfigCopyWithImpl<$Res, $Val extends ServerConfig>
    implements $ServerConfigCopyWith<$Res> {
  _$ServerConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServerConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? apiKey = null,
    Object? isConnected = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerConfigImplCopyWith<$Res>
    implements $ServerConfigCopyWith<$Res> {
  factory _$$ServerConfigImplCopyWith(
          _$ServerConfigImpl value, $Res Function(_$ServerConfigImpl) then) =
      __$$ServerConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      String apiKey,
      bool isConnected,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$ServerConfigImplCopyWithImpl<$Res>
    extends _$ServerConfigCopyWithImpl<$Res, _$ServerConfigImpl>
    implements _$$ServerConfigImplCopyWith<$Res> {
  __$$ServerConfigImplCopyWithImpl(
      _$ServerConfigImpl _value, $Res Function(_$ServerConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServerConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? apiKey = null,
    Object? isConnected = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$ServerConfigImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerConfigImpl implements _ServerConfig {
  const _$ServerConfigImpl(
      {this.url = '',
      this.apiKey = '',
      this.isConnected = false,
      this.isLoading = false,
      this.error});

  factory _$ServerConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerConfigImplFromJson(json);

  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final String apiKey;
  @override
  @JsonKey()
  final bool isConnected;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'ServerConfig(url: $url, apiKey: $apiKey, isConnected: $isConnected, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerConfigImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, url, apiKey, isConnected, isLoading, error);

  /// Create a copy of ServerConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerConfigImplCopyWith<_$ServerConfigImpl> get copyWith =>
      __$$ServerConfigImplCopyWithImpl<_$ServerConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerConfigImplToJson(
      this,
    );
  }
}

abstract class _ServerConfig implements ServerConfig {
  const factory _ServerConfig(
      {final String url,
      final String apiKey,
      final bool isConnected,
      final bool isLoading,
      final String? error}) = _$ServerConfigImpl;

  factory _ServerConfig.fromJson(Map<String, dynamic> json) =
      _$ServerConfigImpl.fromJson;

  @override
  String get url;
  @override
  String get apiKey;
  @override
  bool get isConnected;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of ServerConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerConfigImplCopyWith<_$ServerConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
