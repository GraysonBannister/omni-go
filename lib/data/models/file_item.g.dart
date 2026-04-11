// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileItemImpl _$$FileItemImplFromJson(Map<String, dynamic> json) =>
    _$FileItemImpl(
      name: json['name'] as String,
      path: json['path'] as String,
      type: $enumDecode(_$FileItemTypeEnumMap, json['type']),
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => FileItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isExpanded: json['isExpanded'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      content: json['content'] as String?,
      size: (json['size'] as num?)?.toInt(),
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
    );

Map<String, dynamic> _$$FileItemImplToJson(_$FileItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'type': _$FileItemTypeEnumMap[instance.type]!,
      'children': instance.children,
      'isExpanded': instance.isExpanded,
      'isLoading': instance.isLoading,
      'content': instance.content,
      'size': instance.size,
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
    };

const _$FileItemTypeEnumMap = {
  FileItemType.file: 'file',
  FileItemType.directory: 'directory',
};

_$FileEditImpl _$$FileEditImplFromJson(Map<String, dynamic> json) =>
    _$FileEditImpl(
      path: json['path'] as String,
      oldString: json['oldString'] as String,
      newString: json['newString'] as String,
    );

Map<String, dynamic> _$$FileEditImplToJson(_$FileEditImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'oldString': instance.oldString,
      'newString': instance.newString,
    };

_$FileSearchResultImpl _$$FileSearchResultImplFromJson(
        Map<String, dynamic> json) =>
    _$FileSearchResultImpl(
      path: json['path'] as String,
      lineNumber: (json['lineNumber'] as num).toInt(),
      preview: json['preview'] as String,
    );

Map<String, dynamic> _$$FileSearchResultImplToJson(
        _$FileSearchResultImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'lineNumber': instance.lineNumber,
      'preview': instance.preview,
    };
