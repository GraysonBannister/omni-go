import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/conversation.dart';
import '../../data/repositories/remote_repository.dart';
import 'server_provider.dart';
import 'workspace_provider.dart';

/// State for the chat history list
class ChatHistoryState {
  final List<ConversationSummary> conversations;
  final bool isLoading;
  final String? error;
  final String? workspaceId;

  const ChatHistoryState({
    this.conversations = const [],
    this.isLoading = false,
    this.error,
    this.workspaceId,
  });

  ChatHistoryState copyWith({
    List<ConversationSummary>? conversations,
    bool? isLoading,
    String? error,
    String? workspaceId,
    bool clearError = false,
  }) {
    return ChatHistoryState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      workspaceId: workspaceId ?? this.workspaceId,
    );
  }
}

final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, ChatHistoryState>((ref) {
  return ChatHistoryNotifier(ref);
});

class ChatHistoryNotifier extends StateNotifier<ChatHistoryState> {
  final Ref _ref;

  ChatHistoryNotifier(this._ref) : super(const ChatHistoryState()) {
    // Reload when the active workspace changes
    _ref.listen(currentWorkspaceProvider, (previous, next) {
      final newId = next.value?.sharedId;
      if (newId != null && newId != state.workspaceId) {
        loadForWorkspace(newId);
      }
    });
  }

  Future<void> loadForWorkspace(String workspaceId) async {
    state = state.copyWith(isLoading: true, workspaceId: workspaceId, clearError: true);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final conversations = await repo.fetchChatList(workspaceId);
      state = state.copyWith(
        conversations: conversations,
        isLoading: false,
        workspaceId: workspaceId,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[ChatHistory] Failed to load chats: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    if (state.workspaceId == null) {
      // Try to load from current workspace
      try {
        final workspace = await _ref.read(currentWorkspaceProvider.future);
        if (workspace != null) {
          await loadForWorkspace(workspace.sharedId);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('[ChatHistory] Failed to get current workspace: $e');
      }
      return;
    }
    await loadForWorkspace(state.workspaceId!);
  }

  void clearError() => state = state.copyWith(clearError: true);
}
