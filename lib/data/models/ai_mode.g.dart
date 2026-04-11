// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIModeImpl _$$AIModeImplFromJson(Map<String, dynamic> json) => _$AIModeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconData: const IconDataConverter().fromJson(json['iconData'] as String),
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
      systemPromptAppend: json['systemPromptAppend'] as String?,
      disabledTools: (json['disabledTools'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      temperature: (json['temperature'] as num?)?.toDouble(),
      planMode: json['planMode'] as bool? ?? false,
    );

Map<String, dynamic> _$$AIModeImplToJson(_$AIModeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconData': const IconDataConverter().toJson(instance.iconData),
      'color': const ColorConverter().toJson(instance.color),
      'systemPromptAppend': instance.systemPromptAppend,
      'disabledTools': instance.disabledTools,
      'temperature': instance.temperature,
      'planMode': instance.planMode,
    };
