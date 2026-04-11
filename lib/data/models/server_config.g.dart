// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServerConfigImpl _$$ServerConfigImplFromJson(Map<String, dynamic> json) =>
    _$ServerConfigImpl(
      url: json['url'] as String? ?? '',
      apiKey: json['apiKey'] as String? ?? '',
      isConnected: json['isConnected'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$ServerConfigImplToJson(_$ServerConfigImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'apiKey': instance.apiKey,
      'isConnected': instance.isConnected,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };
