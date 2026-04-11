import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/failures.dart';
import '../../data/models/agent_event.dart';
import '../../data/models/change_preview.dart';
import '../../data/models/conversation.dart';
import '../../data/models/file_reference.dart';
import '../../data/models/image_attachment.dart';
import '../../data/models/message.dart';
import '../../data/repositories/remote_repository.dart';
import 'ai_mode_provider.dart';
import 'model_provider.dart';
import 'server_provider.dart';
import 'workspace_provider.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, Conversation>((ref) {
  return ChatController(ref);
});

/// Holds the structured plan JSON emitted by the agent in architect mode.
final pendingPlanProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// The planning approach selected by the user: 'one-shot' or 'iterative'.
final planningApproachProvider = StateProvider<String>((ref) => 'one-shot');

/// Maps plan step IDs to their execution status: 'pending', 'in_progress', 'completed', 'failed'.
final planStepStatusesProvider = StateProvider<Map<String, String>>((ref) => {});

/// ID of the assistant message that produced the current pending plan.
final planSourceMessageIdProvider = StateProvider<String?>((ref) => null);

/// Map of messageId to list of change previews for that message
final messageChangePreviewsProvider = StateProvider<Map<String, List<ChangePreviewData>>>((ref) => {});

/// Whether there are any pending (unreviewed) changes
final hasPendingChangesProvider = StateProvider<bool>((ref) => false);

/// Flat map: toolCallId → ChangePreviewData, derived from messageChangePreviewsProvider
final toolCallPreviewsProvider = Provider<Map<String, ChangePreviewData>>((ref) {
  final map = ref.watch(messageChangePreviewsProvider);
  return {
    for (final list in map.values)
      for (final p in list) p.toolCallId: p,
  };
});

/// Total count of pending (unreviewed) changes
final pendingChangesCountProvider = Provider<int>((ref) {
  final map = ref.watch(messageChangePreviewsProvider);
  return map.values.expand((l) => l).where((p) => p.status == ChangeStatus.pending).length;
});

class ChatController extends StateNotifier<Conversation> {
  final Ref _ref;
  RemoteRepository? _repository;
  String? _conversationId;

  ChatController(this._ref) : super(Conversation.empty()) {
    _ref.listen(serverConnectionProvider, (previous, next) {
      if (!next.isConnected && state.id.isNotEmpty) {
        state = state.copyWith(isStreaming: false);
      }
    });
  }

  Future<void> createConversation({String? conversationId, String? model, String? provider, String? workingDirectory, String? mode}) async {
    if (kDebugMode) {
      debugPrint('[ChatController] createConversation called: conversationId=$conversationId, model=$model, provider=$provider, workingDirectory=$workingDirectory, mode=$mode');
    }

    try {
      final repo = _ref.read(remoteRepositoryProvider);
      _repository = repo;

      state = state.copyWith(isLoading: true, error: null);

      // Resolve working directory from the active workspace if not explicitly provided
      final resolvedWorkingDir = workingDirectory ??
          await _ref.read(currentWorkingDirectoryProvider.future).catchError((_) => null);

      if (kDebugMode) {
        debugPrint('[ChatController] Calling repository.createConversation, workingDirectory=$resolvedWorkingDir, mode=$mode...');
      }
      final conversation = await repo.createConversation(
        conversationId: conversationId,
        model: model,
        provider: provider,
        workingDirectory: resolvedWorkingDir,
        mode: mode,
      );

      _conversationId = conversation.id;
      if (kDebugMode) {
        debugPrint('[ChatController] Conversation created: ${_conversationId}, model=${conversation.model}, provider=${conversation.provider}, mode=${conversation.mode}');
      }
      state = conversation.copyWith(isLoading: false);

      // Apply mode to the server agent after conversation is created
      // The create-conversation endpoint also applies mode, but we call it
      // explicitly here as well in case the server didn't get the mode field
      if (mode != null) {
        try {
          await _repository!.setMode(_conversationId!, mode);
          if (kDebugMode) {
            debugPrint('[ChatController] Mode applied: $mode');
          }
        } catch (e) {
          // Non-fatal - mode defaults to code on the server side
          if (kDebugMode) {
            debugPrint('[ChatController] Failed to set mode (non-fatal): $e');
          }
        }
      }

      _connectToEvents();
    } on Failure catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController] Failure creating conversation: ${e.message}');
      }
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController] Exception creating conversation: $e');
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(
    String message, {
    List<FileReference>? fileReferences,
    List<ImageAttachment>? imageAttachments,
  }) async {
    if (_conversationId == null || _repository == null) {
      final workingDir = await _ref.read(currentWorkingDirectoryProvider.future).catchError((_) => null);
      await createConversation(workingDirectory: workingDir);
    }

    if (_conversationId == null || _repository == null) {
      state = state.copyWith(error: 'Not connected to server');
      return;
    }

    try {
      // Fetch file contents for references (only for files, not directories)
      final resolvedReferences = <FileReference>[];
      if (fileReferences != null && fileReferences.isNotEmpty) {
        for (final ref in fileReferences) {
          if (ref.isFile && ref.content == null) {
            try {
              final content = await _repository!.readFile(ref.path);
              resolvedReferences.add(ref.copyWith(content: content));
            } catch (e) {
              // If we can't read the file, include it without content
              if (kDebugMode) {
                debugPrint('[ChatController] Could not read file ${ref.path}: $e');
              }
              resolvedReferences.add(ref);
            }
          } else {
            resolvedReferences.add(ref);
          }
        }
      }

      // Encode images for transmission (convert to base64)
      List<ImageAttachment>? encodedImages;
      if (imageAttachments != null && imageAttachments.isNotEmpty) {
        encodedImages = [];
        for (final image in imageAttachments) {
          try {
            final encoded = await image.encodeForTransmission();
            encodedImages.add(encoded);
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[ChatController] Could not encode image ${image.fileName}: $e');
            }
          }
        }
      }

      // Display the original message to the user
      final userMessage = Message.user(
        message,
        fileReferences: resolvedReferences,
        imageAttachments: encodedImages,
      );
      state = state.copyWith(
        messages: [...state.messages, userMessage],
        isLoading: true,
        isStreaming: true,
        error: null,
      );

      // In architect mode with one-shot approach, prefix the API message
      final selectedMode = _ref.read(selectedModeProvider);
      final approach = _ref.read(planningApproachProvider);
      final apiMessage = (selectedMode.id == 'architect' && approach == 'one-shot')
          ? '[Generate the complete plan immediately without asking clarifying questions]\n\n$message'
          : message;

      final workingDir = await _ref.read(currentWorkingDirectoryProvider.future).catchError((_) => null);
      await _repository!.sendMessage(
        _conversationId!,
        apiMessage,
        workingDirectory: workingDir,
        fileReferences: resolvedReferences.isNotEmpty ? resolvedReferences : null,
        images: encodedImages?.isNotEmpty == true ? encodedImages : null,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, isStreaming: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, isStreaming: false, error: e.toString());
    }
  }

  void _connectToEvents() {
    if (_conversationId == null || _repository == null) return;

    _repository!.connectToAgentEvents(
      _conversationId!,
      onEvent: _handleAgentEvent,
      onError: (failure) => state = state.copyWith(isLoading: false, isStreaming: false, error: failure.message),
      onConnect: () { if (kDebugMode) debugPrint('Connected to agent events'); },
      onDisconnect: () { if (kDebugMode) debugPrint('Disconnected from agent events'); },
    );
  }

  /// Reconnect to agent events after app returns from background.
  /// This should be called when the app resumes and connection has been re-established.
  void reconnectToEvents() {
    if (_conversationId == null) {
      if (kDebugMode) {
        debugPrint('[ChatController] Cannot reconnect - no active conversation');
      }
      return;
    }

    // Get fresh repository reference
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      _repository = repo;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController] Failed to get repository for reconnect: $e');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('[ChatController] Reconnecting to agent events for conversation: $_conversationId');
    }

    // Clear any previous error related to disconnection
    if (state.error != null &&
        (state.error!.contains('Cannot reach server') ||
         state.error!.contains('Connection failed') ||
         state.error!.contains('SocketException'))) {
      state = state.copyWith(error: null);
    }

    _connectToEvents();
  }

  /// Handle app returning from background.
  /// Call this from the lifecycle observer to manage connection state.
  Future<void> handleAppResumed() async {
    // If we have an active conversation, try to reconnect to events
    if (_conversationId != null && state.isStreaming) {
      if (kDebugMode) {
        debugPrint('[ChatController] App resumed with active streaming, checking connection');
      }

      // Reset streaming state since connection was likely dropped
      state = state.copyWith(isStreaming: false, isLoading: false);

      // Reconnect will be handled by the server connection verification
      reconnectToEvents();
    }
  }

  void _handleAgentEvent(AgentEvent event) {
    if (kDebugMode) {
      debugPrint('[ChatController] Agent event received: ${event.type}');
    }

    switch (event.type) {
      case AgentEventType.streamDelta:
        if (kDebugMode) {
          debugPrint('[ChatController] Stream delta received');
        }
        // Reactivate streaming if we're receiving new content after turn complete
        if (!state.isStreaming) {
          state = state.copyWith(isStreaming: true, isLoading: true);
        }
        _handleStreamDelta(event.delta);
        break;
      case AgentEventType.turnComplete:
        if (kDebugMode) {
          debugPrint('[ChatController] Turn complete');
        }
        _handleTurnComplete(event);
        break;
      case AgentEventType.toolCallStart:
        if (event.toolId != null && event.toolName != null) {
          final toolMessage = Message(
            id: event.toolId!,
            role: MessageRole.assistant,
            type: MessageType.toolCall,
            content: 'Using ${event.toolName}...',
            toolName: event.toolName,
            toolId: event.toolId,
            toolCalls: [
              ToolCall(
                id: event.toolId!,
                name: event.toolName!,
                input: event.input ?? {},
                isComplete: false,
              ),
            ],
            isComplete: false,
            timestamp: event.timestamp,
          );
          state = state.copyWith(messages: [...state.messages, toolMessage]);
        }
        break;

      case AgentEventType.toolCallEnd:
        if (event.toolId != null) {
          final messages = [...state.messages];
          final idx = messages.indexWhere(
            (m) => m.toolId == event.toolId && m.type == MessageType.toolCall,
          );
          if (idx != -1) {
            final existing = messages[idx];
            final result = event.result;
            final output = result?['content'] is String ? result!['content'] as String : null;
            final isError = result?['isError'] == true;
            final completedAt = DateTime.now();
            final updatedCalls = existing.toolCalls.map((c) {
              if (c.id == event.toolId) {
                return c.copyWith(
                  output: output,
                  isComplete: true,
                  isError: isError,
                  completedAt: completedAt,
                );
              }
              return c;
            }).toList();
            messages[idx] = existing.copyWith(
              toolCalls: updatedCalls,
              isComplete: true,
              type: isError ? MessageType.error : MessageType.toolCall,
            );
            state = state.copyWith(messages: messages);
          }
        }
        break;

      case AgentEventType.toolResultsComplete:
        if (kDebugMode) {
          debugPrint('[ChatController] Tool results complete, preparing for next response');
        }
        // Tool results are ready, agent will respond next
        state = state.copyWith(isLoading: true);
        break;

      case AgentEventType.fileChange:
        _handleFileChangeForPlan(event.fileChanges);
        break;

      case AgentEventType.changePreview:
        _handleChangePreview(event);
        break;

      case AgentEventType.changeAccepted:
        _handleChangeAccepted(event.toolId ?? '');
        break;

      case AgentEventType.changeRejected:
        _handleChangeRejected(event.toolId ?? '');
        break;

      case AgentEventType.error:
        if (kDebugMode) {
          debugPrint('[ChatController] Error event: ${event.error}');
        }
        // Ignore empty/null error payloads — server occasionally emits {"error":{}}
        final errorMsg = event.error;
        if (errorMsg != null && errorMsg.isNotEmpty) {
          // Add structured error message to conversation
          final errorDetails = _classifyError(errorMsg);
          final errorMessage = Message(
            id: 'error-${DateTime.now().millisecondsSinceEpoch}-${errorMsg.hashCode}',
            role: MessageRole.system,
            type: MessageType.error,
            content: jsonEncode(errorDetails),
            timestamp: DateTime.now(),
          );
          state = state.copyWith(
            messages: [...state.messages, errorMessage],
            isLoading: false,
            isStreaming: false,
            error: errorMsg,
          );
        } else {
          state = state.copyWith(isLoading: false, isStreaming: false);
        }
        break;
      default:
        if (kDebugMode) debugPrint('Unhandled event type: ${event.type}');
    }
  }

  void _handleFileChangeForPlan(List<Map<String, dynamic>>? fileChanges) {
    if (fileChanges == null || fileChanges.isEmpty) return;
    final plan = _ref.read(pendingPlanProvider);
    if (plan == null) return;

    final steps = plan['steps'] as List<dynamic>? ?? [];
    final currentStatuses = Map<String, String>.from(_ref.read(planStepStatusesProvider));
    var updated = false;

    for (final change in fileChanges) {
      final filePath = change['filePath'] as String? ?? '';
      if (filePath.isEmpty) continue;

      for (final step in steps) {
        final stepMap = step as Map<String, dynamic>;
        final stepId = stepMap['id'] as String? ?? '';
        final stepFiles = (stepMap['files'] as List<dynamic>?)?.cast<String>() ?? [];

        for (final planFile in stepFiles) {
          if (filePath.endsWith(planFile) || planFile.endsWith(filePath)) {
            if (currentStatuses[stepId] != 'completed') {
              currentStatuses[stepId] = 'completed';
              updated = true;
            }
          }
        }
      }
    }

    if (updated) {
      _ref.read(planStepStatusesProvider.notifier).state = currentStatuses;
      _saveStepStatuses(currentStatuses);
    }
  }

  Future<void> _saveStepStatuses(Map<String, String> statuses) async {
    if (_conversationId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'plan_statuses_$_conversationId',
        jsonEncode(statuses),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatController] Failed to save step statuses: $e');
    }
  }

  Future<Map<String, String>> _loadStepStatuses(String conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('plan_statuses_$conversationId');
      if (raw == null) return {};
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as String));
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatController] Failed to load step statuses: $e');
      return {};
    }
  }

  /// Scans loaded messages in reverse for the most recent plan block and restores
  /// both the plan and any persisted step statuses.
  Future<void> _restorePlanFromMessages(List<Message> messages, String conversationId) async {
    for (var i = messages.length - 1; i >= 0; i--) {
      final msg = messages[i];
      if (msg.role == MessageRole.assistant && msg.content.contains('<plan>')) {
        _detectAndStorePlan(msg.content, sourceMessageId: msg.id);
        final statuses = await _loadStepStatuses(conversationId);
        if (statuses.isNotEmpty) {
          _ref.read(planStepStatusesProvider.notifier).state = statuses;
        }
        if (kDebugMode) {
          debugPrint('[ChatController] Restored plan from history (step statuses: ${statuses.length})');
        }
        return;
      }
    }
  }

  void _handleStreamDelta(String? delta) {
    if (kDebugMode) {
      debugPrint('[ChatController:delta] Received delta: "${delta != null ? delta.substring(0, delta.length > 100 ? 100 : delta.length) : 'null'}${delta != null && delta.length > 100 ? '...' : ''}"');
    }
    if (delta == null || delta.isEmpty) {
      if (kDebugMode) {
        debugPrint('[ChatController:delta] Stream delta is null or empty, returning');
      }
      return;
    }

    final messages = [...state.messages];
    if (messages.isNotEmpty && messages.last.type == MessageType.streaming) {
      final lastMessage = messages.last;
      messages[messages.length - 1] = lastMessage.copyWith(content: lastMessage.content + delta);
    } else {
      messages.add(Message.streaming(delta));
    }
    state = state.copyWith(messages: messages);
  }

  void _handleTurnComplete(AgentEvent event) {
    if (kDebugMode) {
      debugPrint('[ChatController:turnComplete] Turn complete received, finalizing message');
    }
    final messages = [...state.messages];
    String? finalContent;
    if (messages.isNotEmpty && messages.last.type == MessageType.streaming) {
      final lastMessage = messages.last;
      finalContent = lastMessage.content;
      // Use the server's message ID so that change previews (stored by server ID) resolve correctly
      final serverId = event.message?['id'] as String?;
      final finalId = serverId ?? lastMessage.id;
      final reasoning = event.message?['reasoning'] as String?;
      messages[messages.length - 1] = Message(
        id: finalId,
        role: MessageRole.assistant,
        type: MessageType.text,
        content: finalContent,
        reasoning: reasoning,
        timestamp: DateTime.now(),
      );
      if (kDebugMode) {
        debugPrint('[ChatController:turnComplete] Finalized streaming message, id=$finalId, length=${finalContent.length}, hasReasoning=${reasoning != null}');
      }
    }
    state = state.copyWith(messages: messages, isLoading: false, isStreaming: false);

    // Detect structured plan in the completed message
    if (finalContent != null) {
      final sourceId = messages.isNotEmpty ? messages.last.id : null;
      _detectAndStorePlan(finalContent, sourceMessageId: sourceId);
    }

    if (kDebugMode) {
      debugPrint('[ChatController:turnComplete] Turn complete handled, isLoading=false, isStreaming=false');
    }
  }

  void _detectAndStorePlan(String content, {String? sourceMessageId}) {
    final planRegex = RegExp(r'<plan>([\s\S]*?)</plan>', caseSensitive: false);
    final match = planRegex.firstMatch(content);
    if (match == null) return;

    final jsonStr = match.group(1)?.trim();
    if (jsonStr == null || jsonStr.isEmpty) return;

    try {
      final plan = jsonDecode(jsonStr) as Map<String, dynamic>;
      _ref.read(pendingPlanProvider.notifier).state = plan;
      _ref.read(planStepStatusesProvider.notifier).state = {};
      if (sourceMessageId != null) {
        _ref.read(planSourceMessageIdProvider.notifier).state = sourceMessageId;
      }
      if (kDebugMode) {
        debugPrint('[ChatController] Plan detected and stored: ${plan['title']}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController] Failed to parse plan JSON: $e');
      }
    }
  }

  /// Load a historical conversation from disk for viewing and optionally continuing.
  /// After loading, the user can send new messages which will be appended.
  Future<void> loadHistoricalConversation(String workspaceId, String conversationId) async {
    if (kDebugMode) {
      debugPrint('[ChatController:load] Starting to load conversation: workspaceId=$workspaceId, conversationId=$conversationId');
    }
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      _repository = repo;

      state = state.copyWith(isLoading: true, error: null);

      if (kDebugMode) {
        debugPrint('[ChatController:load] Calling repository.loadConversation...');
      }
      final conversation = await repo.loadConversation(workspaceId, conversationId);
      if (kDebugMode) {
        debugPrint('[ChatController:load] Repository returned conversation: ${conversation != null ? 'found' : 'null'}');
      }
      if (conversation == null) {
        state = state.copyWith(isLoading: false, error: 'Conversation not found');
        return;
      }

      // Disconnect any existing event stream
      _repository?.disconnectFromAgentEvents();

      _conversationId = conversationId;
      // Reset runtime flags that don't apply to loaded history
      state = conversation.copyWith(
        isLoading: false,
        isStreaming: false,
        error: null,
      );

      // Restore any plan that was generated in this conversation
      await _restorePlanFromMessages(conversation.messages, conversationId);

      // Re-create or resume the conversation on the server so new messages can be appended
      if (kDebugMode) {
        debugPrint('[ChatController:load] Re-creating conversation on server...');
      }
      final workingDir = await _ref.read(currentWorkingDirectoryProvider.future).catchError((_) => null);
      if (kDebugMode) {
        debugPrint('[ChatController:load] Using workingDirectory=$workingDir');
      }
      try {
        // Get model and provider from the loaded conversation, or use defaults from settings
        final selectedModel = _ref.read(selectedModelProvider);
        final model = conversation.model ?? selectedModel?.id;
        final provider = conversation.provider ?? selectedModel?.provider;
        
        if (kDebugMode) {
          debugPrint('[ChatController:load] Creating conversation with model=$model, provider=$provider');
        }
        
        await repo.createConversation(
          conversationId: conversationId, 
          workingDirectory: workingDir,
          model: model,
          provider: provider,
        );
      } catch (e) {
        // 400 means conversation already exists on server — that's fine, just continue
        if (kDebugMode) {
          debugPrint('[ChatController:load] Conversation already exists on server (ok): $e');
        }
      }
      if (kDebugMode) {
        debugPrint('[ChatController:load] Conversation loaded successfully, connecting to events');
      }
      _connectToEvents();
    } on Failure catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController:load] Failure loading conversation: ${e.message}');
      }
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController:load] Exception loading conversation: $e');
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Return to a previous message index, optionally discarding file changes
  Future<void> returnToMessage(int messageIndex, {bool keepChanges = true}) async {
    if (_conversationId == null || _repository == null) return;
    if (messageIndex < 0 || messageIndex >= state.messages.length) return;

    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get the user message at the specified index
      final targetMessage = state.messages[messageIndex];
      if (targetMessage.role != MessageRole.user) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // Truncate messages on server
      await _repository!.truncateMessages(_conversationId!, messageIndex);

      // Update local state with truncated message list
      final truncatedMessages = state.messages.sublist(0, messageIndex);
      state = state.copyWith(messages: truncatedMessages, isLoading: false);

      if (kDebugMode) {
        debugPrint('[ChatController:returnToMessage] Truncated to message index: $messageIndex');
      }
    } on Failure catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController:returnToMessage] Failure: ${e.message}');
      }
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ChatController:returnToMessage] Exception: $e');
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> abort() async {
    if (_conversationId == null || _repository == null) return;
    try {
      await _repository!.abortConversation(_conversationId!);
      state = state.copyWith(isLoading: false, isStreaming: false);
    } catch (e) { if (kDebugMode) debugPrint('Failed to abort: $e'); }
  }

  /// Approve the pending plan: switch to code mode and send an execution instruction.
  Future<void> approvePlan(Map<String, dynamic> plan) async {
    if (_conversationId == null || _repository == null) return;

    try {
      await _repository!.setMode(_conversationId!, 'code');
      _ref.read(selectedModeProvider.notifier).selectModeById('code');
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatController] Failed to switch to code mode: $e');
    }

    final executionPrompt =
        'Execute the approved plan below step by step. Complete all file changes for each step before moving to the next.\n\n'
        '<approved_plan>\n${jsonEncode(plan)}\n</approved_plan>';

    await sendMessage(executionPrompt);
  }

  /// Reject the pending plan and clear all plan state.
  void rejectPlan() {
    _clearPlanState();
  }

  /// Clear the plan and send a modification request to the agent.
  Future<void> modifyPlan(String instruction) async {
    _clearPlanState();
    await sendMessage(instruction);
  }

  /// Dismiss the plan panel after execution is complete.
  void dismissPlan() {
    _clearPlanState();
  }

  void _clearPlanState() {
    _ref.read(pendingPlanProvider.notifier).state = null;
    _ref.read(planStepStatusesProvider.notifier).state = {};
    _ref.read(planSourceMessageIdProvider.notifier).state = null;
    if (_conversationId != null) {
      SharedPreferences.getInstance().then(
        (prefs) => prefs.remove('plan_statuses_$_conversationId'),
      );
    }
  }

  // Change Review Methods

  void _handleChangePreview(AgentEvent event) {
    final messageId = event.message?['id'] as String? ?? '';
    if (messageId.isEmpty) return;

    final preview = ChangePreviewData.fromAgentEvent({
      'toolCallId': event.toolId,
      'messageId': messageId,
      'filePath': event.filePath,
      'fileName': event.fileName,
      'toolName': event.toolName,
      'changeType': event.changeType,
      'startLine': event.startLine,
      'endLine': event.endLine,
      'lineCount': event.lineCount,
      'diffContent': event.diffContent,
      'beforeSnippet': event.beforeSnippet,
      'afterSnippet': event.afterSnippet,
      'additions': event.additions,
      'deletions': event.deletions,
      'status': event.status,
    });

    final currentPreviews = Map<String, List<ChangePreviewData>>.from(
      _ref.read(messageChangePreviewsProvider),
    );
    final messagePreviews = List<ChangePreviewData>.from(
      currentPreviews[messageId] ?? [],
    );
    messagePreviews.add(preview);
    currentPreviews[messageId] = messagePreviews;
    _ref.read(messageChangePreviewsProvider.notifier).state = currentPreviews;

    // Update has pending changes
    _updateHasPendingChanges(currentPreviews);

    if (kDebugMode) {
      debugPrint('[ChatController] Change preview added: ${preview.filePath}:${preview.startLine}');
    }
  }

  void _handleChangeAccepted(String toolCallId) {
    _updateChangeStatus(toolCallId, ChangeStatus.accepted);
  }

  void _handleChangeRejected(String toolCallId) {
    _updateChangeStatus(toolCallId, ChangeStatus.rejected);
  }

  void _updateChangeStatus(String toolCallId, ChangeStatus newStatus) {
    final currentPreviews = Map<String, List<ChangePreviewData>>.from(
      _ref.read(messageChangePreviewsProvider),
    );

    for (final entry in currentPreviews.entries) {
      final updatedPreviews = entry.value.map((preview) {
        if (preview.toolCallId == toolCallId) {
          return preview.copyWith(status: newStatus);
        }
        return preview;
      }).toList();
      currentPreviews[entry.key] = updatedPreviews;
    }

    _ref.read(messageChangePreviewsProvider.notifier).state = currentPreviews;
    _updateHasPendingChanges(currentPreviews);

    if (kDebugMode) {
      debugPrint('[ChatController] Change $toolCallId marked as ${newStatus.name}');
    }
  }

  void _updateHasPendingChanges(Map<String, List<ChangePreviewData>> previews) {
    final hasPending = previews.values.any(
      (list) => list.any((p) => p.status == ChangeStatus.pending),
    );
    _ref.read(hasPendingChangesProvider.notifier).state = hasPending;
  }

  /// Accept a specific tool call change
  Future<void> acceptToolCallChange(String toolCallId) async {
    if (_conversationId == null || _repository == null) return;

    try {
      final currentPreviews = _ref.read(messageChangePreviewsProvider);
      ChangePreviewData? preview;

      for (final list in currentPreviews.values) {
        preview = list.firstWhere(
          (p) => p.toolCallId == toolCallId,
          orElse: () => null as ChangePreviewData,
        );
        if (preview != null) break;
      }

      if (preview == null) return;

      final response = await _repository!.respondToChangeReview(
        conversationId: _conversationId!,
        messageId: preview.messageId,
        toolCallId: toolCallId,
        decision: 'accept',
      );

      if (response.success) {
        _handleChangeAccepted(toolCallId);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatController] Failed to accept change: $e');
    }
  }

  /// Reject a specific tool call change
  Future<void> rejectToolCallChange(String toolCallId) async {
    if (_conversationId == null || _repository == null) return;

    try {
      final currentPreviews = _ref.read(messageChangePreviewsProvider);
      ChangePreviewData? preview;

      for (final list in currentPreviews.values) {
        preview = list.firstWhere(
          (p) => p.toolCallId == toolCallId,
          orElse: () => null as ChangePreviewData,
        );
        if (preview != null) break;
      }

      if (preview == null) return;

      final response = await _repository!.respondToChangeReview(
        conversationId: _conversationId!,
        messageId: preview.messageId,
        toolCallId: toolCallId,
        decision: 'reject',
      );

      if (response.success) {
        _handleChangeRejected(toolCallId);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatController] Failed to reject change: $e');
    }
  }

  /// Accept all pending changes
  Future<void> acceptAllChanges() async {
    if (_conversationId == null || _repository == null) return;

    try {
      final response = await _repository!.acceptAllChanges(_conversationId!);

      if (response.success) {
        for (final toolCallId in response.accepted) {
          _handleChangeAccepted(toolCallId);
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatController] Failed to accept all changes: $e');
    }
  }

  /// Reject all pending changes
  Future<void> rejectAllChanges(String messageId) async {
    if (_conversationId == null || _repository == null) return;

    try {
      final response = await _repository!.rejectAllChanges(
        conversationId: _conversationId!,
        messageId: messageId,
      );

      if (response.success) {
        for (final toolCallId in response.rejected) {
          _handleChangeRejected(toolCallId);
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatController] Failed to reject all changes: $e');
    }
  }

  /// Reject all pending changes across all turns (groups by messageId and calls rejectAllChanges per group)
  Future<void> rejectAllPendingChanges() async {
    final previews = _ref.read(messageChangePreviewsProvider);
    final pendingMessageIds = previews.entries
        .where((e) => e.value.any((p) => p.status == ChangeStatus.pending))
        .map((e) => e.key)
        .toSet();
    for (final msgId in pendingMessageIds) {
      await rejectAllChanges(msgId);
    }
  }

  /// Get change previews for a specific message
  List<ChangePreviewData> getChangePreviewsForMessage(String messageId) {
    final previews = _ref.read(messageChangePreviewsProvider);
    return previews[messageId] ?? [];
  }

  /// Check if there are pending changes
  bool get hasPendingChanges => _ref.read(hasPendingChangesProvider);

  void clearError() => state = state.copyWith(error: null);

  /// Classifies an error message into categories with titles and suggestions
  Map<String, dynamic> _classifyError(String errorMessage) {
    final lowerMsg = errorMessage.toLowerCase();

    // Quota / rate limit errors
    if (lowerMsg.contains('monthly spend') ||
        lowerMsg.contains('limit reached') ||
        lowerMsg.contains('quota exceeded') ||
        lowerMsg.contains('rate limit') ||
        lowerMsg.contains('too many requests') ||
        lowerMsg.contains('429')) {
      return {
        'type': 'quota_exceeded',
        'title': 'Usage Limit Reached',
        'message': errorMessage,
        'suggestion': 'Check your provider settings to increase the limit or wait until your quota resets.',
      };
    }

    // Model not supported errors
    if (lowerMsg.contains('model') &&
        (lowerMsg.contains('not supported') ||
            lowerMsg.contains('not found') ||
            lowerMsg.contains('does not support') ||
            lowerMsg.contains('invalid model') ||
            (lowerMsg.contains('thinking') && lowerMsg.contains('not supported')))) {
      return {
        'type': 'unsupported_model',
        'title': 'Model Not Available',
        'message': errorMessage,
        'suggestion': 'Try switching to a different model in Settings > Providers.',
      };
    }

    // Authentication / API key errors
    if (lowerMsg.contains('authentication') ||
        lowerMsg.contains('api key') ||
        lowerMsg.contains('unauthorized') ||
        lowerMsg.contains('invalid key') ||
        lowerMsg.contains('401') ||
        lowerMsg.contains('403')) {
      return {
        'type': 'auth_error',
        'title': 'Authentication Failed',
        'message': errorMessage,
        'suggestion': 'Check your API key in Settings > Providers and ensure it\'s valid.',
      };
    }

    // Network / connection errors
    if (lowerMsg.contains('network') ||
        lowerMsg.contains('connection') ||
        lowerMsg.contains('timeout') ||
        lowerMsg.contains('econnrefused') ||
        lowerMsg.contains('enotfound') ||
        lowerMsg.contains('socket hang up')) {
      return {
        'type': 'network_error',
        'title': 'Connection Failed',
        'message': errorMessage,
        'suggestion': 'Check your internet connection and try again.',
      };
    }

    // Unknown / default
    return {
      'type': 'unknown_error',
      'title': 'An Error Occurred',
      'message': errorMessage,
      'suggestion': 'Please try again or check the console for more details.',
    };
  }

  void clear() {
    _repository?.disconnectFromAgentEvents();
    _clearPlanState();
    _clearChangeReviewState();
    state = Conversation.empty();
    _conversationId = null;
  }

  void _clearChangeReviewState() {
    _ref.read(messageChangePreviewsProvider.notifier).state = {};
    _ref.read(hasPendingChangesProvider.notifier).state = false;
  }
}
