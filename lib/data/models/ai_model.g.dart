// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIModelImpl _$$AIModelImplFromJson(Map<String, dynamic> json) =>
    _$AIModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      provider: json['provider'] as String,
      description: json['description'] as String?,
      isAvailable: json['available'] as bool? ?? true,
      aliases:
          (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$AIModelImplToJson(_$AIModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'provider': instance.provider,
      'description': instance.description,
      'available': instance.isAvailable,
      'aliases': instance.aliases,
    };

_$AIProviderImpl _$$AIProviderImplFromJson(Map<String, dynamic> json) =>
    _$AIProviderImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      models: (json['models'] as List<dynamic>)
          .map((e) => AIModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAvailable: json['available'] as bool? ?? true,
    );

Map<String, dynamic> _$$AIProviderImplToJson(_$AIProviderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'models': instance.models,
      'available': instance.isAvailable,
    };
