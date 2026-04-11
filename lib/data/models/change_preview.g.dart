// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChangePreviewDataImpl _$$ChangePreviewDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangePreviewDataImpl(
      toolCallId: json['toolCallId'] as String,
      messageId: json['messageId'] as String,
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      toolName: json['toolName'] as String,
      changeType: $enumDecode(_$ChangeTypeEnumMap, json['changeType']),
      startLine: (json['startLine'] as num).toInt(),
      endLine: (json['endLine'] as num).toInt(),
      lineCount: (json['lineCount'] as num).toInt(),
      additions: (json['additions'] as num).toInt(),
      deletions: (json['deletions'] as num).toInt(),
      diffContent: json['diffContent'] as String,
      beforeSnippet: json['beforeSnippet'] as String?,
      afterSnippet: json['afterSnippet'] as String?,
      status: $enumDecodeNullable(_$ChangeStatusEnumMap, json['status']) ??
          ChangeStatus.pending,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ChangePreviewDataImplToJson(
        _$ChangePreviewDataImpl instance) =>
    <String, dynamic>{
      'toolCallId': instance.toolCallId,
      'messageId': instance.messageId,
      'filePath': instance.filePath,
      'fileName': instance.fileName,
      'toolName': instance.toolName,
      'changeType': _$ChangeTypeEnumMap[instance.changeType]!,
      'startLine': instance.startLine,
      'endLine': instance.endLine,
      'lineCount': instance.lineCount,
      'additions': instance.additions,
      'deletions': instance.deletions,
      'diffContent': instance.diffContent,
      'beforeSnippet': instance.beforeSnippet,
      'afterSnippet': instance.afterSnippet,
      'status': _$ChangeStatusEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ChangeTypeEnumMap = {
  ChangeType.added: 'added',
  ChangeType.modified: 'modified',
  ChangeType.deleted: 'deleted',
};

const _$ChangeStatusEnumMap = {
  ChangeStatus.pending: 'pending',
  ChangeStatus.accepted: 'accepted',
  ChangeStatus.rejected: 'rejected',
};

_$ChangeSummaryImpl _$$ChangeSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ChangeSummaryImpl(
      totalPending: (json['totalPending'] as num).toInt(),
      totalAccepted: (json['totalAccepted'] as num).toInt(),
      totalRejected: (json['totalRejected'] as num).toInt(),
    );

Map<String, dynamic> _$$ChangeSummaryImplToJson(_$ChangeSummaryImpl instance) =>
    <String, dynamic>{
      'totalPending': instance.totalPending,
      'totalAccepted': instance.totalAccepted,
      'totalRejected': instance.totalRejected,
    };

_$PendingChangesResponseImpl _$$PendingChangesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PendingChangesResponseImpl(
      conversationId: json['conversationId'] as String,
      pendingChanges: (json['pendingChanges'] as List<dynamic>)
          .map((e) => ChangePreviewData.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: ChangeSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PendingChangesResponseImplToJson(
        _$PendingChangesResponseImpl instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'pendingChanges': instance.pendingChanges,
      'summary': instance.summary,
    };

_$ChangeReviewResponseImpl _$$ChangeReviewResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangeReviewResponseImpl(
      success: json['success'] as bool,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$ChangeReviewResponseImplToJson(
        _$ChangeReviewResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
    };

_$AcceptAllChangesResponseImpl _$$AcceptAllChangesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AcceptAllChangesResponseImpl(
      success: json['success'] as bool,
      accepted:
          (json['accepted'] as List<dynamic>).map((e) => e as String).toList(),
      failed: (json['failed'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );

Map<String, dynamic> _$$AcceptAllChangesResponseImplToJson(
        _$AcceptAllChangesResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'accepted': instance.accepted,
      'failed': instance.failed,
    };

_$RejectAllChangesResponseImpl _$$RejectAllChangesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RejectAllChangesResponseImpl(
      success: json['success'] as bool,
      rejected:
          (json['rejected'] as List<dynamic>).map((e) => e as String).toList(),
      failed: (json['failed'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );

Map<String, dynamic> _$$RejectAllChangesResponseImplToJson(
        _$RejectAllChangesResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'rejected': instance.rejected,
      'failed': instance.failed,
    };
