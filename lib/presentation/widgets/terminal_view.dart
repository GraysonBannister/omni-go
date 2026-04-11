import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/terminal_provider.dart';

class TerminalView extends ConsumerStatefulWidget {
  final String terminalId;

  const TerminalView({super.key, required this.terminalId});

  @override
  ConsumerState<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends ConsumerState<TerminalView> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendCommand() {
    final input = _inputController.text;
    if (input.isEmpty) return;

    final controller = ref.read(terminalControllerProvider(widget.terminalId).notifier);
    controller.write(input + '\r');
    _inputController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(terminalControllerProvider(widget.terminalId));
    final theme = Theme.of(context);

    // Auto-scroll when buffer changes
    ref.listen(
      terminalControllerProvider(widget.terminalId).select((s) => s.buffer),
      (_, __) => _scrollToBottom(),
    );

    return Column(
      children: [
        // Terminal output area
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.black,
            child: session.buffer.isEmpty
                ? Center(
                    child: Text(
                      session.isConnected
                          ? 'Terminal ready'
                          : 'Connecting...',
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: SelectableText(
                        session.buffer,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          color: Colors.green,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        // Input area
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              const Text(
                '\$ ',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  style: const TextStyle(fontFamily: 'monospace'),
                  decoration: const InputDecoration(
                    hintText: 'Enter command...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onSubmitted: (_) => _sendCommand(),
                  enabled: session.isConnected,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: session.isConnected ? _sendCommand : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
