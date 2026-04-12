import 'dart:io';
import 'package:dio/dio.dart' as dio_lib;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../data/models/file_item.dart';
import '../../data/models/git_file_status.dart';
import '../../data/models/line_change.dart';
import '../../presentation/providers/adb_provider.dart';
import '../../presentation/providers/files_provider.dart';
import '../../presentation/providers/navigation_provider.dart';
import '../../presentation/providers/server_provider.dart';
import '../../presentation/providers/terminal_manager_provider.dart';
import '../../presentation/providers/workspace_provider.dart';
import '../../presentation/widgets/code_viewer_with_diff.dart';
import '../../presentation/widgets/folder_selector.dart';
import '../../presentation/widgets/workspace_selector.dart';

class FilesScreen extends ConsumerStatefulWidget {
  const FilesScreen({super.key});

  @override
  ConsumerState<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends ConsumerState<FilesScreen> {
  GitDirectoryStatus _gitStatus = const GitDirectoryStatus.notGit();
  bool _isLoadingGitStatus = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(filesControllerProvider.notifier).loadDirectory('.');
      await _fetchGitStatus();
    });
  }

  Future<void> _fetchGitStatus() async {
    final currentDir = ref.read(currentDirectoryProvider);
    if (currentDir.isEmpty) {
      setState(() => _gitStatus = const GitDirectoryStatus.notGit());
      return;
    }

    setState(() => _isLoadingGitStatus = true);

    try {
      final repository = ref.read(remoteRepositoryProvider);
      final workspaceAsync = ref.read(currentWorkspaceProvider);
      final workspaceId = workspaceAsync.valueOrNull?.sharedId;

      final status = await repository.fetchGitStatus(
        currentDir,
        workspaceId: workspaceId,
      );

      // Debug logging
      debugPrint('[FilesScreen] Git status for "$currentDir": isGitRepo=${status.isGitRepo}, branch=${status.branch}, files=${status.files.length}');
      if (status.files.isNotEmpty) {
        debugPrint('[FilesScreen] Files: ${status.files.entries.take(10).map((e) => '${e.key}:${e.value.name}').join(', ')}');
      }

      if (mounted) {
        setState(() {
          _gitStatus = status;
          _isLoadingGitStatus = false;
        });
      }
    } catch (e) {
      debugPrint('[FilesScreen] Error fetching git status: $e');
      if (mounted) {
        setState(() {
          _gitStatus = const GitDirectoryStatus.notGit();
          _isLoadingGitStatus = false;
        });
      }
    }
  }

  Color? _getFileColor(FileItem file, ThemeData theme) {
    if (!_gitStatus.isGitRepo) return null;

    if (file.isDirectory) {
      // Color a directory if any changed file lives anywhere inside it
      final prefix = '${file.name}/';
      final matchingStatuses = _gitStatus.files.entries
          .where((e) => e.key.startsWith(prefix) || e.key == file.name)
          .map((e) => e.value)
          .toSet();
      return _statusSetColor(matchingStatuses);
    } else {
      return _statusColor(_gitStatus.getStatus(file.name));
    }
  }

  Color? _statusColor(GitFileStatus status) {
    switch (status) {
      case GitFileStatus.untracked:
        return Colors.lightBlue;
      case GitFileStatus.modified:
        return Colors.orange.shade300;
      case GitFileStatus.staged:
        return Colors.green;
      case GitFileStatus.deleted:
        return Colors.red.shade300;
      case GitFileStatus.conflicted:
        return Colors.purple.shade300;
      default:
        return null;
    }
  }

  Color? _statusSetColor(Set<GitFileStatus> statuses) {
    if (statuses.isEmpty) return null;
    // Priority: untracked > modified > staged > deleted > conflicted
    if (statuses.contains(GitFileStatus.untracked)) return Colors.lightBlue;
    if (statuses.contains(GitFileStatus.modified)) return Colors.orange.shade300;
    if (statuses.contains(GitFileStatus.staged)) return Colors.green;
    if (statuses.contains(GitFileStatus.deleted)) return Colors.red.shade300;
    if (statuses.contains(GitFileStatus.conflicted)) return Colors.purple.shade300;
    return null;
  }

  void _onFileTap(FileItem file) async {
    if (file.isDirectory) {
      ref.read(currentDirectoryProvider.notifier).state = file.path;
      await ref.read(filesControllerProvider.notifier).loadDirectory(file.path);
      await _fetchGitStatus();
    } else {
      _showFileContent(file);
    }
  }

  void _showFileContent(FileItem file) {
    ref.read(selectedFileProvider.notifier).state = file;
    
    // Check if file is an image
    if (_isImageFile(file.name)) {
      // Show image viewer for image files
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ImageViewerScreen()),
      );
    } else {
      // Show text editor for text files
      ref.read(fileContentProvider.notifier).load(file.path);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FileEditorScreen()),
      );
    }
  }

  bool _isImageFile(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'svg'].contains(ext);
  }

  void _goBack() async {
    final currentDir = ref.read(currentDirectoryProvider);
    final parentDir = currentDir.contains('/') 
        ? currentDir.substring(0, currentDir.lastIndexOf('/')) 
        : '.';
    ref.read(currentDirectoryProvider.notifier).state = parentDir.isEmpty ? '.' : parentDir;
    await ref.read(filesControllerProvider.notifier).loadDirectory(parentDir.isEmpty ? '.' : parentDir);
    await _fetchGitStatus();
  }

  String _getFullPath(FileItem file) {
    final selectedFolder = ref.read(selectedWorkspaceFolderProvider).valueOrNull;
    final folderRoot = selectedFolder?.path ?? '';

    if (folderRoot.isNotEmpty && !file.path.startsWith('/')) {
      return path.join(folderRoot, file.path);
    }
    return file.path;
  }

  String _getRelativePath(FileItem file) {
    final selectedFolder = ref.read(selectedWorkspaceFolderProvider).valueOrNull;
    final folderRoot = selectedFolder?.path ?? '';

    if (folderRoot.isNotEmpty && file.path.startsWith(folderRoot)) {
      final rel = file.path.substring(folderRoot.length);
      return rel.startsWith('/') ? rel.substring(1) : rel;
    }
    return file.path;
  }

  void _showFileActions(FileItem file) {
    final theme = Theme.of(context);
    final isApk = !file.isDirectory && file.name.toLowerCase().endsWith('.apk');
    final relativePath = _getRelativePath(file);
    final fullPath = _getFullPath(file);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  Icon(
                    file.isDirectory ? Icons.folder : Icons.insert_drive_file,
                    color: file.isDirectory ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(file.name, style: theme.textTheme.titleSmall),
                        Text(
                          relativePath,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                            fontFamily: 'monospace',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            if (file.isFile)
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: const Text('Open'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showFileContent(file);
                },
              ),

            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy relative path'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: relativePath));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Relative path copied')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.copy_all),
              title: const Text('Copy full path'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: fullPath));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Full path copied')),
                );
              },
            ),

            // Open in integrated terminal option
            ListTile(
              leading: const Icon(Icons.terminal),
              title: const Text('Open in integrated terminal'),
              onTap: () async {
                Navigator.pop(ctx);

                // Determine the directory to open
                final String targetPath;
                if (file.isDirectory) {
                  targetPath = file.path;
                } else {
                  // For files, open the parent directory
                  targetPath = path.dirname(file.path);
                }

                // Create terminal at this location
                final terminalManager = ref.read(terminalManagerProvider.notifier);
                await terminalManager.createTerminal(
                  name: file.isDirectory ? file.name : path.basename(targetPath),
                  cwd: targetPath,
                );

                // Switch to terminal tab
                ref.read(navigationIndexProvider.notifier).state = NavigationTab.terminal;

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Terminal opened at: $targetPath'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),

            if (file.isFile)
              ListTile(
                leading: const Icon(Icons.content_paste),
                title: const Text('Copy file contents'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final repo = ref.read(remoteRepositoryProvider);
                    final content = await repo.readFile(file.path);
                    await Clipboard.setData(ClipboardData(text: content));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File contents copied')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to copy: $e')),
                      );
                    }
                  }
                },
              ),

            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameDialog(file);
              },
            ),

            if (isApk) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.install_mobile),
                title: const Text('Install on device (ADB)'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final packageName = await ref
                      .read(adbControllerProvider.notifier)
                      .installApk(file.path);
                  if (mounted) {
                    final adbState = ref.read(adbControllerProvider);
                    final succeeded = packageName != null || adbState.error == null;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(succeeded ? 'APK installed' : 'Install failed'),
                        backgroundColor: succeeded ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              ),
              if (Platform.isAndroid)
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download & install locally'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    _downloadAndInstallApk(file.path);
                  },
                ),
            ],

            const Divider(),
            ListTile(
              leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              title: Text('Delete', style: TextStyle(color: theme.colorScheme.error)),
              onTap: () {
                Navigator.pop(ctx);
                _showDeleteConfirmation(file);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(FileItem file) {
    final controller = TextEditingController(text: file.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'New name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final newName = controller.text.trim();
              if (newName.isEmpty || newName == file.name) return;

              try {
                final repo = ref.read(remoteRepositoryProvider);
                final dirPart = file.path.contains('/')
                    ? file.path.substring(0, file.path.lastIndexOf('/'))
                    : '.';
                final newPath = dirPart == '.' ? newName : '$dirPart/$newName';

                if (file.isFile) {
                  final content = await repo.readFile(file.path);
                  await repo.writeFile(newPath, content);
                  await repo.deleteFile(file.path);
                } else {
                  // For directories, we can't easily rename via the current API.
                  // We'll just show a message that directory rename is not yet supported.
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Directory rename not yet supported')),
                    );
                  }
                  return;
                }
                await ref.read(filesControllerProvider.notifier).refresh();
                await _fetchGitStatus();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Renamed to $newName')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Rename failed: $e')),
                  );
                }
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(FileItem file) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Are you sure you want to delete "${file.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final repo = ref.read(remoteRepositoryProvider);
                await repo.deleteFile(file.path);
                await ref.read(filesControllerProvider.notifier).refresh();
                await _fetchGitStatus();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted ${file.name}')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Delete failed: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAndInstallApk(String remotePath) async {
    if (!Platform.isAndroid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local APK install is only available on Android')),
        );
      }
      return;
    }

    try {
      final repo = ref.read(remoteRepositoryProvider);
      final downloadUrl = repo.getDownloadUrl(remotePath);
      final headers = repo.getProxyHeaders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Downloading APK...')),
        );
      }

      final dio = dio_lib.Dio();
      final dir = await getTemporaryDirectory();
      final fileName = remotePath.split('/').last;
      final localPath = '${dir.path}/$fileName';

      await dio.download(
        downloadUrl,
        localPath,
        options: dio_lib.Options(headers: headers),
      );

      final result = await Process.run('am', [
        'start', '-a', 'android.intent.action.VIEW',
        '-t', 'application/vnd.android.package-archive',
        '-d', 'file://$localPath',
      ]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.exitCode == 0
              ? 'APK downloaded - install prompt should appear'
              : 'Download complete but install prompt failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filesState = ref.watch(filesControllerProvider);
    final currentDir = ref.watch(currentDirectoryProvider);
    final theme = Theme.of(context);

    final activeWorkspaceName = ref.watch(activeWorkspaceNameProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Files'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show workspace name
                  Flexible(
                    child: activeWorkspaceName.when(
                      data: (name) => name != null
                          ? Text(
                              name,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  // Show git branch if available
                  if (_gitStatus.isGitRepo && _gitStatus.branch != null)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_tree,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _gitStatus.branch!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        leading: currentDir != '.'
            ? IconButton(icon: const Icon(Icons.arrow_upward), onPressed: _goBack)
            : null,
        actions: [
          const Flexible(
            child: WorkspaceSelectorChip(),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: FolderSelectorChip(
              onFolderChanged: () {
                // Reset to root of new folder when folder changes
                ref.read(currentDirectoryProvider.notifier).state = '.';
                ref.read(filesControllerProvider.notifier).loadDirectory('.');
              },
            ),
          ),
          IconButton(
            icon: _isLoadingGitStatus
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: () {
              ref.read(filesControllerProvider.notifier).refresh();
              _fetchGitStatus();
            },
          ),
        ],
      ),
      body: filesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('Failed to load files', style: theme.textTheme.titleMedium),
              Text(error.toString(), style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
        data: (files) {
          if (files.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('Empty directory', style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5))),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final fileColor = _getFileColor(file, theme);
              return ListTile(
                leading: Icon(
                  file.isDirectory ? Icons.folder : Icons.insert_drive_file,
                  color: file.isDirectory ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                title: Text(
                  file.name,
                  style: TextStyle(
                    color: fileColor,
                  ),
                ),
                trailing: file.isDirectory ? const Icon(Icons.chevron_right) : null,
                onTap: () => _onFileTap(file),
                onLongPress: () => _showFileActions(file),
              );
            },
          );
        },
      ),
    );
  }
}

class FileEditorScreen extends ConsumerStatefulWidget {
  const FileEditorScreen({super.key});

  @override
  ConsumerState<FileEditorScreen> createState() => _FileEditorScreenState();
}

class _FileEditorScreenState extends ConsumerState<FileEditorScreen> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _hasChanges = false;
  bool _showGitDiff = true;
  List<LineChange> _lineChanges = [];
  bool _isLoadingGitDiff = false;
  String? _gitDiffError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _fetchGitDiff();
  }

  @override
  void didUpdateWidget(covariant FileEditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refetch git diff when the widget is updated with a new file
    _fetchGitDiff();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchGitDiff() async {
    final selectedFile = ref.read(selectedFileProvider);
    if (selectedFile == null) return;

    setState(() {
      _isLoadingGitDiff = true;
      _gitDiffError = null;
    });

    try {
      final repository = ref.read(remoteRepositoryProvider);
      final workspaceAsync = ref.read(currentWorkspaceProvider);
      final workspaceId = workspaceAsync.valueOrNull?.sharedId;
      final response = await repository.fetchGitDiff(
        selectedFile.path,
        workspaceId: workspaceId,
      );

      if (mounted) {
        setState(() {
          _lineChanges = response.changes;
          _isLoadingGitDiff = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _gitDiffError = e.toString();
          _isLoadingGitDiff = false;
        });
      }
    }
  }

  Future<void> _saveFile() async {
    final selectedFile = ref.read(selectedFileProvider);
    if (selectedFile == null) return;

    await ref.read(fileContentProvider.notifier).save(selectedFile.path, _controller.text);
    setState(() => _hasChanges = false);

    // Refresh git diff after saving
    await _fetchGitDiff();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedFile = ref.watch(selectedFileProvider);
    final fileContent = ref.watch(fileContentProvider);
    final theme = Theme.of(context);

    if (selectedFile == null) {
      return Scaffold(appBar: AppBar(title: const Text('File')), body: const Center(child: Text('No file selected')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedFile.name),
        actions: [
          // Git diff toggle button (only in view mode)
          if (!_isEditing)
            IconButton(
              icon: Icon(
                _showGitDiff ? Icons.history_toggle_off : Icons.history,
                color: _showGitDiff && _lineChanges.isNotEmpty
                    ? Colors.green
                    : null,
              ),
              tooltip: _showGitDiff ? 'Hide git changes' : 'Show git changes',
              onPressed: () => setState(() => _showGitDiff = !_showGitDiff),
            ),
          if (!_isEditing)
            IconButton(icon: const Icon(Icons.edit), onPressed: () => setState(() => _isEditing = true))
          else ...[
            if (_hasChanges)
              IconButton(icon: const Icon(Icons.save), onPressed: _saveFile),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  final content = ref.read(fileContentProvider);
                  if (content is AsyncData<String>) _controller.text = content.value;
                  _hasChanges = false;
                });
              },
            ),
          ],
        ],
      ),
      body: fileContent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (content) {
          if (!_hasChanges && _controller.text.isEmpty) _controller.text = content;

          if (_isEditing) {
            return TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(contentPadding: EdgeInsets.all(16), border: InputBorder.none),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
              onChanged: (_) => setState(() => _hasChanges = true),
            );
          }

          // Use CodeViewerWithDiff when git diff is enabled and available
          if (_showGitDiff && (_lineChanges.isNotEmpty || _isLoadingGitDiff)) {
            return CodeViewerWithDiff(
              content: content,
              changes: _lineChanges,
              showLineNumbers: true,
              selectable: true,
              fontSize: 14,
            );
          }

          // Fallback to simple SelectableText
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(content, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
          );
        },
      ),
    );
  }
}

/// Screen for viewing image files
class ImageViewerScreen extends ConsumerWidget {
  const ImageViewerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFile = ref.watch(selectedFileProvider);
    final theme = Theme.of(context);

    if (selectedFile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Image Viewer')),
        body: const Center(child: Text('No file selected')),
      );
    }

    // Get download URL for the image
    final repository = ref.read(remoteRepositoryProvider);
    final workspaceAsync = ref.read(currentWorkspaceProvider);
    final workspaceId = workspaceAsync.valueOrNull?.sharedId;
    final imageUrl = repository.getDownloadUrl(selectedFile.path, workspaceId: workspaceId);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedFile.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download',
            onPressed: () {
              // TODO: Implement download functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download started...')),
              );
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.1,
        maxScale: 5.0,
        child: Center(
          child: Image.network(
            imageUrl,
            headers: repository.getProxyHeaders(),
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
