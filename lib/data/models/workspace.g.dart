// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceImpl _$$WorkspaceImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceImpl(
      sharedId: json['sharedId'] as String,
      workspaceId: json['workspaceId'] as String,
      name: json['name'] as String,
      folderCount: (json['folderCount'] as num).toInt(),
      folders: (json['folders'] as List<dynamic>?)
              ?.map((e) => WorkspaceFolder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? false,
      isSingleFolder: json['isSingleFolder'] as bool? ?? false,
      addedAt: (json['addedAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$WorkspaceImplToJson(_$WorkspaceImpl instance) =>
    <String, dynamic>{
      'sharedId': instance.sharedId,
      'workspaceId': instance.workspaceId,
      'name': instance.name,
      'folderCount': instance.folderCount,
      'folders': instance.folders,
      'isActive': instance.isActive,
      'isSingleFolder': instance.isSingleFolder,
      'addedAt': instance.addedAt,
    };

_$WorkspaceFolderImpl _$$WorkspaceFolderImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkspaceFolderImpl(
      id: json['id'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$WorkspaceFolderImplToJson(
        _$WorkspaceFolderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'name': instance.name,
    };

_$WorkspacesResponseImpl _$$WorkspacesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkspacesResponseImpl(
      workspaces: (json['workspaces'] as List<dynamic>)
          .map((e) => Workspace.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeWorkspaceId: json['activeWorkspaceId'] as String?,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$WorkspacesResponseImplToJson(
        _$WorkspacesResponseImpl instance) =>
    <String, dynamic>{
      'workspaces': instance.workspaces,
      'activeWorkspaceId': instance.activeWorkspaceId,
      'count': instance.count,
    };

_$ActiveWorkspaceResponseImpl _$$ActiveWorkspaceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ActiveWorkspaceResponseImpl(
      activeWorkspace: json['activeWorkspace'] == null
          ? null
          : Workspace.fromJson(json['activeWorkspace'] as Map<String, dynamic>),
      workingDirectory: json['workingDirectory'] as String?,
    );

Map<String, dynamic> _$$ActiveWorkspaceResponseImplToJson(
        _$ActiveWorkspaceResponseImpl instance) =>
    <String, dynamic>{
      'activeWorkspace': instance.activeWorkspace,
      'workingDirectory': instance.workingDirectory,
    };

_$SwitchWorkspaceResponseImpl _$$SwitchWorkspaceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SwitchWorkspaceResponseImpl(
      success: json['success'] as bool,
      activeWorkspace: json['activeWorkspace'] == null
          ? null
          : ActiveWorkspaceInfo.fromJson(
              json['activeWorkspace'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SwitchWorkspaceResponseImplToJson(
        _$SwitchWorkspaceResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'activeWorkspace': instance.activeWorkspace,
    };

_$ActiveWorkspaceInfoImpl _$$ActiveWorkspaceInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$ActiveWorkspaceInfoImpl(
      sharedId: json['sharedId'] as String,
      name: json['name'] as String,
      workingDirectory: json['workingDirectory'] as String?,
    );

Map<String, dynamic> _$$ActiveWorkspaceInfoImplToJson(
        _$ActiveWorkspaceInfoImpl instance) =>
    <String, dynamic>{
      'sharedId': instance.sharedId,
      'name': instance.name,
      'workingDirectory': instance.workingDirectory,
    };

_$WorkspaceFoldersResponseImpl _$$WorkspaceFoldersResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkspaceFoldersResponseImpl(
      sharedId: json['sharedId'] as String,
      folders: (json['folders'] as List<dynamic>)
          .map((e) => WorkspaceFolder.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$WorkspaceFoldersResponseImplToJson(
        _$WorkspaceFoldersResponseImpl instance) =>
    <String, dynamic>{
      'sharedId': instance.sharedId,
      'folders': instance.folders,
      'count': instance.count,
    };
