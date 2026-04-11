import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/models/change_preview.dart';
import '../../data/models/message.dart';
import 'diff_preview_card.dart';

class ChatMessageWithPreviews extends StatelessWidget {
  final Message message;
  final List<ChangePreviewData> changePreviews;
  final Function(String filePath, int line)? onNavigateToFile;
  final Function(String toolCallId)? onAcceptChange;
  final Function(String toolCallId)? onRejectChange;

  const ChatMessageWithPreviews({
    super.key,
    required this.message,
    required this.changePreviews,
    this.onNavigateToFile,
    this.onAcceptChange,
    this.onRejectChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI response text
        if (message.content.isNotEmpty)
          MarkdownBody(
            data: message.content,
            styleSheet: MarkdownStyleSheet(
              p: theme.textTheme.bodyMedium,
              code: TextStyle(
                fontFamily: 'monospace',
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),

        // Diff preview cards for each tool call
        if (changePreviews.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Changes (${changePreviews.length}):',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ...changePreviews.map((preview) => DiffPreviewCard(
            preview: preview,
            onTap: onNavigateToFile != null
                ? () => onNavigateToFile!(preview.filePath, preview.startLine)
                : null,
            onAccept: onAcceptChange != null
                ? () => onAcceptChange!(preview.toolCallId)
                : null,
            onReject: onRejectChange != null
                ? () => onRejectChange!(preview.toolCallId)
                : null,
          )),
        ],
      ],
    );
  }
}
