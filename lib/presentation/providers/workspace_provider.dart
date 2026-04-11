import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../config/constants.dart';
import '../../data/models/workspace.dart';
import '../../data/repositories/remote_repository.dart';
import 'server_provider.dart';

part 'workspace_provider.g.dart';

const _secureStorage = FlutterSecureStorage();

/// Provider for the list of available workspaces
@riverpod
class AvailableWorkspaces extends _$AvailableWorkspaces {
  @override
  Future<List<Workspace>> build() async {
    final repository = ref.watch(remoteRepositoryProvider);
    return repository.fetchWorkspaces();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(remoteRepositoryProvider);
      final workspaces = await repository.fetchWorkspaces();
      state = AsyncData(workspaces);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Create a single-folder project and switch to it.
  Future<Workspace> createProject(String folderPath, {String? name}) async {
    final repository = ref.read(remoteRepositoryProvider);
    final workspace = await repository.createProject(folderPath, name: name);
    await refresh();
    await ref.read(currentWorkspaceProvider.notifier).switchWorkspace(workspace.sharedId);
    return workspace;
  }

  /// Create a multi-folder workspace and switch to it.
  Future<Workspace> createWorkspace(String name, List<String> folders) async {
    final repository = ref.read(remoteRepositoryProvider);
    final workspace = await repository.createWorkspace(name, folders);
    await refresh();
    await ref.read(currentWorkspaceProvider.notifier).switchWorkspace(workspace.sharedId);
    return workspace;
  }

  /// Remove a workspace from the shared list.
  Future<void> deleteWorkspace(String sharedId) async {
    final repository = ref.read(remoteRepositoryProvider);
    await repository.deleteWorkspace(sharedId);
    await refresh();
  }
}

/// Provider for the currently active workspace
@Riverpod(keepAlive: true)
class CurrentWorkspace extends _$CurrentWorkspace {
  @override
  Future<Workspace?> build() async {
    final repository = ref.watch(remoteRepositoryProvider);

    // Try to load saved workspace preference
    final savedId = await _loadSavedWorkspaceId();
    if (savedId != null) {
      try {
        final workspace = await repository.getWorkspace(savedId);
        if (workspace != null) return workspace;
      } catch (e) {
        if (kDebugMode) debugPrint('[CurrentWorkspace] Failed to load saved workspace: $e');
      }
    }

    // Fall back to server's active workspace
    try {
      return await repository.getActiveWorkspace();
    } catch (e) {
      if (kDebugMode) debugPrint('[CurrentWorkspace] Failed to fetch active workspace: $e');
      return null;
    }
  }

  Future<void> switchWorkspace(String sharedId) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(remoteRepositoryProvider);
      final workspace = await repository.switchWorkspace(sharedId);

      if (workspace != null) {
        await _saveWorkspaceId(sharedId);
        state = AsyncData(workspace);

        // Refresh available workspaces to update isActive status
        ref.read(availableWorkspacesProvider.notifier).refresh();
      } else {
        state = const AsyncData(null);
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(remoteRepositoryProvider);
      final workspace = await repository.getActiveWorkspace();
      state = AsyncData(workspace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<String?> _loadSavedWorkspaceId() async {
    try {
      return await _secureStorage.read(key: StorageKeys.currentWorkspaceId);
    } catch (e) {
      if (kDebugMode) debugPrint('[CurrentWorkspace] Failed to load saved workspace ID: $e');
      return null;
    }
  }

  Future<void> _saveWorkspaceId(String sharedId) async {
    try {
      await _secureStorage.write(key: StorageKeys.currentWorkspaceId, value: sharedId);
    } catch (e) {
      if (kDebugMode) debugPrint('[CurrentWorkspace] Failed to save workspace ID: $e');
    }
  }
}

/// Provider for workspace folders
@riverpod
Future<List<WorkspaceFolder>> workspaceFolders(WorkspaceFoldersRef ref, String sharedId) async {
  final repository = ref.watch(remoteRepositoryProvider);
  return repository.getWorkspaceFolders(sharedId);
}

/// Provider for the current working directory (first folder of active workspace)
@riverpod
Future<String?> currentWorkingDirectory(CurrentWorkingDirectoryRef ref) async {
  final workspace = await ref.watch(currentWorkspaceProvider.future);
  if (workspace == null || workspace.folders.isEmpty) return null;
  return workspace.folders.first.path;
}

/// Provider that returns true if workspaces are loading
@riverpod
bool isWorkspacesLoading(IsWorkspacesLoadingRef ref) {
  final workspacesAsync = ref.watch(availableWorkspacesProvider);
  return workspacesAsync.isLoading;
}

/// Provider that returns the active workspace name
@riverpod
Future<String?> activeWorkspaceName(ActiveWorkspaceNameRef ref) async {
  final workspace = await ref.watch(currentWorkspaceProvider.future);
  return workspace?.name;
}

/// Provider that returns whether we have multiple workspaces available
@riverpod
bool hasMultipleWorkspaces(HasMultipleWorkspacesRef ref) {
  final workspacesAsync = ref.watch(availableWorkspacesProvider);
  return workspacesAsync.when(
    data: (workspaces) => workspaces.length > 1,
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Provider that returns the count of available workspaces
@riverpod
int workspaceCount(WorkspaceCountRef ref) {
  final workspacesAsync = ref.watch(availableWorkspacesProvider);
  return workspacesAsync.when(
    data: (workspaces) => workspaces.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
