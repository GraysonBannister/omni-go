import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/workspace.dart';
import '../providers/workspace_provider.dart';
import 'create_workspace_dialogs.dart';

/// Compact chip showing current workspace that opens selector when tapped
class WorkspaceSelectorChip extends ConsumerWidget {
  final VoidCallback? onWorkspaceChanged;

  const WorkspaceSelectorChip({super.key, this.onWorkspaceChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentWorkspace = ref.watch(currentWorkspaceProvider);
    final isLoading = ref.watch(isWorkspacesLoadingProvider);

    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return currentWorkspace.when(
      data: (workspace) {
        final displayText = workspace?.name ?? 'No Workspace';
        final folderCount = workspace?.folderCount ?? 0;

        return ActionChip(
          avatar: Icon(
            workspace?.isSingleFolder == true ? Icons.folder : Icons.workspaces,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              displayText,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          side: BorderSide.none,
          onPressed: () => _showWorkspaceSelector(context, ref),
        );
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => ActionChip(
        avatar: Icon(
          Icons.error_outline,
          size: 18,
          color: theme.colorScheme.error,
        ),
        label: Text(
          'Error',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        onPressed: () => _showWorkspaceSelector(context, ref),
      ),
    );
  }

  void _showWorkspaceSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => const WorkspaceSelectorSheet(),
    );
  }
}

/// Full workspace selector bottom sheet
class WorkspaceSelectorSheet extends ConsumerWidget {
  const WorkspaceSelectorSheet({super.key});

  Future<void> _showCreateProject(BuildContext context, WidgetRef ref) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const CreateProjectDialog(),
    );
    if (created == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showCreateWorkspace(BuildContext context, WidgetRef ref) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const CreateWorkspaceDialog(),
    );
    if (created == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final workspacesAsync = ref.watch(availableWorkspacesProvider);
    final currentWorkspace = ref.watch(currentWorkspaceProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select Workspace',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                        onPressed: () {
                          ref.read(availableWorkspacesProvider.notifier).refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.folder_open, size: 18),
                          label: const Text('New Project'),
                          onPressed: () => _showCreateProject(context, ref),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.workspaces_outlined, size: 18),
                          label: const Text('New Workspace'),
                          onPressed: () => _showCreateWorkspace(context, ref),
                        ),
                      ),
                    ],
                  ),
                  if (currentWorkspace.valueOrNull != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.onPrimaryContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Current: ${currentWorkspace.valueOrNull!.name}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Workspace list
            Expanded(
              child: workspacesAsync.when(
                data: (workspaces) {
                  if (workspaces.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.workspaces_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Workspaces Available',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'The server has not shared any workspaces',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final activeId = currentWorkspace.valueOrNull?.sharedId;

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: workspaces.length,
                    itemBuilder: (context, index) {
                      final workspace = workspaces[index];
                      final isActive = workspace.sharedId == activeId;

                      return _WorkspaceListTile(
                        workspace: workspace,
                        isActive: isActive,
                        onTap: () async {
                          if (!isActive) {
                            await ref.read(currentWorkspaceProvider.notifier).switchWorkspace(workspace.sharedId);
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load workspaces',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(availableWorkspacesProvider.notifier).refresh();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WorkspaceListTile extends ConsumerWidget {
  final Workspace workspace;
  final bool isActive;
  final VoidCallback onTap;

  const _WorkspaceListTile({
    required this.workspace,
    required this.isActive,
    required this.onTap,
  });

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove workspace?'),
        content: Text(
          'Remove "${workspace.name}" from the shared list? '
          'The files on the server will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(availableWorkspacesProvider.notifier)
          .deleteWorkspace(workspace.sharedId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isActive ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            workspace.isSingleFolder ? Icons.folder : Icons.workspaces,
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
        ),
        title: Text(
          workspace.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: isActive ? FontWeight.bold : null,
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          workspace.isSingleFolder
              ? 'Single Folder'
              : '${workspace.folderCount} folder${workspace.folderCount != 1 ? 's' : ''}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isActive
                ? theme.colorScheme.primary.withOpacity(0.8)
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Icon(Icons.check_circle, color: theme.colorScheme.primary)
            else
              const Icon(Icons.chevron_right),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 20),
                      const SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: theme.colorScheme.error)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') _confirmDelete(context, ref);
              },
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

/// Simple text display of current workspace for status bar
class WorkspaceStatus extends ConsumerWidget {
  const WorkspaceStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentWorkspace = ref.watch(currentWorkspaceProvider);

    return currentWorkspace.when(
      data: (workspace) {
        if (workspace == null) return const SizedBox.shrink();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              workspace.isSingleFolder ? Icons.folder_outlined : Icons.workspaces_outlined,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 4),
            Text(
              workspace.name,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
