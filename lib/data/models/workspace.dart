import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace.freezed.dart';
part 'workspace.g.dart';

@freezed
class Workspace with _$Workspace {
  const factory Workspace({
    required String sharedId,
    required String workspaceId,
    required String name,
    required int folderCount,
    @Default([]) List<WorkspaceFolder> folders,
    @Default(false) bool isActive,
    @Default(false) bool isSingleFolder,
    int? addedAt,
  }) = _Workspace;

  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);

  const Workspace._();

  /// Get addedAt as DateTime (converted from milliseconds since epoch)
  DateTime? get addedAtDateTime =>
      addedAt != null ? DateTime.fromMillisecondsSinceEpoch(addedAt!) : null;
}

@freezed
class WorkspaceFolder with _$WorkspaceFolder {
  const factory WorkspaceFolder({
    required String id,
    required String path,
    required String name,
  }) = _WorkspaceFolder;

  factory WorkspaceFolder.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFolderFromJson(json);
}

/// Response from GET /api/workspaces
@freezed
class WorkspacesResponse with _$WorkspacesResponse {
  const factory WorkspacesResponse({
    required List<Workspace> workspaces,
    String? activeWorkspaceId,
    required int count,
  }) = _WorkspacesResponse;

  factory WorkspacesResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspacesResponseFromJson(json);
}

/// Response from GET /api/workspaces/active
@freezed
class ActiveWorkspaceResponse with _$ActiveWorkspaceResponse {
  const factory ActiveWorkspaceResponse({
    Workspace? activeWorkspace,
    String? workingDirectory,
  }) = _ActiveWorkspaceResponse;

  factory ActiveWorkspaceResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveWorkspaceResponseFromJson(json);
}

/// Response from POST /api/workspaces/switch
@freezed
class SwitchWorkspaceResponse with _$SwitchWorkspaceResponse {
  const factory SwitchWorkspaceResponse({
    required bool success,
    ActiveWorkspaceInfo? activeWorkspace,
  }) = _SwitchWorkspaceResponse;

  factory SwitchWorkspaceResponse.fromJson(Map<String, dynamic> json) =>
      _$SwitchWorkspaceResponseFromJson(json);
}

@freezed
class ActiveWorkspaceInfo with _$ActiveWorkspaceInfo {
  const factory ActiveWorkspaceInfo({
    required String sharedId,
    required String name,
    String? workingDirectory,
  }) = _ActiveWorkspaceInfo;

  factory ActiveWorkspaceInfo.fromJson(Map<String, dynamic> json) =>
      _$ActiveWorkspaceInfoFromJson(json);
}

/// Folders response from GET /api/workspaces/:id/folders
@freezed
class WorkspaceFoldersResponse with _$WorkspaceFoldersResponse {
  const factory WorkspaceFoldersResponse({
    required String sharedId,
    required List<WorkspaceFolder> folders,
    required int count,
  }) = _WorkspaceFoldersResponse;

  factory WorkspaceFoldersResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFoldersResponseFromJson(json);
}
