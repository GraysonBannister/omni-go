import 'package:freezed_annotation/freezed_annotation.dart';
import 'message.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    String? model,
    String? provider,
    String? mode,
    @Default([]) List<Message> messages,
    @Default(false) bool isLoading,
    @Default(false) bool isStreaming,
    String? error,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  factory Conversation.empty() => Conversation(
        id: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

/// Response from GET /api/chat/list
@freezed
class ChatListResponse with _$ChatListResponse {
  const factory ChatListResponse({
    required List<ConversationSummary> conversations,
    required int count,
  }) = _ChatListResponse;

  factory ChatListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatListResponseFromJson(json);
}

@freezed
class ConversationSummary with _$ConversationSummary {
  const factory ConversationSummary({
    required String id,
    String? title,
    String? model,
    String? provider,
    String? mode,
    required int messageCount,
    String? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConversationSummary;

  factory ConversationSummary.fromJson(Map<String, dynamic> json) =>
      _$ConversationSummaryFromJson(json);
}
