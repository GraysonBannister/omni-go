import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/file_item.dart';
import '../providers/server_provider.dart';
import '../providers/workspace_provider.dart';

// ---------------------------------------------------------------------------
// Folder Picker
// ---------------------------------------------------------------------------

/// A full-screen-style dialog that lets the user browse the server filesystem
/// and select a directory. Returns the selected absolute path or null if
/// cancelled.
class ServerFolderPickerDialog extends ConsumerStatefulWidget {
  /// Path to open at first; falls back to active workspace dir, then '/'.
  final String? initialPath;

  const ServerFolderPickerDialog({super.key, this.initialPath});

  @override
  ConsumerState<ServerFolderPickerDialog> createState() =>
      _ServerFolderPickerDialogState();
}

class _ServerFolderPickerDialogState
    extends ConsumerState<ServerFolderPickerDialog> {
  late String _currentPath;
  List<FileItem> _dirs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.initialPath ?? '/';
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(_currentPath));
  }

  String _dirname(String p) {
    if (p == '/') return '/';
    final parts = p.split('/');
    parts.removeLast();
    final parent = parts.join('/');
    return parent.isEmpty ? '/' : parent;
  }

  Future<void> _promptNewFolder(BuildContext context) async {
    final controller = TextEditingController();
    final folderName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Folder name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (folderName == null || folderName.isEmpty) return;

    final newPath = _currentPath == '/'
        ? '/$folderName'
        : '$_currentPath/$folderName';

    try {
      final repo = ref.read(remoteRepositoryProvider);
      await repo.createDirectory(newPath);
      await _load(_currentPath); // refresh listing
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not create folder: $e')),
        );
      }
    }
  }

  Future<void> _load(String path) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(remoteRepositoryProvider);
      final entries = await repo.listFiles(path);
      final dirs = entries.where((e) => e.isDirectory).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      if (mounted) {
        setState(() {
          _currentPath = path;
          _dirs = dirs;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  List<String> get _breadcrumbs {
    if (_currentPath == '/') return ['/'];
    final parts = _currentPath.split('/').where((s) => s.isNotEmpty).toList();
    final crumbs = <String>['/'];
    var built = '';
    for (final p in parts) {
      built = '$built/$p';
      crumbs.add(built);
    }
    return crumbs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canGoUp = _currentPath != '/';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Header ----
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Go up',
                        onPressed: canGoUp ? () => _load(_dirname(_currentPath)) : null,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _breadcrumbs.asMap().entries.map((entry) {
                              final isLast = entry.key == _breadcrumbs.length - 1;
                              final crumb = entry.value;
                              final label = crumb == '/'
                                  ? '/'
                                  : crumb.split('/').last;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (entry.key > 0)
                                    Icon(
                                      Icons.chevron_right,
                                      size: 16,
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                    ),
                                  InkWell(
                                    onTap: isLast ? null : () => _load(crumb),
                                    borderRadius: BorderRadius.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Text(
                                        label,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: isLast
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isLast
                                              ? theme.colorScheme.onSurface
                                              : theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.create_new_folder_outlined),
                        tooltip: 'New folder here',
                        onPressed: () => _promptNewFolder(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Cancel',
                        onPressed: () => Navigator.of(context).pop(null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(
                      'Select: ${_currentPath.split('/').last.isEmpty ? '/' : _currentPath.split('/').last}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => Navigator.of(context).pop(_currentPath),
                  ),
                ],
              ),
            ),

            // ---- Body ----
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _ErrorBody(
                          error: _error!,
                          onRetry: () => _load(_currentPath),
                        )
                      : _dirs.isEmpty
                          ? Center(
                              child: Text(
                                'No sub-folders',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemCount: _dirs.length,
                              itemBuilder: (context, index) {
                                final dir = _dirs[index];
                                return ListTile(
                                  leading: Icon(
                                    Icons.folder,
                                    color: theme.colorScheme.primary,
                                  ),
                                  title: Text(dir.name),
                                  trailing: const Icon(Icons.chevron_right),
                                  dense: true,
                                  onTap: () => _load(dir.path),
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

class _ErrorBody extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorBody({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(error,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FolderPickerField  (private helper)
// ---------------------------------------------------------------------------

/// A tappable field that shows a selected server path and opens
/// [ServerFolderPickerDialog] when tapped.
class _FolderPickerField extends ConsumerWidget {
  final String? selectedPath;
  final String label;
  final String? errorText;
  final ValueChanged<String> onSelected;

  const _FolderPickerField({
    required this.label,
    required this.onSelected,
    this.selectedPath,
    this.errorText,
  });

  Future<void> _browse(BuildContext context, WidgetRef ref) async {
    // Determine a sensible starting path
    String? start = selectedPath;
    if (start == null || start.isEmpty) {
      start = await ref.read(currentWorkingDirectoryProvider.future);
    }

    if (!context.mounted) return;

    final picked = await showDialog<String>(
      context: context,
      builder: (_) => ServerFolderPickerDialog(initialPath: start ?? '/'),
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasPath = selectedPath != null && selectedPath!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => _browse(context, ref),
          borderRadius: BorderRadius.zero,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.folder_open),
              suffixIcon: const Icon(Icons.navigate_next),
              errorText: errorText,
            ),
            isEmpty: !hasPath,
            child: Text(
              hasPath ? selectedPath! : 'Tap to browse server folders…',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasPath
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CreateProjectDialog
// ---------------------------------------------------------------------------

/// Dialog for creating a new single-folder project.
///
/// The folder is selected via [ServerFolderPickerDialog] browsing the server
/// filesystem.
class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  ConsumerState<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _parentPath;
  bool _parentError = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// The full path that will be created: parentPath/folderName
  String? get _fullPath {
    final name = _nameController.text.trim();
    if (_parentPath == null || _parentPath!.isEmpty || name.isEmpty) return null;
    final parent = _parentPath!.endsWith('/')
        ? _parentPath!.substring(0, _parentPath!.length - 1)
        : _parentPath!;
    return '$parent/$name';
  }

  Future<void> _submit() async {
    setState(() => _parentError = _parentPath == null || _parentPath!.isEmpty);
    if (_parentError) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Send the full path (parent/name) — backend will mkdir it then register it
      await ref.read(availableWorkspacesProvider.notifier).createProject(
            _fullPath!,
            name: _nameController.text.trim(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = _fullPath;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.folder_open, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          const Text('New Project'),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose a parent directory and name the new project folder.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              _FolderPickerField(
                label: 'Parent directory',
                selectedPath: _parentPath,
                errorText: _parentError ? 'Please select a parent directory' : null,
                onSelected: (path) => setState(() {
                  _parentPath = path;
                  _parentError = false;
                }),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Project folder name',
                  hintText: 'my-project',
                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Folder name is required';
                  if (v.trim().contains('/')) return 'Folder name cannot contain /';
                  return null;
                },
              ),
              if (preview != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.subdirectory_arrow_right,
                          size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          preview,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: theme.colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Text(
                    _error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _submit,
          icon: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add),
          label: const Text('Create Project'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CreateWorkspaceDialog
// ---------------------------------------------------------------------------

/// Dialog for creating a new multi-folder workspace.
class CreateWorkspaceDialog extends ConsumerStatefulWidget {
  const CreateWorkspaceDialog({super.key});

  @override
  ConsumerState<CreateWorkspaceDialog> createState() =>
      _CreateWorkspaceDialogState();
}

class _CreateWorkspaceDialogState extends ConsumerState<CreateWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  /// Selected paths for each folder slot. Start with one empty slot.
  final List<String?> _folderPaths = [null];

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addFolder() => setState(() => _folderPaths.add(null));

  void _removeFolder(int index) {
    if (_folderPaths.length <= 1) return;
    setState(() => _folderPaths.removeAt(index));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final folders =
        _folderPaths.whereType<String>().where((s) => s.isNotEmpty).toList();
    if (folders.isEmpty) {
      setState(() => _error = 'Select at least one folder.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(availableWorkspacesProvider.notifier)
          .createWorkspace(_nameController.text.trim(), folders);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.workspaces, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          const Text('New Workspace'),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Combine multiple server-side folders into one workspace.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Workspace name',
                    hintText: 'My Workspace',
                    prefixIcon: Icon(Icons.workspaces_outline),
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Workspace name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Folders', style: theme.textTheme.titleSmall),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _addFolder,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Folder'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._folderPaths.asMap().entries.map((entry) {
                  final index = entry.key;
                  final selectedPath = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _FolderPickerField(
                            label: 'Folder ${index + 1}',
                            selectedPath: selectedPath,
                            onSelected: (path) => setState(
                              () => _folderPaths[index] = path,
                            ),
                          ),
                        ),
                        if (_folderPaths.length > 1) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: theme.colorScheme.error,
                            ),
                            tooltip: 'Remove folder',
                            onPressed: () => _removeFolder(index),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      _error!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _submit,
          icon: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add),
          label: const Text('Create Workspace'),
        ),
      ],
    );
  }
}
