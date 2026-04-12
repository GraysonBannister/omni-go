import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/workspace.dart';
import '../providers/workspace_provider.dart';

part 'folder_selector.g.dart';

/// Compact chip showing current folder that opens selector when tapped
/// Only visible when workspace has multiple folders
class FolderSelectorChip extends ConsumerWidget {
  final VoidCallback? onFolderChanged;

  const FolderSelectorChip({super.key, this.onFolderChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentWorkspace = ref.watch(currentWorkspaceProvider);
    final selectedFolder = ref.watch(selectedWorkspaceFolderProvider);

    return currentWorkspace.when(
      data: (workspace) {
        if (workspace == null || workspace.folders.length <= 1) {
          // Don't show folder selector for single-folder workspaces
          return const SizedBox.shrink();
        }

        final folder = selectedFolder.valueOrNull ?? workspace.folders.first;

        return ActionChip(
          avatar: Icon(
            Icons.folder_outlined,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              folder.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: theme.colorScheme.surfaceContainerLow,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            width: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => _showFolderSelector(context, ref, workspace),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showFolderSelector(
    BuildContext context,
    WidgetRef ref,
    Workspace workspace,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => FolderSelectorSheet(
        workspace: workspace,
        onFolderChanged: onFolderChanged,
      ),
    );
  }
}

/// Full folder selector bottom sheet for multi-folder workspaces
class FolderSelectorSheet extends ConsumerWidget {
  final Workspace workspace;
  final VoidCallback? onFolderChanged;

  const FolderSelectorSheet({
    super.key,
    required this.workspace,
    this.onFolderChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedFolderAsync = ref.watch(selectedWorkspaceFolderProvider);
    final selectedFolder = selectedFolderAsync.valueOrNull;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Project Folder',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Workspace: ${workspace.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Folder list
            Expanded(
              child: ListView.builder(
                itemCount: workspace.folders.length,
                itemBuilder: (context, index) {
                  final folder = workspace.folders[index];
                  final isSelected = selectedFolder?.id == folder.id;

                  return ListTile(
                    leading: Icon(
                      isSelected ? Icons.folder : Icons.folder_outlined,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      folder.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      folder.path,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                    selected: isSelected,
                    onTap: () async {
                      if (!isSelected) {
                        ref
                            .read(selectedWorkspaceFolderProvider.notifier)
                            .selectFolder(folder);

                        if (kDebugMode) {
                          debugPrint(
                              '[FolderSelector] Switched to folder: ${folder.name} (${folder.path})');
                        }

                        onFolderChanged?.call();
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider that returns true if the current workspace has multiple folders
@riverpod
bool hasMultipleFolders(HasMultipleFoldersRef ref) {
  final workspaceAsync = ref.watch(currentWorkspaceProvider);
  return workspaceAsync.when(
    data: (workspace) => (workspace?.folders.length ?? 0) > 1,
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Provider that returns the count of folders in the current workspace
@riverpod
int currentWorkspaceFolderCount(CurrentWorkspaceFolderCountRef ref) {
  final workspaceAsync = ref.watch(currentWorkspaceProvider);
  return workspaceAsync.when(
    data: (workspace) => workspace?.folders.length ?? 0,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
