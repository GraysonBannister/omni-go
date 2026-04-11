import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_mode.dart';
import '../providers/ai_mode_provider.dart';
import '../providers/chat_provider.dart';

/// Compact chip showing current AI mode that opens selector when tapped
class ModeSelectorChip extends ConsumerWidget {
  final VoidCallback? onModeChanged;

  const ModeSelectorChip({super.key, this.onModeChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedMode = ref.watch(selectedModeProvider);
    final isLoading = ref.watch(isModeLoadingProvider);
    final isStreaming = ref.watch(chatControllerProvider).isStreaming;

    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: ActionChip(
        avatar: Icon(
          selectedMode.iconData,
          size: 16,
          color: selectedMode.color,
        ),
        label: Text(
          selectedMode.name,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: selectedMode.backgroundColor,
        side: BorderSide(
          color: selectedMode.color.withOpacity(0.3),
          width: 1,
        ),
        onPressed: isStreaming
            ? null
            : () => _showModeSelector(context, ref),
      ),
    );
  }

  void _showModeSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => const ModeSelectorSheet(),
    );
  }
}

/// Full AI mode selector bottom sheet
class ModeSelectorSheet extends ConsumerWidget {
  const ModeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modes = ref.watch(availableModesProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final isStreaming = ref.watch(chatControllerProvider).isStreaming;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select AI Mode',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  if (isStreaming) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.onErrorContainer,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Cannot change mode while streaming',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Current mode indicator
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selectedMode.backgroundColor,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(
                    color: selectedMode.color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedMode.iconData,
                      color: selectedMode.color,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current: ${selectedMode.name}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: selectedMode.color,
                            ),
                          ),
                          Text(
                            selectedMode.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Mode list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: modes.length,
                itemBuilder: (context, index) {
                  final mode = modes[index];
                  final isSelected = mode.id == selectedMode.id;

                  return _ModeListTile(
                    mode: mode,
                    isSelected: isSelected,
                    isEnabled: !isStreaming,
                    onTap: () {
                      if (!isStreaming) {
                        ref.read(selectedModeProvider.notifier).selectMode(mode);
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ModeListTile extends StatelessWidget {
  final AIMode mode;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _ModeListTile({
    required this.mode,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isSelected ? mode.backgroundColor : theme.colorScheme.surface,
        borderRadius: BorderRadius.zero,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.zero,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: isSelected
                    ? mode.color.withOpacity(0.5)
                    : theme.colorScheme.outline.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Mode icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: mode.color.withOpacity(0.15),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Icon(
                    mode.iconData,
                    color: mode.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Mode info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mode.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? mode.color : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mode.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      if (mode.disabledTools.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Read-only mode',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: mode.color,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
