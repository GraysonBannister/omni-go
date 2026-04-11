import 'package:flutter/material.dart';
import '../../data/models/change_preview.dart';

class DiffPreviewCard extends StatelessWidget {
  final ChangePreviewData preview;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const DiffPreviewCard({
    super.key,
    required this.preview,
    this.onTap,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = preview.status == ChangeStatus.pending;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child:       InkWell(
        onTap: isPending ? onTap : null,
        borderRadius: BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: File path + line number + stats
              Row(
                children: [
                  Icon(
                    Icons.description,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${preview.fileName}:${preview.startLine}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStats(theme),
                ],
              ),
              const SizedBox(height: 8),

              // Status indicator (if not pending)
              if (!isPending) _buildStatusChip(theme),

              // Diff snippet (truncated)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.all(8),
                child: _buildDiffSnippet(theme),
              ),

              const SizedBox(height: 8),

              // Action buttons (if pending)
              if (isPending && (onAccept != null || onReject != null))
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onReject != null)
                      TextButton.icon(
                        onPressed: onReject,
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Reject'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (onAccept != null)
                      ElevatedButton.icon(
                        onPressed: onAccept,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                )
              else if (isPending && onTap != null)
                // Tap hint
                Text(
                  'Tap to review in file',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (preview.additions > 0)
          _buildStatChip(
            '+${preview.additions}',
            Colors.green,
            theme,
          ),
        if (preview.deletions > 0)
          _buildStatChip(
            '-${preview.deletions}',
            Colors.red,
            theme,
          ),
      ],
    );
  }

  Widget _buildStatChip(String text, Color color, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.zero,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final isAccepted = preview.status == ChangeStatus.accepted;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
        color: isAccepted
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAccepted ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isAccepted ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isAccepted ? 'Accepted' : 'Rejected',
            style: TextStyle(
              color: isAccepted ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiffSnippet(ThemeData theme) {
    final lines = preview.diffContent.split('\n').take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        Color bgColor = Colors.transparent;
        Color textColor = theme.colorScheme.onSurface;
        String displayLine = line;

        if (line.startsWith('+') && !line.startsWith('+++')) {
          bgColor = Colors.green.withOpacity(0.15);
          textColor = Colors.green;
          displayLine = line.substring(1);
        } else if (line.startsWith('-') && !line.startsWith('---')) {
          bgColor = Colors.red.withOpacity(0.15);
          textColor = Colors.red;
          displayLine = line.substring(1);
        } else if (line.startsWith('@@')) {
          textColor = theme.colorScheme.primary;
        }

        return Container(
          width: double.infinity,
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: Text(
            displayLine,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
