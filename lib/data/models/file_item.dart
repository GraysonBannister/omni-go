import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_item.freezed.dart';
part 'file_item.g.dart';

enum FileItemType { file, directory }

@freezed
class FileItem with _$FileItem {
  const factory FileItem({
    required String name,
    required String path,
    required FileItemType type,
    @Default([]) List<FileItem> children,
    @Default(false) bool isExpanded,
    @Default(false) bool isLoading,
    String? content,
    int? size,
    DateTime? modifiedAt,
  }) = _FileItem;

  const FileItem._();

  factory FileItem.fromJson(Map<String, dynamic> json) =>
      _$FileItemFromJson(json);

  factory FileItem.fromApiResponse(Map<String, dynamic> json) {
    return FileItem(
      name: json['name'] as String,
      path: json['path'] as String,
      type: (json['isDirectory'] as bool) ? FileItemType.directory : FileItemType.file,
    );
  }

  bool get isFile => type == FileItemType.file;
  bool get isDirectory => type == FileItemType.directory;
  String get extension => name.contains('.') ? name.split('.').last.toLowerCase() : '';
}

@freezed
class FileEdit with _$FileEdit {
  const factory FileEdit({
    required String path,
    required String oldString,
    required String newString,
  }) = _FileEdit;

  factory FileEdit.fromJson(Map<String, dynamic> json) =>
      _$FileEditFromJson(json);
}

@freezed
class FileSearchResult with _$FileSearchResult {
  const factory FileSearchResult({
    required String path,
    required int lineNumber,
    required String preview,
  }) = _FileSearchResult;

  factory FileSearchResult.fromJson(Map<String, dynamic> json) =>
      _$FileSearchResultFromJson(json);
}
