import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == MessageRole.user;
    final isError = message.type == MessageType.error;

    if (isError) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withOpacity(0.1),
          border: Border(left: BorderSide(color: theme.colorScheme.error, width: 2)),
        ),
        child: Text(
          message.content,
          style: TextStyle(color: theme.colorScheme.error, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isUser ? 32 : 0,
          right: isUser ? 0 : 32,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.zero,
        ),
        child: isUser
            ? Text(
                message.content,
                style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 15),
              )
            : MarkdownBody(
                data: message.content,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
                ),
              ),
      ),
    );
  }
}
