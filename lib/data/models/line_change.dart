/// Represents the type of change for a line in a file
enum LineChangeType {
  /// Line was added (new content)
  added,

  /// Line was modified (changed content)
  modified,

  /// Line was deleted (removed content)
  deleted,
}

/// Represents a single line change in a file
class LineChange {
  /// The line number (1-indexed) in the current version of the file
  final int lineNumber;

  /// The type of change
  final LineChangeType type;

  const LineChange({
    required this.lineNumber,
    required this.type,
  });

  /// Create a LineChange from JSON
  factory LineChange.fromJson(Map<String, dynamic> json) {
    return LineChange(
      lineNumber: json['lineNumber'] as int,
      type: _parseType(json['type'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'lineNumber': lineNumber,
      'type': type.name,
    };
  }

  /// Parse a type string into LineChangeType
  static LineChangeType _parseType(String type) {
    switch (type) {
      case 'added':
        return LineChangeType.added;
      case 'modified':
        return LineChangeType.modified;
      case 'deleted':
        return LineChangeType.deleted;
      default:
        return LineChangeType.modified;
    }
  }

  @override
  String toString() => 'LineChange(lineNumber: $lineNumber, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LineChange &&
        other.lineNumber == lineNumber &&
        other.type == type;
  }

  @override
  int get hashCode => lineNumber.hashCode ^ type.hashCode;
}

/// Response from the git diff API
class GitDiffResponse {
  /// The file path
  final String path;

  /// List of line changes
  final List<LineChange> changes;

  /// Whether the file is in a git repository
  final bool isGitRepo;

  /// Whether the file has any changes
  final bool hasChanges;

  const GitDiffResponse({
    required this.path,
    required this.changes,
    this.isGitRepo = true,
    this.hasChanges = false,
  });

  /// Create a GitDiffResponse from JSON
  factory GitDiffResponse.fromJson(Map<String, dynamic> json) {
    final changesList = (json['changes'] as List<dynamic>?)
            ?.map((c) => LineChange.fromJson(c as Map<String, dynamic>))
            .toList() ??
        [];

    return GitDiffResponse(
      path: json['path'] as String? ?? '',
      changes: changesList,
      isGitRepo: json['isGitRepo'] as bool? ?? true,
      hasChanges: json['hasChanges'] as bool? ?? changesList.isNotEmpty,
    );
  }

  /// Get a map of line number to change type for quick lookup
  Map<int, LineChangeType> get changeMap {
    return Map.fromEntries(
      changes.map((c) => MapEntry(c.lineNumber, c.type)),
    );
  }

  /// Check if a specific line has changes
  bool hasChange(int lineNumber) {
    return changes.any((c) => c.lineNumber == lineNumber);
  }

  /// Get the change type for a specific line, or null if unchanged
  LineChangeType? getChangeType(int lineNumber) {
    final change = changes.firstWhere(
      (c) => c.lineNumber == lineNumber,
      orElse: () => const LineChange(lineNumber: -1, type: LineChangeType.modified),
    );
    return change.lineNumber == -1 ? null : change.type;
  }
}
