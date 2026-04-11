/// Represents the git status of a file
enum GitFileStatus {
  /// New file, not yet tracked by git
  untracked,

  /// File has been modified
  modified,

  /// File is staged for commit
  staged,

  /// File has been renamed
  renamed,

  /// File has been deleted
  deleted,

  /// File has merge conflicts
  conflicted,

  /// File is unchanged (not in any special state)
  unchanged,
}

/// Represents the git status of a directory
class GitDirectoryStatus {
  /// Map of filename to its git status
  final Map<String, GitFileStatus> files;

  /// Whether this directory is in a git repository
  final bool isGitRepo;

  /// Current branch name (null if not in a repo)
  final String? branch;

  const GitDirectoryStatus({
    required this.files,
    this.isGitRepo = true,
    this.branch,
  });

  /// Create an empty status for non-git directories
  const GitDirectoryStatus.notGit()
      : files = const {},
        isGitRepo = false,
        branch = null;

  /// Create a GitDirectoryStatus from JSON
  factory GitDirectoryStatus.fromJson(Map<String, dynamic> json) {
    final filesMap = <String, GitFileStatus>{};
    final filesJson = json['files'] as Map<String, dynamic>?;

    if (filesJson != null) {
      for (final entry in filesJson.entries) {
        filesMap[entry.key] = _parseStatus(entry.value as String);
      }
    }

    return GitDirectoryStatus(
      files: filesMap,
      isGitRepo: json['isGitRepo'] as bool? ?? false,
      branch: json['branch'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'files': files.map((key, value) => MapEntry(key, value.name)),
      'isGitRepo': isGitRepo,
      'branch': branch,
    };
  }

  /// Parse a status string into GitFileStatus
  static GitFileStatus _parseStatus(String status) {
    switch (status) {
      case 'untracked':
        return GitFileStatus.untracked;
      case 'modified':
        return GitFileStatus.modified;
      case 'staged':
        return GitFileStatus.staged;
      case 'renamed':
        return GitFileStatus.renamed;
      case 'deleted':
        return GitFileStatus.deleted;
      case 'conflicted':
        return GitFileStatus.conflicted;
      default:
        return GitFileStatus.unchanged;
    }
  }

  /// Get the git status for a specific file
  GitFileStatus getStatus(String filename) {
    return files[filename] ?? GitFileStatus.unchanged;
  }

  /// Check if a file has any special git status
  bool hasStatus(String filename) {
    return files.containsKey(filename);
  }

  /// Get all files with a specific status
  List<String> getFilesWithStatus(GitFileStatus status) {
    return files.entries
        .where((entry) => entry.value == status)
        .map((entry) => entry.key)
        .toList();
  }

  /// Check if there are any modified files
  bool get hasModifiedFiles =>
      files.values.any((s) => s == GitFileStatus.modified);

  /// Check if there are any untracked files
  bool get hasUntrackedFiles =>
      files.values.any((s) => s == GitFileStatus.untracked);

  /// Check if there are any staged files
  bool get hasStagedFiles =>
      files.values.any((s) => s == GitFileStatus.staged);

  /// Get the count of files with changes
  int get changedFileCount => files.length;

  @override
  String toString() =>
      'GitDirectoryStatus(isGitRepo: $isGitRepo, branch: $branch, files: ${files.length})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitDirectoryStatus &&
        other.isGitRepo == isGitRepo &&
        other.branch == branch &&
        _mapsEqual(other.files, files);
  }

  @override
  int get hashCode => isGitRepo.hashCode ^ branch.hashCode ^ files.hashCode;

  static bool _mapsEqual(Map<String, GitFileStatus> a, Map<String, GitFileStatus> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }
}
