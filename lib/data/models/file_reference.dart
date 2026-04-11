import 'file_item.dart';

/// Represents a file or folder reference in a chat message.
/// When a user types @filename in the chat, it gets parsed into this model.
class FileReference {
  /// Full path to the file or folder
  final String path;
  
  /// Display name (filename or folder name)
  final String name;
  
  /// Type: file or directory
  final FileItemType type;
  
  /// Optional: The content of the file (only for files, not directories)
  /// This is populated when sending the message to include file context
  final String? content;
  
  /// Optional: File size in bytes
  final int? size;
  
  /// Optional: Last modified timestamp
  final DateTime? modifiedAt;

  const FileReference({
    required this.path,
    required this.name,
    required this.type,
    this.content,
    this.size,
    this.modifiedAt,
  });

  /// Create a FileReference from a FileItem
  factory FileReference.fromFileItem(FileItem item, {String? content}) {
    return FileReference(
      path: item.path,
      name: item.name,
      type: item.type,
      content: content,
      size: item.size,
      modifiedAt: item.modifiedAt,
    );
  }

  /// Create from JSON
  factory FileReference.fromJson(Map<String, dynamic> json) {
    return FileReference(
      path: json['path'] as String,
      name: json['name'] as String,
      type: (json['type'] as String) == 'directory' 
          ? FileItemType.directory 
          : FileItemType.file,
      content: json['content'] as String?,
      size: json['size'] as int?,
      modifiedAt: json['modifiedAt'] != null 
          ? DateTime.parse(json['modifiedAt'] as String) 
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'type': type == FileItemType.directory ? 'directory' : 'file',
      if (content != null) 'content': content,
      if (size != null) 'size': size,
      if (modifiedAt != null) 'modifiedAt': modifiedAt!.toIso8601String(),
    };
  }

  /// Whether this reference points to a file
  bool get isFile => type == FileItemType.file;

  /// Whether this reference points to a directory
  bool get isDirectory => type == FileItemType.directory;

  /// Get the file extension (empty string for directories or files without extension)
  String get extension => isFile && name.contains('.') 
      ? name.split('.').last.toLowerCase() 
      : '';

  /// Get the display text for this reference (e.g., @filename)
  String get displayText => '@$name';
  
  /// Create a copy with modified fields
  FileReference copyWith({
    String? path,
    String? name,
    FileItemType? type,
    String? content,
    int? size,
    DateTime? modifiedAt,
  }) {
    return FileReference(
      path: path ?? this.path,
      name: name ?? this.name,
      type: type ?? this.type,
      content: content ?? this.content,
      size: size ?? this.size,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }
}
