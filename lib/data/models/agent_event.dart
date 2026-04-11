import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_event.freezed.dart';
part 'agent_event.g.dart';

enum AgentEventType {
  streamDelta,
  turnComplete,
  toolCallStart,
  toolCallEnd,
  toolCallProgress,
  toolResultsComplete,
  permissionRequest,
  permissionGranted,
  permissionDenied,
  costUpdate,
  error,
  orchestrationTaskStart,
  orchestrationTaskEnd,
  orchestrationComplete,
  fileChange,
  changePreview,
  changeAccepted,
  changeRejected,
  userInputRequest,
  userInputResponded,
  userInputCancelled,
  connected,
  unknown,
}

@freezed
class AgentEvent with _$AgentEvent {
  const factory AgentEvent({
    required AgentEventType type,
    String? conversationId,
    String? delta,
    Map<String, dynamic>? message,
    String? toolName,
    String? toolId,
    Map<String, dynamic>? input,
    Map<String, dynamic>? result,
    String? progressMessage,
    double? totalCost,
    double? turnCost,
    String? error,
    String? taskId,
    String? capability,
    String? description,
    bool? taskSuccess,
    int? durationMs,
    String? summary,
    List<Map<String, dynamic>>? fileChanges,
    // Change preview fields
    String? filePath,
    String? fileName,
    String? changeType,
    int? startLine,
    int? endLine,
    int? lineCount,
    String? diffContent,
    String? beforeSnippet,
    String? afterSnippet,
    int? additions,
    int? deletions,
    String? status,
    String? requestId,
    String? prompt,
    String? terminalCommand,
    bool? waitForInput,
    String? placeholder,
    String? response,
    DateTime? timestamp,
  }) = _AgentEvent;

  factory AgentEvent.fromJson(Map<String, dynamic> json) =>
      _$AgentEventFromJson(json);

  factory AgentEvent.fromSseData(Map<String, dynamic> data, String? conversationId) {
    final typeStr = data['type'] as String?;
    final type = _parseEventType(typeStr);

    // Debug logging for error events
    if (type == AgentEventType.error && kDebugMode) {
      debugPrint('[AgentEvent] Error event detected');
      debugPrint('[AgentEvent] Full data: $data');
      debugPrint('[AgentEvent] Error object: ${data['error']}');
    }

    return AgentEvent(
      type: type,
      conversationId: conversationId,
      delta: data['delta']?['text'] as String?,
      message: data['message'] as Map<String, dynamic>?,
      toolName: data['toolName'] as String?,
      toolId: data['toolId'] as String?,
      input: data['input'] as Map<String, dynamic>?,
      result: data['result'] as Map<String, dynamic>?,
      progressMessage: data['message'] is String ? data['message'] as String : null,
      totalCost: (data['totalCost'] as num?)?.toDouble(),
      turnCost: (data['turnCost'] as num?)?.toDouble(),
      error: _extractErrorMessage(data['error']),
      taskId: data['taskId'] as String?,
      capability: data['capability'] as String?,
      description: data['description'] as String?,
      taskSuccess: data['success'] as bool?,
      durationMs: data['durationMs'] as int?,
      summary: data['summary'] as String?,
      fileChanges: (data['fileChanges'] as List?)?.cast<Map<String, dynamic>>(),
      // Change preview fields
      filePath: data['filePath'] as String?,
      fileName: data['fileName'] as String?,
      changeType: data['changeType'] as String?,
      startLine: data['startLine'] as int?,
      endLine: data['endLine'] as int?,
      lineCount: data['lineCount'] as int?,
      diffContent: data['diffContent'] as String?,
      beforeSnippet: data['beforeSnippet'] as String?,
      afterSnippet: data['afterSnippet'] as String?,
      additions: data['additions'] as int?,
      deletions: data['deletions'] as int?,
      status: data['status'] as String?,
      requestId: data['requestId'] as String?,
      prompt: data['prompt'] as String?,
      terminalCommand: data['terminalCommand'] as String?,
      waitForInput: data['waitForInput'] as bool?,
      placeholder: data['placeholder'] as String?,
      response: data['response'] as String?,
      timestamp: DateTime.now(),
    );
  }

  /// Extracts the error message from various nested error structures:
  /// - { "message": "..." }
  /// - { "error": { "message": "..." } }
  /// - plain string
  static String? _extractErrorMessage(dynamic errorData) {
    if (errorData == null) return null;
    if (errorData is String) return errorData.isEmpty ? null : errorData;
    if (errorData is Map<String, dynamic>) {
      // Empty map — spurious event with no actual error info
      if (errorData.isEmpty) return null;
      // Direct message field
      if (errorData['message'] is String) {
        return errorData['message'] as String;
      }
      // Nested error.message (server wraps LLM errors as { error: { message: "..." } })
      final nested = errorData['error'];
      if (nested is Map<String, dynamic> && nested['message'] is String) {
        return nested['message'] as String;
      }
      // Fallback: return string representation of the error object
      return errorData.toString();
    }
    return errorData.toString();
  }

  static AgentEventType _parseEventType(String? type) {
    return switch (type) {
      'stream_delta' => AgentEventType.streamDelta,
      'turn_complete' => AgentEventType.turnComplete,
      'tool_call_start' => AgentEventType.toolCallStart,
      'tool_call_end' => AgentEventType.toolCallEnd,
      'tool_call_progress' => AgentEventType.toolCallProgress,
      'tool_results_complete' => AgentEventType.toolResultsComplete,
      'permission_request' => AgentEventType.permissionRequest,
      'permission_granted' => AgentEventType.permissionGranted,
      'permission_denied' => AgentEventType.permissionDenied,
      'cost_update' => AgentEventType.costUpdate,
      'error' => AgentEventType.error,
      'orchestration_task_start' => AgentEventType.orchestrationTaskStart,
      'orchestration_task_end' => AgentEventType.orchestrationTaskEnd,
      'orchestration_complete' => AgentEventType.orchestrationComplete,
      'file_change' => AgentEventType.fileChange,
      'change_preview' => AgentEventType.changePreview,
      'change_accepted' => AgentEventType.changeAccepted,
      'change_rejected' => AgentEventType.changeRejected,
      'user_input_request' => AgentEventType.userInputRequest,
      'user_input_responded' => AgentEventType.userInputResponded,
      'user_input_cancelled' => AgentEventType.userInputCancelled,
      'connected' => AgentEventType.connected,
      _ => AgentEventType.unknown,
    };
  }
}
