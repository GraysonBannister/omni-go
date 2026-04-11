import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/terminal_manager_provider.dart';
import '../../presentation/providers/workspace_provider.dart';
import '../../presentation/widgets/terminal_tabs.dart';
import '../../presentation/widgets/terminal_view.dart';

class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({super.key});

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  Future<void> _createNewTerminal() async {
    final manager = ref.read(terminalManagerProvider.notifier);
    try {
      final workingDir = await ref.read(currentWorkingDirectoryProvider.future)
          .catchError((_) => null);
      await manager.createTerminal(cwd: workingDir);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create terminal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _closeAllTerminals() async {
    final manager = ref.read(terminalManagerProvider.notifier);
    await manager.closeAllTerminals();
  }

  @override
  Widget build(BuildContext context) {
    final managerState = ref.watch(terminalManagerProvider);
    final activeTerminalId = managerState.activeTerminalId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminal'),
        actions: [
          // New terminal button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Terminal',
            onPressed: _createNewTerminal,
          ),
          // Close all button (if terminals exist)
          if (managerState.terminals.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Close All Terminals',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Close All Terminals?'),
                    content: const Text('This will close all active terminal sessions.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Close All'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await _closeAllTerminals();
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Terminal tabs
          const TerminalTabs(),
          // Active terminal or empty state
          Expanded(
            child: managerState.terminals.isEmpty
                ? _EmptyTerminalState(
                    onCreateTerminal: _createNewTerminal,
                  )
                : activeTerminalId != null
                    ? TerminalView(terminalId: activeTerminalId)
                    : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class _EmptyTerminalState extends StatelessWidget {
  final VoidCallback onCreateTerminal;

  const _EmptyTerminalState({required this.onCreateTerminal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.terminal,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Terminals Open',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new terminal to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onCreateTerminal,
            icon: const Icon(Icons.add),
            label: const Text('New Terminal'),
          ),
        ],
      ),
    );
  }
}
