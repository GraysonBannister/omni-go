import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_preview.freezed.dart';
part 'change_preview.g.dart';

enum ChangeType {
  added,
  modified,
  deleted,
}

enum ChangeStatus {
  pending,
  accepted,
  rejected,
}

@freezed
class ChangePreviewData with _$ChangePreviewData {
  const factory ChangePreviewData({
    required String toolCallId,
    required String messageId,
    required String filePath,
    required String fileName,
    required String toolName,
    required ChangeType changeType,
    required int startLine,
    required int endLine,
    required int lineCount,
    required int additions,
    required int deletions,
    required String diffContent,
    String? beforeSnippet,
    String? afterSnippet,
    @Default(ChangeStatus.pending) ChangeStatus status,
    required DateTime timestamp,
  }) = _ChangePreviewData;

  factory ChangePreviewData.fromJson(Map<String, dynamic> json) =>
      _$ChangePreviewDataFromJson(json);

  factory ChangePreviewData.fromAgentEvent(Map<String, dynamic> data) {
    return ChangePreviewData(
      toolCallId: data['toolCallId'] as String? ?? '',
      messageId: data['messageId'] as String? ?? '',
      filePath: data['filePath'] as String? ?? '',
      fileName: data['fileName'] as String? ?? '',
      toolName: data['toolName'] as String? ?? '',
      changeType: _parseChangeType(data['changeType'] as String?),
      startLine: data['startLine'] as int? ?? 1,
      endLine: data['endLine'] as int? ?? 1,
      lineCount: data['lineCount'] as int? ?? 1,
      additions: data['additions'] as int? ?? 0,
      deletions: data['deletions'] as int? ?? 0,
      diffContent: data['diffContent'] as String? ?? '',
      beforeSnippet: data['beforeSnippet'] as String?,
      afterSnippet: data['afterSnippet'] as String?,
      status: _parseChangeStatus(data['status'] as String?),
      timestamp: DateTime.now(),
    );
  }

  static ChangeType _parseChangeType(String? type) {
    return switch (type) {
      'added' => ChangeType.added,
      'modified' => ChangeType.modified,
      'deleted' => ChangeType.deleted,
      _ => ChangeType.modified,
    };
  }

  static ChangeStatus _parseChangeStatus(String? status) {
    return switch (status) {
      'accepted' => ChangeStatus.accepted,
      'rejected' => ChangeStatus.rejected,
      _ => ChangeStatus.pending,
    };
  }
}

@freezed
class ChangeSummary with _$ChangeSummary {
  const factory ChangeSummary({
    required int totalPending,
    required int totalAccepted,
    required int totalRejected,
  }) = _ChangeSummary;

  factory ChangeSummary.fromJson(Map<String, dynamic> json) =>
      _$ChangeSummaryFromJson(json);
}

@freezed
class PendingChangesResponse with _$PendingChangesResponse {
  const factory PendingChangesResponse({
    required String conversationId,
    required List<ChangePreviewData> pendingChanges,
    required ChangeSummary summary,
  }) = _PendingChangesResponse;

  factory PendingChangesResponse.fromJson(Map<String, dynamic> json) =>
      _$PendingChangesResponseFromJson(json);
}

@freezed
class ChangeReviewResponse with _$ChangeReviewResponse {
  const factory ChangeReviewResponse({
    required bool success,
    String? error,
  }) = _ChangeReviewResponse;

  factory ChangeReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangeReviewResponseFromJson(json);
}

@freezed
class AcceptAllChangesResponse with _$AcceptAllChangesResponse {
  const factory AcceptAllChangesResponse({
    required bool success,
    required List<String> accepted,
    required List<Map<String, String>> failed,
  }) = _AcceptAllChangesResponse;

  factory AcceptAllChangesResponse.fromJson(Map<String, dynamic> json) =>
      _$AcceptAllChangesResponseFromJson(json);
}

@freezed
class RejectAllChangesResponse with _$RejectAllChangesResponse {
  const factory RejectAllChangesResponse({
    required bool success,
    required List<String> rejected,
    required List<Map<String, String>> failed,
  }) = _RejectAllChangesResponse;

  factory RejectAllChangesResponse.fromJson(Map<String, dynamic> json) =>
      _$RejectAllChangesResponseFromJson(json);
}
