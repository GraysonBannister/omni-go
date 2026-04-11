// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileItem _$FileItemFromJson(Map<String, dynamic> json) {
  return _FileItem.fromJson(json);
}

/// @nodoc
mixin _$FileItem {
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  FileItemType get type => throw _privateConstructorUsedError;
  List<FileItem> get children => throw _privateConstructorUsedError;
  bool get isExpanded => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;
  DateTime? get modifiedAt => throw _privateConstructorUsedError;

  /// Serializes this FileItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileItemCopyWith<FileItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileItemCopyWith<$Res> {
  factory $FileItemCopyWith(FileItem value, $Res Function(FileItem) then) =
      _$FileItemCopyWithImpl<$Res, FileItem>;
  @useResult
  $Res call(
      {String name,
      String path,
      FileItemType type,
      List<FileItem> children,
      bool isExpanded,
      bool isLoading,
      String? content,
      int? size,
      DateTime? modifiedAt});
}

/// @nodoc
class _$FileItemCopyWithImpl<$Res, $Val extends FileItem>
    implements $FileItemCopyWith<$Res> {
  _$FileItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? type = null,
    Object? children = null,
    Object? isExpanded = null,
    Object? isLoading = null,
    Object? content = freezed,
    Object? size = freezed,
    Object? modifiedAt = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FileItemType,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<FileItem>,
      isExpanded: null == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileItemImplCopyWith<$Res>
    implements $FileItemCopyWith<$Res> {
  factory _$$FileItemImplCopyWith(
          _$FileItemImpl value, $Res Function(_$FileItemImpl) then) =
      __$$FileItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String path,
      FileItemType type,
      List<FileItem> children,
      bool isExpanded,
      bool isLoading,
      String? content,
      int? size,
      DateTime? modifiedAt});
}

/// @nodoc
class __$$FileItemImplCopyWithImpl<$Res>
    extends _$FileItemCopyWithImpl<$Res, _$FileItemImpl>
    implements _$$FileItemImplCopyWith<$Res> {
  __$$FileItemImplCopyWithImpl(
      _$FileItemImpl _value, $Res Function(_$FileItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? type = null,
    Object? children = null,
    Object? isExpanded = null,
    Object? isLoading = null,
    Object? content = freezed,
    Object? size = freezed,
    Object? modifiedAt = freezed,
  }) {
    return _then(_$FileItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FileItemType,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<FileItem>,
      isExpanded: null == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileItemImpl extends _FileItem {
  const _$FileItemImpl(
      {required this.name,
      required this.path,
      required this.type,
      final List<FileItem> children = const [],
      this.isExpanded = false,
      this.isLoading = false,
      this.content,
      this.size,
      this.modifiedAt})
      : _children = children,
        super._();

  factory _$FileItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileItemImplFromJson(json);

  @override
  final String name;
  @override
  final String path;
  @override
  final FileItemType type;
  final List<FileItem> _children;
  @override
  @JsonKey()
  List<FileItem> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  @JsonKey()
  final bool isExpanded;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? content;
  @override
  final int? size;
  @override
  final DateTime? modifiedAt;

  @override
  String toString() {
    return 'FileItem(name: $name, path: $path, type: $type, children: $children, isExpanded: $isExpanded, isLoading: $isLoading, content: $content, size: $size, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.isExpanded, isExpanded) ||
                other.isExpanded == isExpanded) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      path,
      type,
      const DeepCollectionEquality().hash(_children),
      isExpanded,
      isLoading,
      content,
      size,
      modifiedAt);

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileItemImplCopyWith<_$FileItemImpl> get copyWith =>
      __$$FileItemImplCopyWithImpl<_$FileItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileItemImplToJson(
      this,
    );
  }
}

abstract class _FileItem extends FileItem {
  const factory _FileItem(
      {required final String name,
      required final String path,
      required final FileItemType type,
      final List<FileItem> children,
      final bool isExpanded,
      final bool isLoading,
      final String? content,
      final int? size,
      final DateTime? modifiedAt}) = _$FileItemImpl;
  const _FileItem._() : super._();

  factory _FileItem.fromJson(Map<String, dynamic> json) =
      _$FileItemImpl.fromJson;

  @override
  String get name;
  @override
  String get path;
  @override
  FileItemType get type;
  @override
  List<FileItem> get children;
  @override
  bool get isExpanded;
  @override
  bool get isLoading;
  @override
  String? get content;
  @override
  int? get size;
  @override
  DateTime? get modifiedAt;

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileItemImplCopyWith<_$FileItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FileEdit _$FileEditFromJson(Map<String, dynamic> json) {
  return _FileEdit.fromJson(json);
}

/// @nodoc
mixin _$FileEdit {
  String get path => throw _privateConstructorUsedError;
  String get oldString => throw _privateConstructorUsedError;
  String get newString => throw _privateConstructorUsedError;

  /// Serializes this FileEdit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileEdit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileEditCopyWith<FileEdit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileEditCopyWith<$Res> {
  factory $FileEditCopyWith(FileEdit value, $Res Function(FileEdit) then) =
      _$FileEditCopyWithImpl<$Res, FileEdit>;
  @useResult
  $Res call({String path, String oldString, String newString});
}

/// @nodoc
class _$FileEditCopyWithImpl<$Res, $Val extends FileEdit>
    implements $FileEditCopyWith<$Res> {
  _$FileEditCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileEdit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? oldString = null,
    Object? newString = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      oldString: null == oldString
          ? _value.oldString
          : oldString // ignore: cast_nullable_to_non_nullable
              as String,
      newString: null == newString
          ? _value.newString
          : newString // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileEditImplCopyWith<$Res>
    implements $FileEditCopyWith<$Res> {
  factory _$$FileEditImplCopyWith(
          _$FileEditImpl value, $Res Function(_$FileEditImpl) then) =
      __$$FileEditImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String oldString, String newString});
}

/// @nodoc
class __$$FileEditImplCopyWithImpl<$Res>
    extends _$FileEditCopyWithImpl<$Res, _$FileEditImpl>
    implements _$$FileEditImplCopyWith<$Res> {
  __$$FileEditImplCopyWithImpl(
      _$FileEditImpl _value, $Res Function(_$FileEditImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileEdit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? oldString = null,
    Object? newString = null,
  }) {
    return _then(_$FileEditImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      oldString: null == oldString
          ? _value.oldString
          : oldString // ignore: cast_nullable_to_non_nullable
              as String,
      newString: null == newString
          ? _value.newString
          : newString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileEditImpl implements _FileEdit {
  const _$FileEditImpl(
      {required this.path, required this.oldString, required this.newString});

  factory _$FileEditImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileEditImplFromJson(json);

  @override
  final String path;
  @override
  final String oldString;
  @override
  final String newString;

  @override
  String toString() {
    return 'FileEdit(path: $path, oldString: $oldString, newString: $newString)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileEditImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.oldString, oldString) ||
                other.oldString == oldString) &&
            (identical(other.newString, newString) ||
                other.newString == newString));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, path, oldString, newString);

  /// Create a copy of FileEdit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileEditImplCopyWith<_$FileEditImpl> get copyWith =>
      __$$FileEditImplCopyWithImpl<_$FileEditImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileEditImplToJson(
      this,
    );
  }
}

abstract class _FileEdit implements FileEdit {
  const factory _FileEdit(
      {required final String path,
      required final String oldString,
      required final String newString}) = _$FileEditImpl;

  factory _FileEdit.fromJson(Map<String, dynamic> json) =
      _$FileEditImpl.fromJson;

  @override
  String get path;
  @override
  String get oldString;
  @override
  String get newString;

  /// Create a copy of FileEdit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileEditImplCopyWith<_$FileEditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FileSearchResult _$FileSearchResultFromJson(Map<String, dynamic> json) {
  return _FileSearchResult.fromJson(json);
}

/// @nodoc
mixin _$FileSearchResult {
  String get path => throw _privateConstructorUsedError;
  int get lineNumber => throw _privateConstructorUsedError;
  String get preview => throw _privateConstructorUsedError;

  /// Serializes this FileSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileSearchResultCopyWith<FileSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileSearchResultCopyWith<$Res> {
  factory $FileSearchResultCopyWith(
          FileSearchResult value, $Res Function(FileSearchResult) then) =
      _$FileSearchResultCopyWithImpl<$Res, FileSearchResult>;
  @useResult
  $Res call({String path, int lineNumber, String preview});
}

/// @nodoc
class _$FileSearchResultCopyWithImpl<$Res, $Val extends FileSearchResult>
    implements $FileSearchResultCopyWith<$Res> {
  _$FileSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? lineNumber = null,
    Object? preview = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      lineNumber: null == lineNumber
          ? _value.lineNumber
          : lineNumber // ignore: cast_nullable_to_non_nullable
              as int,
      preview: null == preview
          ? _value.preview
          : preview // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileSearchResultImplCopyWith<$Res>
    implements $FileSearchResultCopyWith<$Res> {
  factory _$$FileSearchResultImplCopyWith(_$FileSearchResultImpl value,
          $Res Function(_$FileSearchResultImpl) then) =
      __$$FileSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, int lineNumber, String preview});
}

/// @nodoc
class __$$FileSearchResultImplCopyWithImpl<$Res>
    extends _$FileSearchResultCopyWithImpl<$Res, _$FileSearchResultImpl>
    implements _$$FileSearchResultImplCopyWith<$Res> {
  __$$FileSearchResultImplCopyWithImpl(_$FileSearchResultImpl _value,
      $Res Function(_$FileSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? lineNumber = null,
    Object? preview = null,
  }) {
    return _then(_$FileSearchResultImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      lineNumber: null == lineNumber
          ? _value.lineNumber
          : lineNumber // ignore: cast_nullable_to_non_nullable
              as int,
      preview: null == preview
          ? _value.preview
          : preview // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileSearchResultImpl implements _FileSearchResult {
  const _$FileSearchResultImpl(
      {required this.path, required this.lineNumber, required this.preview});

  factory _$FileSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileSearchResultImplFromJson(json);

  @override
  final String path;
  @override
  final int lineNumber;
  @override
  final String preview;

  @override
  String toString() {
    return 'FileSearchResult(path: $path, lineNumber: $lineNumber, preview: $preview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileSearchResultImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.lineNumber, lineNumber) ||
                other.lineNumber == lineNumber) &&
            (identical(other.preview, preview) || other.preview == preview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, path, lineNumber, preview);

  /// Create a copy of FileSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileSearchResultImplCopyWith<_$FileSearchResultImpl> get copyWith =>
      __$$FileSearchResultImplCopyWithImpl<_$FileSearchResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileSearchResultImplToJson(
      this,
    );
  }
}

abstract class _FileSearchResult implements FileSearchResult {
  const factory _FileSearchResult(
      {required final String path,
      required final int lineNumber,
      required final String preview}) = _$FileSearchResultImpl;

  factory _FileSearchResult.fromJson(Map<String, dynamic> json) =
      _$FileSearchResultImpl.fromJson;

  @override
  String get path;
  @override
  int get lineNumber;
  @override
  String get preview;

  /// Create a copy of FileSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileSearchResultImplCopyWith<_$FileSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
