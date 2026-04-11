// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Workspace _$WorkspaceFromJson(Map<String, dynamic> json) {
  return _Workspace.fromJson(json);
}

/// @nodoc
mixin _$Workspace {
  String get sharedId => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get folderCount => throw _privateConstructorUsedError;
  List<WorkspaceFolder> get folders => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isSingleFolder => throw _privateConstructorUsedError;
  int? get addedAt => throw _privateConstructorUsedError;

  /// Serializes this Workspace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceCopyWith<Workspace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceCopyWith<$Res> {
  factory $WorkspaceCopyWith(Workspace value, $Res Function(Workspace) then) =
      _$WorkspaceCopyWithImpl<$Res, Workspace>;
  @useResult
  $Res call(
      {String sharedId,
      String workspaceId,
      String name,
      int folderCount,
      List<WorkspaceFolder> folders,
      bool isActive,
      bool isSingleFolder,
      int? addedAt});
}

/// @nodoc
class _$WorkspaceCopyWithImpl<$Res, $Val extends Workspace>
    implements $WorkspaceCopyWith<$Res> {
  _$WorkspaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedId = null,
    Object? workspaceId = null,
    Object? name = null,
    Object? folderCount = null,
    Object? folders = null,
    Object? isActive = null,
    Object? isSingleFolder = null,
    Object? addedAt = freezed,
  }) {
    return _then(_value.copyWith(
      sharedId: null == sharedId
          ? _value.sharedId
          : sharedId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      folderCount: null == folderCount
          ? _value.folderCount
          : folderCount // ignore: cast_nullable_to_non_nullable
              as int,
      folders: null == folders
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<WorkspaceFolder>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSingleFolder: null == isSingleFolder
          ? _value.isSingleFolder
          : isSingleFolder // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkspaceImplCopyWith<$Res>
    implements $WorkspaceCopyWith<$Res> {
  factory _$$WorkspaceImplCopyWith(
          _$WorkspaceImpl value, $Res Function(_$WorkspaceImpl) then) =
      __$$WorkspaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sharedId,
      String workspaceId,
      String name,
      int folderCount,
      List<WorkspaceFolder> folders,
      bool isActive,
      bool isSingleFolder,
      int? addedAt});
}

/// @nodoc
class __$$WorkspaceImplCopyWithImpl<$Res>
    extends _$WorkspaceCopyWithImpl<$Res, _$WorkspaceImpl>
    implements _$$WorkspaceImplCopyWith<$Res> {
  __$$WorkspaceImplCopyWithImpl(
      _$WorkspaceImpl _value, $Res Function(_$WorkspaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedId = null,
    Object? workspaceId = null,
    Object? name = null,
    Object? folderCount = null,
    Object? folders = null,
    Object? isActive = null,
    Object? isSingleFolder = null,
    Object? addedAt = freezed,
  }) {
    return _then(_$WorkspaceImpl(
      sharedId: null == sharedId
          ? _value.sharedId
          : sharedId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      folderCount: null == folderCount
          ? _value.folderCount
          : folderCount // ignore: cast_nullable_to_non_nullable
              as int,
      folders: null == folders
          ? _value._folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<WorkspaceFolder>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSingleFolder: null == isSingleFolder
          ? _value.isSingleFolder
          : isSingleFolder // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceImpl extends _Workspace {
  const _$WorkspaceImpl(
      {required this.sharedId,
      required this.workspaceId,
      required this.name,
      required this.folderCount,
      final List<WorkspaceFolder> folders = const [],
      this.isActive = false,
      this.isSingleFolder = false,
      this.addedAt})
      : _folders = folders,
        super._();

  factory _$WorkspaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceImplFromJson(json);

  @override
  final String sharedId;
  @override
  final String workspaceId;
  @override
  final String name;
  @override
  final int folderCount;
  final List<WorkspaceFolder> _folders;
  @override
  @JsonKey()
  List<WorkspaceFolder> get folders {
    if (_folders is EqualUnmodifiableListView) return _folders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isSingleFolder;
  @override
  final int? addedAt;

  @override
  String toString() {
    return 'Workspace(sharedId: $sharedId, workspaceId: $workspaceId, name: $name, folderCount: $folderCount, folders: $folders, isActive: $isActive, isSingleFolder: $isSingleFolder, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceImpl &&
            (identical(other.sharedId, sharedId) ||
                other.sharedId == sharedId) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.folderCount, folderCount) ||
                other.folderCount == folderCount) &&
            const DeepCollectionEquality().equals(other._folders, _folders) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSingleFolder, isSingleFolder) ||
                other.isSingleFolder == isSingleFolder) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sharedId,
      workspaceId,
      name,
      folderCount,
      const DeepCollectionEquality().hash(_folders),
      isActive,
      isSingleFolder,
      addedAt);

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceImplCopyWith<_$WorkspaceImpl> get copyWith =>
      __$$WorkspaceImplCopyWithImpl<_$WorkspaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceImplToJson(
      this,
    );
  }
}

abstract class _Workspace extends Workspace {
  const factory _Workspace(
      {required final String sharedId,
      required final String workspaceId,
      required final String name,
      required final int folderCount,
      final List<WorkspaceFolder> folders,
      final bool isActive,
      final bool isSingleFolder,
      final int? addedAt}) = _$WorkspaceImpl;
  const _Workspace._() : super._();

  factory _Workspace.fromJson(Map<String, dynamic> json) =
      _$WorkspaceImpl.fromJson;

  @override
  String get sharedId;
  @override
  String get workspaceId;
  @override
  String get name;
  @override
  int get folderCount;
  @override
  List<WorkspaceFolder> get folders;
  @override
  bool get isActive;
  @override
  bool get isSingleFolder;
  @override
  int? get addedAt;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceImplCopyWith<_$WorkspaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceFolder _$WorkspaceFolderFromJson(Map<String, dynamic> json) {
  return _WorkspaceFolder.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceFolder {
  String get id => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceFolder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceFolder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceFolderCopyWith<WorkspaceFolder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceFolderCopyWith<$Res> {
  factory $WorkspaceFolderCopyWith(
          WorkspaceFolder value, $Res Function(WorkspaceFolder) then) =
      _$WorkspaceFolderCopyWithImpl<$Res, WorkspaceFolder>;
  @useResult
  $Res call({String id, String path, String name});
}

/// @nodoc
class _$WorkspaceFolderCopyWithImpl<$Res, $Val extends WorkspaceFolder>
    implements $WorkspaceFolderCopyWith<$Res> {
  _$WorkspaceFolderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceFolder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkspaceFolderImplCopyWith<$Res>
    implements $WorkspaceFolderCopyWith<$Res> {
  factory _$$WorkspaceFolderImplCopyWith(_$WorkspaceFolderImpl value,
          $Res Function(_$WorkspaceFolderImpl) then) =
      __$$WorkspaceFolderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String path, String name});
}

/// @nodoc
class __$$WorkspaceFolderImplCopyWithImpl<$Res>
    extends _$WorkspaceFolderCopyWithImpl<$Res, _$WorkspaceFolderImpl>
    implements _$$WorkspaceFolderImplCopyWith<$Res> {
  __$$WorkspaceFolderImplCopyWithImpl(
      _$WorkspaceFolderImpl _value, $Res Function(_$WorkspaceFolderImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkspaceFolder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
  }) {
    return _then(_$WorkspaceFolderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceFolderImpl implements _WorkspaceFolder {
  const _$WorkspaceFolderImpl(
      {required this.id, required this.path, required this.name});

  factory _$WorkspaceFolderImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceFolderImplFromJson(json);

  @override
  final String id;
  @override
  final String path;
  @override
  final String name;

  @override
  String toString() {
    return 'WorkspaceFolder(id: $id, path: $path, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceFolderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, path, name);

  /// Create a copy of WorkspaceFolder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceFolderImplCopyWith<_$WorkspaceFolderImpl> get copyWith =>
      __$$WorkspaceFolderImplCopyWithImpl<_$WorkspaceFolderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceFolderImplToJson(
      this,
    );
  }
}

abstract class _WorkspaceFolder implements WorkspaceFolder {
  const factory _WorkspaceFolder(
      {required final String id,
      required final String path,
      required final String name}) = _$WorkspaceFolderImpl;

  factory _WorkspaceFolder.fromJson(Map<String, dynamic> json) =
      _$WorkspaceFolderImpl.fromJson;

  @override
  String get id;
  @override
  String get path;
  @override
  String get name;

  /// Create a copy of WorkspaceFolder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceFolderImplCopyWith<_$WorkspaceFolderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspacesResponse _$WorkspacesResponseFromJson(Map<String, dynamic> json) {
  return _WorkspacesResponse.fromJson(json);
}

/// @nodoc
mixin _$WorkspacesResponse {
  List<Workspace> get workspaces => throw _privateConstructorUsedError;
  String? get activeWorkspaceId => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this WorkspacesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspacesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspacesResponseCopyWith<WorkspacesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspacesResponseCopyWith<$Res> {
  factory $WorkspacesResponseCopyWith(
          WorkspacesResponse value, $Res Function(WorkspacesResponse) then) =
      _$WorkspacesResponseCopyWithImpl<$Res, WorkspacesResponse>;
  @useResult
  $Res call({List<Workspace> workspaces, String? activeWorkspaceId, int count});
}

/// @nodoc
class _$WorkspacesResponseCopyWithImpl<$Res, $Val extends WorkspacesResponse>
    implements $WorkspacesResponseCopyWith<$Res> {
  _$WorkspacesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspacesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaces = null,
    Object? activeWorkspaceId = freezed,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      workspaces: null == workspaces
          ? _value.workspaces
          : workspaces // ignore: cast_nullable_to_non_nullable
              as List<Workspace>,
      activeWorkspaceId: freezed == activeWorkspaceId
          ? _value.activeWorkspaceId
          : activeWorkspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkspacesResponseImplCopyWith<$Res>
    implements $WorkspacesResponseCopyWith<$Res> {
  factory _$$WorkspacesResponseImplCopyWith(_$WorkspacesResponseImpl value,
          $Res Function(_$WorkspacesResponseImpl) then) =
      __$$WorkspacesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Workspace> workspaces, String? activeWorkspaceId, int count});
}

/// @nodoc
class __$$WorkspacesResponseImplCopyWithImpl<$Res>
    extends _$WorkspacesResponseCopyWithImpl<$Res, _$WorkspacesResponseImpl>
    implements _$$WorkspacesResponseImplCopyWith<$Res> {
  __$$WorkspacesResponseImplCopyWithImpl(_$WorkspacesResponseImpl _value,
      $Res Function(_$WorkspacesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkspacesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaces = null,
    Object? activeWorkspaceId = freezed,
    Object? count = null,
  }) {
    return _then(_$WorkspacesResponseImpl(
      workspaces: null == workspaces
          ? _value._workspaces
          : workspaces // ignore: cast_nullable_to_non_nullable
              as List<Workspace>,
      activeWorkspaceId: freezed == activeWorkspaceId
          ? _value.activeWorkspaceId
          : activeWorkspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspacesResponseImpl implements _WorkspacesResponse {
  const _$WorkspacesResponseImpl(
      {required final List<Workspace> workspaces,
      this.activeWorkspaceId,
      required this.count})
      : _workspaces = workspaces;

  factory _$WorkspacesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspacesResponseImplFromJson(json);

  final List<Workspace> _workspaces;
  @override
  List<Workspace> get workspaces {
    if (_workspaces is EqualUnmodifiableListView) return _workspaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workspaces);
  }

  @override
  final String? activeWorkspaceId;
  @override
  final int count;

  @override
  String toString() {
    return 'WorkspacesResponse(workspaces: $workspaces, activeWorkspaceId: $activeWorkspaceId, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspacesResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._workspaces, _workspaces) &&
            (identical(other.activeWorkspaceId, activeWorkspaceId) ||
                other.activeWorkspaceId == activeWorkspaceId) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workspaces),
      activeWorkspaceId,
      count);

  /// Create a copy of WorkspacesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspacesResponseImplCopyWith<_$WorkspacesResponseImpl> get copyWith =>
      __$$WorkspacesResponseImplCopyWithImpl<_$WorkspacesResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspacesResponseImplToJson(
      this,
    );
  }
}

abstract class _WorkspacesResponse implements WorkspacesResponse {
  const factory _WorkspacesResponse(
      {required final List<Workspace> workspaces,
      final String? activeWorkspaceId,
      required final int count}) = _$WorkspacesResponseImpl;

  factory _WorkspacesResponse.fromJson(Map<String, dynamic> json) =
      _$WorkspacesResponseImpl.fromJson;

  @override
  List<Workspace> get workspaces;
  @override
  String? get activeWorkspaceId;
  @override
  int get count;

  /// Create a copy of WorkspacesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspacesResponseImplCopyWith<_$WorkspacesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActiveWorkspaceResponse _$ActiveWorkspaceResponseFromJson(
    Map<String, dynamic> json) {
  return _ActiveWorkspaceResponse.fromJson(json);
}

/// @nodoc
mixin _$ActiveWorkspaceResponse {
  Workspace? get activeWorkspace => throw _privateConstructorUsedError;
  String? get workingDirectory => throw _privateConstructorUsedError;

  /// Serializes this ActiveWorkspaceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveWorkspaceResponseCopyWith<ActiveWorkspaceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveWorkspaceResponseCopyWith<$Res> {
  factory $ActiveWorkspaceResponseCopyWith(ActiveWorkspaceResponse value,
          $Res Function(ActiveWorkspaceResponse) then) =
      _$ActiveWorkspaceResponseCopyWithImpl<$Res, ActiveWorkspaceResponse>;
  @useResult
  $Res call({Workspace? activeWorkspace, String? workingDirectory});

  $WorkspaceCopyWith<$Res>? get activeWorkspace;
}

/// @nodoc
class _$ActiveWorkspaceResponseCopyWithImpl<$Res,
        $Val extends ActiveWorkspaceResponse>
    implements $ActiveWorkspaceResponseCopyWith<$Res> {
  _$ActiveWorkspaceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeWorkspace = freezed,
    Object? workingDirectory = freezed,
  }) {
    return _then(_value.copyWith(
      activeWorkspace: freezed == activeWorkspace
          ? _value.activeWorkspace
          : activeWorkspace // ignore: cast_nullable_to_non_nullable
              as Workspace?,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ActiveWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkspaceCopyWith<$Res>? get activeWorkspace {
    if (_value.activeWorkspace == null) {
      return null;
    }

    return $WorkspaceCopyWith<$Res>(_value.activeWorkspace!, (value) {
      return _then(_value.copyWith(activeWorkspace: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActiveWorkspaceResponseImplCopyWith<$Res>
    implements $ActiveWorkspaceResponseCopyWith<$Res> {
  factory _$$ActiveWorkspaceResponseImplCopyWith(
          _$ActiveWorkspaceResponseImpl value,
          $Res Function(_$ActiveWorkspaceResponseImpl) then) =
      __$$ActiveWorkspaceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Workspace? activeWorkspace, String? workingDirectory});

  @override
  $WorkspaceCopyWith<$Res>? get activeWorkspace;
}

/// @nodoc
class __$$ActiveWorkspaceResponseImplCopyWithImpl<$Res>
    extends _$ActiveWorkspaceResponseCopyWithImpl<$Res,
        _$ActiveWorkspaceResponseImpl>
    implements _$$ActiveWorkspaceResponseImplCopyWith<$Res> {
  __$$ActiveWorkspaceResponseImplCopyWithImpl(
      _$ActiveWorkspaceResponseImpl _value,
      $Res Function(_$ActiveWorkspaceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeWorkspace = freezed,
    Object? workingDirectory = freezed,
  }) {
    return _then(_$ActiveWorkspaceResponseImpl(
      activeWorkspace: freezed == activeWorkspace
          ? _value.activeWorkspace
          : activeWorkspace // ignore: cast_nullable_to_non_nullable
              as Workspace?,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActiveWorkspaceResponseImpl implements _ActiveWorkspaceResponse {
  const _$ActiveWorkspaceResponseImpl(
      {this.activeWorkspace, this.workingDirectory});

  factory _$ActiveWorkspaceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveWorkspaceResponseImplFromJson(json);

  @override
  final Workspace? activeWorkspace;
  @override
  final String? workingDirectory;

  @override
  String toString() {
    return 'ActiveWorkspaceResponse(activeWorkspace: $activeWorkspace, workingDirectory: $workingDirectory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveWorkspaceResponseImpl &&
            (identical(other.activeWorkspace, activeWorkspace) ||
                other.activeWorkspace == activeWorkspace) &&
            (identical(other.workingDirectory, workingDirectory) ||
                other.workingDirectory == workingDirectory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, activeWorkspace, workingDirectory);

  /// Create a copy of ActiveWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveWorkspaceResponseImplCopyWith<_$ActiveWorkspaceResponseImpl>
      get copyWith => __$$ActiveWorkspaceResponseImplCopyWithImpl<
          _$ActiveWorkspaceResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveWorkspaceResponseImplToJson(
      this,
    );
  }
}

abstract class _ActiveWorkspaceResponse implements ActiveWorkspaceResponse {
  const factory _ActiveWorkspaceResponse(
      {final Workspace? activeWorkspace,
      final String? workingDirectory}) = _$ActiveWorkspaceResponseImpl;

  factory _ActiveWorkspaceResponse.fromJson(Map<String, dynamic> json) =
      _$ActiveWorkspaceResponseImpl.fromJson;

  @override
  Workspace? get activeWorkspace;
  @override
  String? get workingDirectory;

  /// Create a copy of ActiveWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveWorkspaceResponseImplCopyWith<_$ActiveWorkspaceResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SwitchWorkspaceResponse _$SwitchWorkspaceResponseFromJson(
    Map<String, dynamic> json) {
  return _SwitchWorkspaceResponse.fromJson(json);
}

/// @nodoc
mixin _$SwitchWorkspaceResponse {
  bool get success => throw _privateConstructorUsedError;
  ActiveWorkspaceInfo? get activeWorkspace =>
      throw _privateConstructorUsedError;

  /// Serializes this SwitchWorkspaceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwitchWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwitchWorkspaceResponseCopyWith<SwitchWorkspaceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwitchWorkspaceResponseCopyWith<$Res> {
  factory $SwitchWorkspaceResponseCopyWith(SwitchWorkspaceResponse value,
          $Res Function(SwitchWorkspaceResponse) then) =
      _$SwitchWorkspaceResponseCopyWithImpl<$Res, SwitchWorkspaceResponse>;
  @useResult
  $Res call({bool success, ActiveWorkspaceInfo? activeWorkspace});

  $ActiveWorkspaceInfoCopyWith<$Res>? get activeWorkspace;
}

/// @nodoc
class _$SwitchWorkspaceResponseCopyWithImpl<$Res,
        $Val extends SwitchWorkspaceResponse>
    implements $SwitchWorkspaceResponseCopyWith<$Res> {
  _$SwitchWorkspaceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwitchWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? activeWorkspace = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      activeWorkspace: freezed == activeWorkspace
          ? _value.activeWorkspace
          : activeWorkspace // ignore: cast_nullable_to_non_nullable
              as ActiveWorkspaceInfo?,
    ) as $Val);
  }

  /// Create a copy of SwitchWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActiveWorkspaceInfoCopyWith<$Res>? get activeWorkspace {
    if (_value.activeWorkspace == null) {
      return null;
    }

    return $ActiveWorkspaceInfoCopyWith<$Res>(_value.activeWorkspace!, (value) {
      return _then(_value.copyWith(activeWorkspace: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SwitchWorkspaceResponseImplCopyWith<$Res>
    implements $SwitchWorkspaceResponseCopyWith<$Res> {
  factory _$$SwitchWorkspaceResponseImplCopyWith(
          _$SwitchWorkspaceResponseImpl value,
          $Res Function(_$SwitchWorkspaceResponseImpl) then) =
      __$$SwitchWorkspaceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, ActiveWorkspaceInfo? activeWorkspace});

  @override
  $ActiveWorkspaceInfoCopyWith<$Res>? get activeWorkspace;
}

/// @nodoc
class __$$SwitchWorkspaceResponseImplCopyWithImpl<$Res>
    extends _$SwitchWorkspaceResponseCopyWithImpl<$Res,
        _$SwitchWorkspaceResponseImpl>
    implements _$$SwitchWorkspaceResponseImplCopyWith<$Res> {
  __$$SwitchWorkspaceResponseImplCopyWithImpl(
      _$SwitchWorkspaceResponseImpl _value,
      $Res Function(_$SwitchWorkspaceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwitchWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? activeWorkspace = freezed,
  }) {
    return _then(_$SwitchWorkspaceResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      activeWorkspace: freezed == activeWorkspace
          ? _value.activeWorkspace
          : activeWorkspace // ignore: cast_nullable_to_non_nullable
              as ActiveWorkspaceInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwitchWorkspaceResponseImpl implements _SwitchWorkspaceResponse {
  const _$SwitchWorkspaceResponseImpl(
      {required this.success, this.activeWorkspace});

  factory _$SwitchWorkspaceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwitchWorkspaceResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final ActiveWorkspaceInfo? activeWorkspace;

  @override
  String toString() {
    return 'SwitchWorkspaceResponse(success: $success, activeWorkspace: $activeWorkspace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwitchWorkspaceResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.activeWorkspace, activeWorkspace) ||
                other.activeWorkspace == activeWorkspace));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, activeWorkspace);

  /// Create a copy of SwitchWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwitchWorkspaceResponseImplCopyWith<_$SwitchWorkspaceResponseImpl>
      get copyWith => __$$SwitchWorkspaceResponseImplCopyWithImpl<
          _$SwitchWorkspaceResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwitchWorkspaceResponseImplToJson(
      this,
    );
  }
}

abstract class _SwitchWorkspaceResponse implements SwitchWorkspaceResponse {
  const factory _SwitchWorkspaceResponse(
          {required final bool success,
          final ActiveWorkspaceInfo? activeWorkspace}) =
      _$SwitchWorkspaceResponseImpl;

  factory _SwitchWorkspaceResponse.fromJson(Map<String, dynamic> json) =
      _$SwitchWorkspaceResponseImpl.fromJson;

  @override
  bool get success;
  @override
  ActiveWorkspaceInfo? get activeWorkspace;

  /// Create a copy of SwitchWorkspaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwitchWorkspaceResponseImplCopyWith<_$SwitchWorkspaceResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActiveWorkspaceInfo _$ActiveWorkspaceInfoFromJson(Map<String, dynamic> json) {
  return _ActiveWorkspaceInfo.fromJson(json);
}

/// @nodoc
mixin _$ActiveWorkspaceInfo {
  String get sharedId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get workingDirectory => throw _privateConstructorUsedError;

  /// Serializes this ActiveWorkspaceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveWorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveWorkspaceInfoCopyWith<ActiveWorkspaceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveWorkspaceInfoCopyWith<$Res> {
  factory $ActiveWorkspaceInfoCopyWith(
          ActiveWorkspaceInfo value, $Res Function(ActiveWorkspaceInfo) then) =
      _$ActiveWorkspaceInfoCopyWithImpl<$Res, ActiveWorkspaceInfo>;
  @useResult
  $Res call({String sharedId, String name, String? workingDirectory});
}

/// @nodoc
class _$ActiveWorkspaceInfoCopyWithImpl<$Res, $Val extends ActiveWorkspaceInfo>
    implements $ActiveWorkspaceInfoCopyWith<$Res> {
  _$ActiveWorkspaceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveWorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedId = null,
    Object? name = null,
    Object? workingDirectory = freezed,
  }) {
    return _then(_value.copyWith(
      sharedId: null == sharedId
          ? _value.sharedId
          : sharedId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActiveWorkspaceInfoImplCopyWith<$Res>
    implements $ActiveWorkspaceInfoCopyWith<$Res> {
  factory _$$ActiveWorkspaceInfoImplCopyWith(_$ActiveWorkspaceInfoImpl value,
          $Res Function(_$ActiveWorkspaceInfoImpl) then) =
      __$$ActiveWorkspaceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sharedId, String name, String? workingDirectory});
}

/// @nodoc
class __$$ActiveWorkspaceInfoImplCopyWithImpl<$Res>
    extends _$ActiveWorkspaceInfoCopyWithImpl<$Res, _$ActiveWorkspaceInfoImpl>
    implements _$$ActiveWorkspaceInfoImplCopyWith<$Res> {
  __$$ActiveWorkspaceInfoImplCopyWithImpl(_$ActiveWorkspaceInfoImpl _value,
      $Res Function(_$ActiveWorkspaceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveWorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedId = null,
    Object? name = null,
    Object? workingDirectory = freezed,
  }) {
    return _then(_$ActiveWorkspaceInfoImpl(
      sharedId: null == sharedId
          ? _value.sharedId
          : sharedId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActiveWorkspaceInfoImpl implements _ActiveWorkspaceInfo {
  const _$ActiveWorkspaceInfoImpl(
      {required this.sharedId, required this.name, this.workingDirectory});

  factory _$ActiveWorkspaceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveWorkspaceInfoImplFromJson(json);

  @override
  final String sharedId;
  @override
  final String name;
  @override
  final String? workingDirectory;

  @override
  String toString() {
    return 'ActiveWorkspaceInfo(sharedId: $sharedId, name: $name, workingDirectory: $workingDirectory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveWorkspaceInfoImpl &&
            (identical(other.sharedId, sharedId) ||
                other.sharedId == sharedId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.workingDirectory, workingDirectory) ||
                other.workingDirectory == workingDirectory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sharedId, name, workingDirectory);

  /// Create a copy of ActiveWorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveWorkspaceInfoImplCopyWith<_$ActiveWorkspaceInfoImpl> get copyWith =>
      __$$ActiveWorkspaceInfoImplCopyWithImpl<_$ActiveWorkspaceInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveWorkspaceInfoImplToJson(
      this,
    );
  }
}

abstract class _ActiveWorkspaceInfo implements ActiveWorkspaceInfo {
  const factory _ActiveWorkspaceInfo(
      {required final String sharedId,
      required final String name,
      final String? workingDirectory}) = _$ActiveWorkspaceInfoImpl;

  factory _ActiveWorkspaceInfo.fromJson(Map<String, dynamic> json) =
      _$ActiveWorkspaceInfoImpl.fromJson;

  @override
  String get sharedId;
  @override
  String get name;
  @override
  String? get workingDirectory;

  /// Create a copy of ActiveWorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveWorkspaceInfoImplCopyWith<_$ActiveWorkspaceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceFoldersResponse _$WorkspaceFoldersResponseFromJson(
    Map<String, dynamic> json) {
  return _WorkspaceFoldersResponse.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceFoldersResponse {
  String get sharedId => throw _privateConstructorUsedError;
  List<WorkspaceFolder> get folders => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceFoldersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceFoldersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceFoldersResponseCopyWith<WorkspaceFoldersResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceFoldersResponseCopyWith<$Res> {
  factory $WorkspaceFoldersResponseCopyWith(WorkspaceFoldersResponse value,
          $Res Function(WorkspaceFoldersResponse) then) =
      _$WorkspaceFoldersResponseCopyWithImpl<$Res, WorkspaceFoldersResponse>;
  @useResult
  $Res call({String sharedId, List<WorkspaceFolder> folders, int count});
}

/// @nodoc
class _$WorkspaceFoldersResponseCopyWithImpl<$Res,
        $Val extends WorkspaceFoldersResponse>
    implements $WorkspaceFoldersResponseCopyWith<$Res> {
  _$WorkspaceFoldersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceFoldersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedId = null,
    Object? folders = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      sharedId: null == sharedId
          ? _value.sharedId
          : sharedId // ignore: cast_nullable_to_non_nullable
              as String,
      folders: null == folders
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<WorkspaceFolder>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkspaceFoldersResponseImplCopyWith<$Res>
    implements $WorkspaceFoldersResponseCopyWith<$Res> {
  factory _$$WorkspaceFoldersResponseImplCopyWith(
          _$WorkspaceFoldersResponseImpl value,
          $Res Function(_$WorkspaceFoldersResponseImpl) then) =
      __$$WorkspaceFoldersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sharedId, List<WorkspaceFolder> folders, int count});
}

/// @nodoc
class __$$WorkspaceFoldersResponseImplCopyWithImpl<$Res>
    extends _$WorkspaceFoldersResponseCopyWithImpl<$Res,
        _$WorkspaceFoldersResponseImpl>
    implements _$$WorkspaceFoldersResponseImplCopyWith<$Res> {
  __$$WorkspaceFoldersResponseImplCopyWithImpl(
      _$WorkspaceFoldersResponseImpl _value,
      $Res Function(_$WorkspaceFoldersResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkspaceFoldersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedId = null,
    Object? folders = null,
    Object? count = null,
  }) {
    return _then(_$WorkspaceFoldersResponseImpl(
      sharedId: null == sharedId
          ? _value.sharedId
          : sharedId // ignore: cast_nullable_to_non_nullable
              as String,
      folders: null == folders
          ? _value._folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<WorkspaceFolder>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceFoldersResponseImpl implements _WorkspaceFoldersResponse {
  const _$WorkspaceFoldersResponseImpl(
      {required this.sharedId,
      required final List<WorkspaceFolder> folders,
      required this.count})
      : _folders = folders;

  factory _$WorkspaceFoldersResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceFoldersResponseImplFromJson(json);

  @override
  final String sharedId;
  final List<WorkspaceFolder> _folders;
  @override
  List<WorkspaceFolder> get folders {
    if (_folders is EqualUnmodifiableListView) return _folders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  @override
  final int count;

  @override
  String toString() {
    return 'WorkspaceFoldersResponse(sharedId: $sharedId, folders: $folders, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceFoldersResponseImpl &&
            (identical(other.sharedId, sharedId) ||
                other.sharedId == sharedId) &&
            const DeepCollectionEquality().equals(other._folders, _folders) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sharedId,
      const DeepCollectionEquality().hash(_folders), count);

  /// Create a copy of WorkspaceFoldersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceFoldersResponseImplCopyWith<_$WorkspaceFoldersResponseImpl>
      get copyWith => __$$WorkspaceFoldersResponseImplCopyWithImpl<
          _$WorkspaceFoldersResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceFoldersResponseImplToJson(
      this,
    );
  }
}

abstract class _WorkspaceFoldersResponse implements WorkspaceFoldersResponse {
  const factory _WorkspaceFoldersResponse(
      {required final String sharedId,
      required final List<WorkspaceFolder> folders,
      required final int count}) = _$WorkspaceFoldersResponseImpl;

  factory _WorkspaceFoldersResponse.fromJson(Map<String, dynamic> json) =
      _$WorkspaceFoldersResponseImpl.fromJson;

  @override
  String get sharedId;
  @override
  List<WorkspaceFolder> get folders;
  @override
  int get count;

  /// Create a copy of WorkspaceFoldersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceFoldersResponseImplCopyWith<_$WorkspaceFoldersResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
