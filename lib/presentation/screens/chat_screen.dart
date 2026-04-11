import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/models/ai_model.dart';
import '../../data/models/conversation.dart';
import '../../data/models/file_item.dart';
import '../../data/models/file_reference.dart';
import '../../data/models/image_attachment.dart';
import '../../data/models/message.dart';
import '../../presentation/providers/ai_mode_provider.dart';
import '../../presentation/providers/chat_history_provider.dart';
import '../../presentation/providers/chat_provider.dart';
import '../../presentation/providers/files_provider.dart';
import '../../presentation/providers/model_provider.dart';
import '../../presentation/providers/workspace_provider.dart';
import '../../presentation/providers/navigation_provider.dart';
import '../../presentation/widgets/chat_image_message.dart';
import '../../presentation/widgets/chat_input_field.dart';
import '../../presentation/widgets/collapsible_tool_summary.dart';
import '../../presentation/widgets/diff_preview_card.dart';
import '../../presentation/widgets/file_changes_dialog.dart';
import '../../presentation/widgets/file_reference_chip.dart';
import '../../presentation/widgets/mode_selector.dart';
import '../../presentation/widgets/model_selector.dart';
import '../../presentation/widgets/planning_panel.dart';
import '../../presentation/widgets/thinking_section.dart';
import '../../presentation/widgets/typewriter_markdown.dart';
import '../../presentation/widgets/workspace_selector.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<FileReference> _selectedReferences = [];
  final List<ImageAttachment> _selectedImages = [];
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initConversation();
      _initChatHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // With reverse:true, position 0 = bottom, maxScrollExtent = top
    final currentScroll = _scrollController.position.pixels;
    const threshold = 100.0;
    final atBottom = currentScroll < threshold;
    if (atBottom != _isAtBottom) {
      setState(() => _isAtBottom = atBottom);
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    // With reverse:true, scrolling to bottom means going to position 0
    if (animated) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(0);
    }
    setState(() => _isAtBottom = true);
  }

  Future<void> _initConversation() async {
    final chatController = ref.read(chatControllerProvider);
    if (chatController.id.isEmpty) {
      // Wait for model to finish loading from secure storage
      // selectedModelProvider starts as null and loads asynchronously
      AIModel? selectedModel = ref.read(selectedModelProvider);
      if (selectedModel == null) {
        await Future.delayed(const Duration(milliseconds: 300));
        selectedModel = ref.read(selectedModelProvider);
      }
      final selectedMode = ref.read(selectedModeProvider);
      await ref.read(chatControllerProvider.notifier).createConversation(
        model: selectedModel?.id,
        provider: selectedModel?.provider,
        mode: selectedMode.id,
      );
    }
  }

  Future<void> _initChatHistory() async {
    try {
      final workspace = await ref.read(currentWorkspaceProvider.future);
      if (workspace != null) {
        ref.read(chatHistoryProvider.notifier).loadForWorkspace(workspace.sharedId);
      }
    } catch (_) {}
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    final hasImages = _selectedImages.isNotEmpty;

    // Allow sending if there's text or images
    if (text.isEmpty && !hasImages) return;

    _messageController.clear();

    // Send with file references if any are selected
    final refs = _selectedReferences.isNotEmpty
        ? List<FileReference>.from(_selectedReferences)
        : null;

    // Send with image attachments if any are selected
    final images = hasImages
        ? List<ImageAttachment>.from(_selectedImages)
        : null;

    ref.read(chatControllerProvider.notifier).sendMessage(
      text,
      fileReferences: refs,
      imageAttachments: images,
    );

    // Clear selected references and images after sending
    setState(() {
      _selectedReferences.clear();
      _selectedImages.clear();
    });

    // Only scroll to bottom if user is already near bottom
    if (_isAtBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  /// Groups messages into a timeline of text messages, tool call groups, and inline plan cards.
  List<_TimelineItem> _buildTimeline(
    List<Message> messages,
    Map<String, dynamic>? pendingPlan,
    String? planSourceMessageId,
  ) {
    final timeline = <_TimelineItem>[];
    final toolBuffer = <Message>[];

    for (final msg in messages) {
      final isTool = msg.type == MessageType.toolCall ||
          msg.type == MessageType.toolResult;
      if (isTool) {
        toolBuffer.add(msg);
      } else {
        if (toolBuffer.isNotEmpty) {
          timeline.add(_TimelineItem.tools(List.from(toolBuffer)));
          toolBuffer.clear();
        }
        timeline.add(_TimelineItem.message(msg));
      }
    }
    if (toolBuffer.isNotEmpty) {
      timeline.add(_TimelineItem.tools(toolBuffer));
    }

    // Inject plan card after the source message
    if (pendingPlan != null) {
      int insertIdx = -1;
      if (planSourceMessageId != null) {
        insertIdx = timeline.indexWhere(
          (item) => item.message?.id == planSourceMessageId,
        );
      }
      // Fallback: last assistant message containing <plan>
      if (insertIdx < 0) {
        for (int i = timeline.length - 1; i >= 0; i--) {
          final msg = timeline[i].message;
          if (msg != null &&
              msg.role == MessageRole.assistant &&
              msg.content.contains('<plan>')) {
            insertIdx = i;
            break;
          }
        }
      }
      final at = insertIdx >= 0 ? insertIdx + 1 : timeline.length;
      timeline.insert(at, _TimelineItem.planCard(pendingPlan));
    }

    return timeline;
  }

  /// Recursively flattens the file tree into a single list of all files and folders
  List<FileItem> _flattenFileItems(List<FileItem> items) {
    final result = <FileItem>[];
    for (final item in items) {
      result.add(item);
      if (item.children.isNotEmpty) {
        result.addAll(_flattenFileItems(item.children));
      }
    }
    return result;
  }

  /// Check if error is connection-related to show reconnect button
  bool _isConnectionError(String error) {
    final lowerError = error.toLowerCase();
    return lowerError.contains('cannot reach server') ||
           lowerError.contains('connection failed') ||
           lowerError.contains('socketexception') ||
           lowerError.contains('failed host lookup') ||
           lowerError.contains('timeout') ||
           lowerError.contains('internet') ||
           lowerError.contains('network');
  }

  void _showChatHistory() {
    ref.read(chatHistoryProvider.notifier).refresh();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => ChatHistorySheet(
        onConversationSelected: (summary) async {
          Navigator.pop(context);
          final workspace = await ref.read(currentWorkspaceProvider.future);
          if (workspace != null && mounted) {
            await ref
                .read(chatControllerProvider.notifier)
                .loadHistoricalConversation(workspace.sharedId, summary.id);
            // Scroll to bottom after loading conversation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom(animated: false);
            });
          }
        },
        onNewChat: () {
          Navigator.pop(context);
          ref.read(chatControllerProvider.notifier).clear();
          _initConversation();
        },
      ),
    );
  }

  /// Handle return to message action - shows dialog and truncates conversation
  Future<void> _onReturnToMessage(int messageIndex) async {
    final chatController = ref.read(chatControllerProvider);
    final messages = chatController.messages;

    if (messageIndex < 0 || messageIndex >= messages.length) return;

    // Show file changes dialog
    final result = await showFileChangesDialog(context);

    if (result == null) return; // User cancelled

    // Truncate messages (keepChanges: true means keep file modifications)
    await ref.read(chatControllerProvider.notifier).returnToMessage(messageIndex, keepChanges: result);

    // Scroll to bottom after truncation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatController = ref.watch(chatControllerProvider);
    final theme = Theme.of(context);
    final activeWorkspaceName = ref.watch(activeWorkspaceNameProvider);
    final pendingPlan = ref.watch(pendingPlanProvider);
    final stepStatuses = ref.watch(planStepStatusesProvider);
    final planSourceMessageId = ref.watch(planSourceMessageIdProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final planningApproach = ref.watch(planningApproachProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Chat'),
              activeWorkspaceName.when(
                data: (name) => name != null
                    ? Text(
                        name,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        actions: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Flexible(
                  flex: 2,
                  child: ModeSelectorChip(),
                ),
                const SizedBox(width: 4),
                const Flexible(
                  flex: 3,
                  child: ModelSelectorChip(),
                ),
                const SizedBox(width: 4),
                const Flexible(
                  flex: 2,
                  child: WorkspaceSelectorChip(),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Chat History',
            onPressed: _showChatHistory,
          ),
          if (chatController.isStreaming)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () => ref.read(chatControllerProvider.notifier).abort(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(chatControllerProvider.notifier).clear();
              _initConversation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatController.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('Start a conversation',
                            style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5))),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text('View past chats'),
                          onPressed: _showChatHistory,
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Builder(
                        builder: (context) {
                          final timeline = _buildTimeline(
                            chatController.messages,
                            pendingPlan,
                            planSourceMessageId,
                          );
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            // reverse:true renders from bottom up — no scroll-to-bottom
                            // on load needed since position 0 is already the bottom.
                            reverse: true,
                            itemCount: timeline.length,
                            itemBuilder: (context, index) {
                              // Reverse the index so newest items appear at the bottom
                              final actualIndex = timeline.length - 1 - index;
                              final item = timeline[actualIndex];
                              if (item.isPlanCard) {
                                return PlanningPanel(
                                  plan: item.planCard!,
                                  stepStatuses: stepStatuses,
                                  isExecuting: chatController.isStreaming,
                                  onApprove: () =>
                                      ref.read(chatControllerProvider.notifier).approvePlan(item.planCard!),
                                  onModify: (instruction) =>
                                      ref.read(chatControllerProvider.notifier).modifyPlan(instruction),
                                  onReject: () =>
                                      ref.read(chatControllerProvider.notifier).rejectPlan(),
                                  onDismiss: () =>
                                      ref.read(chatControllerProvider.notifier).dismissPlan(),
                                );
                              }
                              if (item.isTools) {
                                return Consumer(
                                  builder: (ctx, ref, _) {
                                    final toolPreviews = ref.watch(toolCallPreviewsProvider);
                                    final previews = item.tools!
                                        .where((t) => t.toolId != null && toolPreviews.containsKey(t.toolId))
                                        .map((t) => toolPreviews[t.toolId]!)
                                        .toList();
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                          child: CollapsibleToolSummary(tools: item.tools!),
                                        ),
                                        ...previews.map((preview) => DiffPreviewCard(
                                          preview: preview,
                                          onAccept: () => ref.read(chatControllerProvider.notifier).acceptToolCallChange(preview.toolCallId),
                                          onReject: () => ref.read(chatControllerProvider.notifier).rejectToolCallChange(preview.toolCallId),
                                        )),
                                      ],
                                    );
                                  },
                                );
                              }
                              final message = item.message!;
                              final msgIndex = chatController.messages.indexOf(message);
                              final isLastMessage = msgIndex == chatController.messages.length - 1;
                              return _MessageBubble(
                                message: message,
                                messageIndex: msgIndex,
                                onReturn: message.role == MessageRole.user
                                    ? () => _onReturnToMessage(msgIndex)
                                    : null,
                                isStreaming: chatController.isStreaming,
                                isLastMessage: isLastMessage,
                              );
                            },
                          );
                        },
                      ),
                      // Scroll to bottom button
                      if (!_isAtBottom)
                        Positioned(
                          bottom: 80,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: FloatingActionButton.small(
                              onPressed: () => _scrollToBottom(),
                              backgroundColor: theme.colorScheme.surface,
                              foregroundColor: theme.colorScheme.onSurface,
                              elevation: 2,
                              child: const Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          if (chatController.error != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.colorScheme.error.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(chatController.error!,
                        style: TextStyle(color: theme.colorScheme.error, fontSize: 14)),
                  ),
                  // Show reconnect button for connection errors
                  if (_isConnectionError(chatController.error!))
                    TextButton.icon(
                      onPressed: () {
                        ref.read(chatControllerProvider.notifier).clearError();
                        ref.read(chatControllerProvider.notifier).reconnectToEvents();
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: theme.colorScheme.error,
                    onPressed: () => ref.read(chatControllerProvider.notifier).clearError(),
                  ),
                ],
              ),
            ),

          Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2))),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pending changes banner — Accept All / Reject All
                    Consumer(
                      builder: (ctx, ref, _) {
                        final hasPending = ref.watch(hasPendingChangesProvider);
                        final count = ref.watch(pendingChangesCountProvider);
                        if (!hasPending) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.08),
                            border: Border(
                              top: BorderSide(color: Colors.amber.withOpacity(0.4)),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.pending_actions, color: Colors.amber, size: 16),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '$count pending',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => ref.read(chatControllerProvider.notifier).rejectAllPendingChanges(),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.error,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  visualDensity: VisualDensity.compact,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Reject', style: TextStyle(fontSize: 12)),
                              ),
                              const SizedBox(width: 4),
                              ElevatedButton(
                                onPressed: () => ref.read(chatControllerProvider.notifier).acceptAllChanges(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  visualDensity: VisualDensity.compact,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Accept', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Approach toggle — only shown in architect mode
                    if (selectedMode.id == 'architect')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.architecture,
                              size: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Approach:',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SegmentedButton<String>(
                                segments: const [
                                  ButtonSegment(
                                    value: 'one-shot',
                                    label: Text('One-shot'),
                                    icon: Icon(Icons.bolt, size: 14),
                                  ),
                                  ButtonSegment(
                                    value: 'iterative',
                                    label: Text('Iterative'),
                                    icon: Icon(Icons.loop, size: 14),
                                  ),
                                ],
                                selected: {planningApproach},
                                onSelectionChanged: (selection) {
                                  if (selection.isNotEmpty) {
                                    ref.read(planningApproachProvider.notifier).state =
                                        selection.first;
                                  }
                                },
                                style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final filesAsync = ref.watch(filesControllerProvider);
                          return ChatInputField(
                            controller: _messageController,
                            onSend: _sendMessage,
                            availableFiles: filesAsync.when(
                              data: (files) => _flattenFileItems(files),
                              loading: () => const <FileItem>[],
                              error: (_, __) => const <FileItem>[],
                            ),
                            onReferencesChanged: (refs) {
                              setState(() {
                                _selectedReferences.clear();
                                _selectedReferences.addAll(refs);
                              });
                            },
                            onImagesChanged: (images) {
                              setState(() {
                                _selectedImages.clear();
                                _selectedImages.addAll(images);
                              });
                            },
                            enabled: !chatController.isStreaming,
                            hintText: selectedMode.id == 'architect'
                                ? 'Describe the task to plan...'
                                : 'Type your message... Use @ to reference files',
                            maxLines: null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}

/// A single item in the chat timeline — either a regular message or a group of tool calls.
class _TimelineItem {
  final Message? message;
  final List<Message>? tools;
  final Map<String, dynamic>? planCard;

  const _TimelineItem._({this.message, this.tools, this.planCard});

  factory _TimelineItem.message(Message msg) => _TimelineItem._(message: msg);
  factory _TimelineItem.tools(List<Message> tools) => _TimelineItem._(tools: tools);
  factory _TimelineItem.planCard(Map<String, dynamic> plan) => _TimelineItem._(planCard: plan);

  bool get isTools => tools != null;
  bool get isPlanCard => planCard != null;
}

/// Bottom sheet showing past conversations for the current workspace
class ChatHistorySheet extends ConsumerWidget {
  final ValueChanged<ConversationSummary> onConversationSelected;
  final VoidCallback onNewChat;

  const ChatHistorySheet({
    super.key,
    required this.onConversationSelected,
    required this.onNewChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final historyState = ref.watch(chatHistoryProvider);
    final activeChatId = ref.watch(chatControllerProvider).id;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.history, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Chat History', style: theme.textTheme.titleLarge),
                      ),
                      if (historyState.isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () =>
                              ref.read(chatHistoryProvider.notifier).refresh(),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // New Chat button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('New Chat'),
                  onPressed: onNewChat,
                ),
              ),
            ),

            // Conversation list
            Expanded(
              child: Builder(builder: (context) {
                if (historyState.error != null && historyState.conversations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text('Failed to load history',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(historyState.error!,
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              ref.read(chatHistoryProvider.notifier).refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (!historyState.isLoading && historyState.conversations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('No Saved Conversations',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          'Past conversations will appear here\nonce you start chatting.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: historyState.conversations.length,
                  itemBuilder: (context, index) {
                    final summary = historyState.conversations[index];
                    final isActive = summary.id == activeChatId;
                    return _ConversationListTile(
                      summary: summary,
                      isActive: isActive,
                      onTap: () => onConversationSelected(summary),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
      },
    );
  }
}

class _ConversationListTile extends StatelessWidget {
  final ConversationSummary summary;
  final bool isActive;
  final VoidCallback onTap;

  const _ConversationListTile({
    required this.summary,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isActive ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.chat_bubble_outline,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
        ),
        title: Text(
          (summary.title?.isNotEmpty ?? false) ? summary.title! : 'Untitled',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: isActive ? FontWeight.bold : null,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Icon(Icons.message_outlined,
                size: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${summary.messageCount} msg${summary.messageCount != 1 ? 's' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.access_time,
                size: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _formatRelativeTime(summary.updatedAt ?? DateTime.now()),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: isActive
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}

class _MessageBubble extends ConsumerWidget {
  final Message message;
  final int? messageIndex;
  final VoidCallback? onReturn;
  final bool isStreaming;
  final bool isLastMessage;

  const _MessageBubble({
    required this.message,
    this.messageIndex,
    this.onReturn,
    this.isStreaming = false,
    this.isLastMessage = false,
  });

  void _copyMessage(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMessageContextMenu(BuildContext context, WidgetRef ref, String content) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height / 2,
        position.dx + size.width,
        position.dy + size.height,
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.copy, size: 18, color: Theme.of(context).colorScheme.onSurface),
              const SizedBox(width: 8),
              const Text('Copy Text'),
            ],
          ),
          onTap: () {
            // Delay to allow menu to close
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                _copyMessage(context);
              }
            });
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.select_all, size: 18, color: Theme.of(context).colorScheme.onSurface),
              const SizedBox(width: 8),
              const Text('Select All'),
            ],
          ),
          onTap: () {
            // For mobile, we copy to clipboard and show a hint
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                _copyMessage(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Text copied. Long press input field to paste.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            });
          },
        ),
      ],
    );
  }

  void _navigateToFile(WidgetRef ref, String filePath, String fileName, int line) {
    // Set the selected file and navigate to the files tab
    ref.read(selectedFileProvider.notifier).state = FileItem(
      name: fileName,
      path: filePath,
      type: FileItemType.file,
    );
    ref.read(navigationIndexProvider.notifier).state = NavigationTab.files;
  }

  Future<void> _showRevertDialog(BuildContext context, WidgetRef ref, int count) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revert changes?'),
        content: Text(
          'This will reject $count pending change${count == 1 ? '' : 's'} and restore the original file${count == 1 ? '' : 's'}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Revert'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(chatControllerProvider.notifier).rejectAllPendingChanges();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUser = message.role == MessageRole.user;
    final isError = message.type == MessageType.error;
    final displayContent = message.role == MessageRole.assistant
        ? message.content.replaceAll(RegExp(r'<plan>[\s\S]*?</plan>'), '').trim()
        : message.content;

    if (isError) {
      // Parse structured error content
      String title = 'Error';
      String errorMessage = message.content;
      String? suggestion;
      
      try {
        final parsed = jsonDecode(message.content) as Map<String, dynamic>;
        if (parsed['title'] is String) title = parsed['title']!;
        if (parsed['message'] is String) errorMessage = parsed['message']!;
        if (parsed['suggestion'] is String) suggestion = parsed['suggestion'];
      } catch (_) {
        // If parsing fails, use the raw content as the message
        errorMessage = message.content;
      }
      
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withOpacity(0.08),
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.error,
              width: 3,
            ),
          ),
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.error,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            if (suggestion != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.error.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggestion: ',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (displayContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        margin: EdgeInsets.only(top: 4, bottom: 4, left: isUser ? 32 : 0, right: isUser ? 0 : 32),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // File reference chips (only for user messages with references)
            if (isUser && message.fileReferences.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FileReferenceChipRow(
                  references: message.fileReferences,
                  compact: true,
                  maxChips: 3,
                ),
              ),

            // Image attachments (only for user messages with images)
            if (isUser && message.imageAttachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: 200,
                  child: ChatImageMessage(
                    attachments: message.imageAttachments,
                    isUser: true,
                  ),
                ),
              ),

            // Message bubble with long-press context menu
            if (displayContent.isNotEmpty)
              GestureDetector(
                onLongPress: () => _showMessageContextMenu(context, ref, displayContent),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: isUser
                      ? Text(displayContent, style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 15))
                      : (isStreaming && isLastMessage && message.role == MessageRole.assistant)
                          // Use typewriter effect for the last streaming assistant message
                          ? TypewriterMarkdown(
                              content: displayContent,
                              isStreaming: isStreaming,
                              charDelay: const Duration(milliseconds: 12),
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
                              ),
                            )
                          // Regular markdown for non-streaming or completed messages
                          : MarkdownBody(
                              data: displayContent,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
                              ),
                            ),
                ),
              ),

            // Thinking / reasoning section (only shown for Thinking model variants)
            if (!isUser &&
                message.reasoning != null &&
                message.reasoning!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: ThinkingSection(thinking: message.reasoning!),
              ),

            // Action buttons row - copy button positioned at bottom right
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Return + Revert buttons (only on user messages)
                  if (isUser)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onReturn != null)
                          _MessageActionButton(
                            icon: Icons.reply,
                            onPressed: onReturn!,
                            tooltip: 'Return to this message',
                            iconColor: theme.colorScheme.primary,
                          ),
                        // Revert button — visible only when there are pending changes
                        Consumer(
                          builder: (ctx, ref, _) {
                            final hasPending = ref.watch(hasPendingChangesProvider);
                            final count = ref.watch(pendingChangesCountProvider);
                            if (!hasPending) return const SizedBox.shrink();
                            return _MessageActionButton(
                              icon: Icons.undo,
                              onPressed: () => _showRevertDialog(context, ref, count),
                              tooltip: 'Revert $count pending change${count == 1 ? '' : 's'}',
                              iconColor: Colors.amber,
                            );
                          },
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  // Right side: Copy button (on all messages)
                  _MessageActionButton(
                    icon: Icons.copy,
                    onPressed: () => _copyMessage(context),
                    tooltip: 'Copy message',
                    iconColor: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small action button for message bubbles
class _MessageActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? iconColor;

  const _MessageActionButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              icon,
              size: 16,
              color: iconColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
