// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TerminalSessionImpl _$$TerminalSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$TerminalSessionImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Terminal',
      buffer: json['buffer'] as String? ?? '',
      currentInput: json['currentInput'] as String? ?? '',
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isConnected: json['isConnected'] as bool? ?? false,
      cols: (json['cols'] as num?)?.toInt() ?? 80,
      rows: (json['rows'] as num?)?.toInt() ?? 24,
      cwd: json['cwd'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TerminalSessionImplToJson(
        _$TerminalSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'buffer': instance.buffer,
      'currentInput': instance.currentInput,
      'history': instance.history,
      'isConnected': instance.isConnected,
      'cols': instance.cols,
      'rows': instance.rows,
      'cwd': instance.cwd,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$TerminalOutputImpl _$$TerminalOutputImplFromJson(Map<String, dynamic> json) =>
    _$TerminalOutputImpl(
      sessionId: json['sessionId'] as String,
      data: json['data'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$TerminalOutputImplToJson(
        _$TerminalOutputImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'data': instance.data,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
