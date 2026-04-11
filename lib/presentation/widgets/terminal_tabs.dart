import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/terminal_manager_provider.dart';

class TerminalTabs extends ConsumerWidget {
  const TerminalTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(terminalManagerProvider);

    if (manager.terminals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: manager.terminals.length,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemBuilder: (context, index) {
          final entry = manager.terminals.entries.elementAt(index);
          final isActive = entry.key == manager.activeTerminalId;

          return _TerminalTab(
            id: entry.key,
            name: entry.value.name,
            isActive: isActive,
            onTap: () => ref.read(terminalManagerProvider.notifier)
                .switchToTerminal(entry.key),
            onClose: () => ref.read(terminalManagerProvider.notifier)
                .closeTerminal(entry.key),
          );
        },
      ),
    );
  }
}

class _TerminalTab extends StatelessWidget {
  final String id;
  final String name;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _TerminalTab({
    required this.id,
    required this.name,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.zero,
          border: isActive
              ? Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.terminal,
              size: 16,
              color: isActive
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                color: isActive
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.zero,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: isActive
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
