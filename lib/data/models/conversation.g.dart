// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      model: json['model'] as String?,
      provider: json['provider'] as String?,
      mode: json['mode'] as String?,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isLoading: json['isLoading'] as bool? ?? false,
      isStreaming: json['isStreaming'] as bool? ?? false,
      error: json['error'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'model': instance.model,
      'provider': instance.provider,
      'mode': instance.mode,
      'messages': instance.messages,
      'isLoading': instance.isLoading,
      'isStreaming': instance.isStreaming,
      'error': instance.error,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ChatListResponseImpl _$$ChatListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatListResponseImpl(
      conversations: (json['conversations'] as List<dynamic>)
          .map((e) => ConversationSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$ChatListResponseImplToJson(
        _$ChatListResponseImpl instance) =>
    <String, dynamic>{
      'conversations': instance.conversations,
      'count': instance.count,
    };

_$ConversationSummaryImpl _$$ConversationSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationSummaryImpl(
      id: json['id'] as String,
      title: json['title'] as String?,
      model: json['model'] as String?,
      provider: json['provider'] as String?,
      mode: json['mode'] as String?,
      messageCount: (json['messageCount'] as num).toInt(),
      lastMessage: json['lastMessage'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ConversationSummaryImplToJson(
        _$ConversationSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'model': instance.model,
      'provider': instance.provider,
      'mode': instance.mode,
      'messageCount': instance.messageCount,
      'lastMessage': instance.lastMessage,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
