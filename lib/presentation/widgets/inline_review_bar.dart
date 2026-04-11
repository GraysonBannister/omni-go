import 'package:flutter/material.dart';
import '../../data/models/change_preview.dart';

class InlineReviewBar extends StatelessWidget {
  final String toolCallId;
  final int additions;
  final int deletions;
  final ChangeStatus status;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const InlineReviewBar({
    super.key,
    required this.toolCallId,
    required this.additions,
    required this.deletions,
    this.status = ChangeStatus.pending,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If already decided, show status only
    if (status != ChangeStatus.pending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: status == ChangeStatus.accepted
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          border: Border(
            left: BorderSide(
              color: status == ChangeStatus.accepted ? Colors.green : Colors.red,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              status == ChangeStatus.accepted
                  ? Icons.check_circle
                  : Icons.cancel,
              color: status == ChangeStatus.accepted ? Colors.green : Colors.red,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              status == ChangeStatus.accepted ? 'Accepted' : 'Rejected',
              style: TextStyle(
                color: status == ChangeStatus.accepted ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // Pending state - show accept/reject buttons
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        border: Border(
          left: BorderSide(color: Colors.amber, width: 3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.pending, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Review',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                _buildStats(),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onReject != null)
                TextButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Reject'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (additions > 0)
          Text(
            '+$additions',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (additions > 0 && deletions > 0)
          const Text(
            ' / ',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        if (deletions > 0)
          Text(
            '-$deletions',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
