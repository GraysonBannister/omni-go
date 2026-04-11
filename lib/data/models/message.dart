import 'package:flutter/foundation.dart';
import 'file_reference.dart';
import 'image_attachment.dart';

enum MessageRole { user, assistant, system }

enum MessageType { 
  text, 
  toolCall, 
  toolResult, 
  error, 
  streaming 
}

class Message {
  final String id;
  final MessageRole role;
  final MessageType type;
  final String content;
  final List<ToolCall> toolCalls;
  final String? toolName;
  final String? toolId;
  final String? error;
  final bool isComplete;
  final DateTime? timestamp;
  /// File references included in this message (e.g., files mentioned with @)
  final List<FileReference> fileReferences;
  /// Image attachments included with this message (photos from gallery or camera)
  final List<ImageAttachment> imageAttachments;
  /// AI reasoning / thinking content (populated for Thinking model variants)
  final String? reasoning;

  const Message({
    required this.id,
    required this.role,
    required this.type,
    required this.content,
    this.toolCalls = const [],
    this.toolName,
    this.toolId,
    this.error,
    this.isComplete = false,
    this.timestamp,
    this.fileReferences = const [],
    this.imageAttachments = const [],
    this.reasoning,
  });

  /// Parses content that may be a String or a List of content blocks
  static String _parseContent(dynamic content) {
    if (content == null) return '';
    if (content is String) return content;
    if (content is List) {
      // Extract text from content blocks (e.g., [{type: 'text', text: '...'}])
      return content
          .where((block) => block is Map<String, dynamic>)
          .map((block) => (block as Map<String, dynamic>)['text'] as String? ?? '')
          .join();
    }
    return content.toString();
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    // Handle missing type field from server
    var typeStr = json['type'] as String? ?? 'text';
    
    // Map JSON type strings to enum
    MessageType messageType;
    switch (typeStr) {
      case 'tool_use':
      case 'toolCall':
        messageType = MessageType.toolCall;
        break;
      case 'tool_result':
      case 'toolResult':
        messageType = MessageType.toolResult;
        break;
      case 'error':
        messageType = MessageType.error;
        break;
      case 'streaming':
        messageType = MessageType.streaming;
        break;
      case 'text':
      default:
        messageType = MessageType.text;
    }

    // Map role string to enum
    MessageRole role;
    final roleStr = json['role'] as String?;
    switch (roleStr) {
      case 'assistant':
        role = MessageRole.assistant;
        break;
      case 'system':
        role = MessageRole.system;
        break;
      case 'user':
      default:
        role = MessageRole.user;
    }

    // Parse file references if present
    List<FileReference> refs = [];
    if (json['fileReferences'] != null) {
      refs = (json['fileReferences'] as List)
          .map((r) => FileReference.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    // Parse image attachments if present
    List<ImageAttachment> images = [];
    if (json['imageAttachments'] != null) {
      images = (json['imageAttachments'] as List)
          .map((i) => ImageAttachment.fromContentBlock(i as Map<String, dynamic>))
          .toList();
    }

    // Parse tool calls if present
    List<ToolCall> calls = [];
    if (json['toolCalls'] != null) {
      calls = (json['toolCalls'] as List)
          .map((c) => ToolCall.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    return Message(
      id: json['id'] as String,
      role: role,
      type: messageType,
      content: _parseContent(json['content']),
      toolCalls: calls,
      toolName: json['toolName'] as String?,
      toolId: json['toolId'] as String?,
      error: json['error'] as String?,
      isComplete: json['isComplete'] as bool? ?? false,
      timestamp: json['timestamp'] != null 
          ? (json['timestamp'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
              : DateTime.tryParse(json['timestamp'].toString()))
          : null,
      fileReferences: refs,
      imageAttachments: images,
      reasoning: json['reasoning'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'type': type.name,
      'content': content,
      'toolCalls': toolCalls.map((c) => c.toJson()).toList(),
      if (toolName != null) 'toolName': toolName,
      if (toolId != null) 'toolId': toolId,
      if (error != null) 'error': error,
      'isComplete': isComplete,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      'fileReferences': fileReferences.map((r) => r.toJson()).toList(),
      'imageAttachments': imageAttachments.map((i) => i.toContentBlock()).toList(),
      if (reasoning != null) 'reasoning': reasoning,
    };
  }

  factory Message.user(
    String content, {
    List<FileReference>? fileReferences,
    List<ImageAttachment>? imageAttachments,
  }) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      type: MessageType.text,
      content: content,
      timestamp: DateTime.now(),
      fileReferences: fileReferences ?? const [],
      imageAttachments: imageAttachments ?? const [],
    );
    if (kDebugMode) {
      debugPrint('[Message] Created user message: id=${message.id}, type=${message.type}, references=${fileReferences?.length ?? 0}, images=${imageAttachments?.length ?? 0}');
    }
    return message;
  }

  factory Message.assistant(String content, {String? reasoning}) => Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        type: MessageType.text,
        content: content,
        timestamp: DateTime.now(),
        reasoning: reasoning,
      );

  factory Message.streaming(String content) => Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        type: MessageType.streaming,
        content: content,
        timestamp: DateTime.now(),
      );

  factory Message.toolCall(String toolName, String toolId, Map<String, dynamic> input) => Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        type: MessageType.toolCall,
        content: 'Using $toolName...',
        toolName: toolName,
        toolId: toolId,
        timestamp: DateTime.now(),
      );

  factory Message.error(String error) => Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.system,
        type: MessageType.error,
        content: error,
        error: error,
        timestamp: DateTime.now(),
      );

  Message copyWith({
    String? id,
    MessageRole? role,
    MessageType? type,
    String? content,
    List<ToolCall>? toolCalls,
    String? toolName,
    String? toolId,
    String? error,
    bool? isComplete,
    DateTime? timestamp,
    List<FileReference>? fileReferences,
    List<ImageAttachment>? imageAttachments,
    String? reasoning,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      type: type ?? this.type,
      content: content ?? this.content,
      toolCalls: toolCalls ?? this.toolCalls,
      toolName: toolName ?? this.toolName,
      toolId: toolId ?? this.toolId,
      error: error ?? this.error,
      isComplete: isComplete ?? this.isComplete,
      timestamp: timestamp ?? this.timestamp,
      fileReferences: fileReferences ?? this.fileReferences,
      imageAttachments: imageAttachments ?? this.imageAttachments,
      reasoning: reasoning ?? this.reasoning,
    );
  }
}

class ToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> input;
  final String? output;
  final bool isComplete;
  final bool isError;
  /// When the tool call finished, used for displaying elapsed duration
  final DateTime? completedAt;

  const ToolCall({
    required this.id,
    required this.name,
    required this.input,
    this.output,
    this.isComplete = false,
    this.isError = false,
    this.completedAt,
  });

  factory ToolCall.fromJson(Map<String, dynamic> json) {
    return ToolCall(
      id: json['id'] as String,
      name: json['name'] as String,
      input: json['input'] as Map<String, dynamic>? ?? {},
      output: json['output'] as String?,
      isComplete: json['isComplete'] as bool? ?? false,
      isError: json['isError'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'input': input,
      if (output != null) 'output': output,
      'isComplete': isComplete,
      'isError': isError,
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    };
  }

  ToolCall copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? input,
    String? output,
    bool? isComplete,
    bool? isError,
    DateTime? completedAt,
  }) {
    return ToolCall(
      id: id ?? this.id,
      name: name ?? this.name,
      input: input ?? this.input,
      output: output ?? this.output,
      isComplete: isComplete ?? this.isComplete,
      isError: isError ?? this.isError,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
