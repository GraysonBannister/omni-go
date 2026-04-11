// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIModel _$AIModelFromJson(Map<String, dynamic> json) {
  return _AIModel.fromJson(json);
}

/// @nodoc
mixin _$AIModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'available')
  bool get isAvailable => throw _privateConstructorUsedError;
  List<String>? get aliases => throw _privateConstructorUsedError;

  /// Serializes this AIModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIModelCopyWith<AIModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIModelCopyWith<$Res> {
  factory $AIModelCopyWith(AIModel value, $Res Function(AIModel) then) =
      _$AIModelCopyWithImpl<$Res, AIModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String provider,
      String? description,
      @JsonKey(name: 'available') bool isAvailable,
      List<String>? aliases});
}

/// @nodoc
class _$AIModelCopyWithImpl<$Res, $Val extends AIModel>
    implements $AIModelCopyWith<$Res> {
  _$AIModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? description = freezed,
    Object? isAvailable = null,
    Object? aliases = freezed,
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
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      aliases: freezed == aliases
          ? _value.aliases
          : aliases // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIModelImplCopyWith<$Res> implements $AIModelCopyWith<$Res> {
  factory _$$AIModelImplCopyWith(
          _$AIModelImpl value, $Res Function(_$AIModelImpl) then) =
      __$$AIModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String provider,
      String? description,
      @JsonKey(name: 'available') bool isAvailable,
      List<String>? aliases});
}

/// @nodoc
class __$$AIModelImplCopyWithImpl<$Res>
    extends _$AIModelCopyWithImpl<$Res, _$AIModelImpl>
    implements _$$AIModelImplCopyWith<$Res> {
  __$$AIModelImplCopyWithImpl(
      _$AIModelImpl _value, $Res Function(_$AIModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? description = freezed,
    Object? isAvailable = null,
    Object? aliases = freezed,
  }) {
    return _then(_$AIModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      aliases: freezed == aliases
          ? _value._aliases
          : aliases // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIModelImpl implements _AIModel {
  const _$AIModelImpl(
      {required this.id,
      required this.name,
      required this.provider,
      this.description,
      @JsonKey(name: 'available') this.isAvailable = true,
      final List<String>? aliases})
      : _aliases = aliases;

  factory _$AIModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String provider;
  @override
  final String? description;
  @override
  @JsonKey(name: 'available')
  final bool isAvailable;
  final List<String>? _aliases;
  @override
  List<String>? get aliases {
    final value = _aliases;
    if (value == null) return null;
    if (_aliases is EqualUnmodifiableListView) return _aliases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AIModel(id: $id, name: $name, provider: $provider, description: $description, isAvailable: $isAvailable, aliases: $aliases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality().equals(other._aliases, _aliases));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, provider, description,
      isAvailable, const DeepCollectionEquality().hash(_aliases));

  /// Create a copy of AIModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIModelImplCopyWith<_$AIModelImpl> get copyWith =>
      __$$AIModelImplCopyWithImpl<_$AIModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIModelImplToJson(
      this,
    );
  }
}

abstract class _AIModel implements AIModel {
  const factory _AIModel(
      {required final String id,
      required final String name,
      required final String provider,
      final String? description,
      @JsonKey(name: 'available') final bool isAvailable,
      final List<String>? aliases}) = _$AIModelImpl;

  factory _AIModel.fromJson(Map<String, dynamic> json) = _$AIModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get provider;
  @override
  String? get description;
  @override
  @JsonKey(name: 'available')
  bool get isAvailable;
  @override
  List<String>? get aliases;

  /// Create a copy of AIModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIModelImplCopyWith<_$AIModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIProvider _$AIProviderFromJson(Map<String, dynamic> json) {
  return _AIProvider.fromJson(json);
}

/// @nodoc
mixin _$AIProvider {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<AIModel> get models => throw _privateConstructorUsedError;
  @JsonKey(name: 'available')
  bool get isAvailable => throw _privateConstructorUsedError;

  /// Serializes this AIProvider to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIProvider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIProviderCopyWith<AIProvider> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIProviderCopyWith<$Res> {
  factory $AIProviderCopyWith(
          AIProvider value, $Res Function(AIProvider) then) =
      _$AIProviderCopyWithImpl<$Res, AIProvider>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<AIModel> models,
      @JsonKey(name: 'available') bool isAvailable});
}

/// @nodoc
class _$AIProviderCopyWithImpl<$Res, $Val extends AIProvider>
    implements $AIProviderCopyWith<$Res> {
  _$AIProviderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIProvider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? models = null,
    Object? isAvailable = null,
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
      models: null == models
          ? _value.models
          : models // ignore: cast_nullable_to_non_nullable
              as List<AIModel>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIProviderImplCopyWith<$Res>
    implements $AIProviderCopyWith<$Res> {
  factory _$$AIProviderImplCopyWith(
          _$AIProviderImpl value, $Res Function(_$AIProviderImpl) then) =
      __$$AIProviderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<AIModel> models,
      @JsonKey(name: 'available') bool isAvailable});
}

/// @nodoc
class __$$AIProviderImplCopyWithImpl<$Res>
    extends _$AIProviderCopyWithImpl<$Res, _$AIProviderImpl>
    implements _$$AIProviderImplCopyWith<$Res> {
  __$$AIProviderImplCopyWithImpl(
      _$AIProviderImpl _value, $Res Function(_$AIProviderImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIProvider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? models = null,
    Object? isAvailable = null,
  }) {
    return _then(_$AIProviderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      models: null == models
          ? _value._models
          : models // ignore: cast_nullable_to_non_nullable
              as List<AIModel>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIProviderImpl implements _AIProvider {
  const _$AIProviderImpl(
      {required this.id,
      required this.name,
      required final List<AIModel> models,
      @JsonKey(name: 'available') this.isAvailable = true})
      : _models = models;

  factory _$AIProviderImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIProviderImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<AIModel> _models;
  @override
  List<AIModel> get models {
    if (_models is EqualUnmodifiableListView) return _models;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_models);
  }

  @override
  @JsonKey(name: 'available')
  final bool isAvailable;

  @override
  String toString() {
    return 'AIProvider(id: $id, name: $name, models: $models, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIProviderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._models, _models) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(_models), isAvailable);

  /// Create a copy of AIProvider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIProviderImplCopyWith<_$AIProviderImpl> get copyWith =>
      __$$AIProviderImplCopyWithImpl<_$AIProviderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIProviderImplToJson(
      this,
    );
  }
}

abstract class _AIProvider implements AIProvider {
  const factory _AIProvider(
      {required final String id,
      required final String name,
      required final List<AIModel> models,
      @JsonKey(name: 'available') final bool isAvailable}) = _$AIProviderImpl;

  factory _AIProvider.fromJson(Map<String, dynamic> json) =
      _$AIProviderImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<AIModel> get models;
  @override
  @JsonKey(name: 'available')
  bool get isAvailable;

  /// Create a copy of AIProvider
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIProviderImplCopyWith<_$AIProviderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
