import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/terminal_session.dart';
import 'terminal_provider.dart';

part 'terminal_manager_provider.freezed.dart';

@freezed
class TerminalManagerState with _$TerminalManagerState {
  const factory TerminalManagerState({
    @Default({}) Map<String, TerminalSession> terminals,
    String? activeTerminalId,
    @Default(0) int terminalCounter,
  }) = _TerminalManagerState;
}

final terminalManagerProvider = StateNotifierProvider<TerminalManager, TerminalManagerState>((ref) {
  return TerminalManager(ref);
});

class TerminalManager extends StateNotifier<TerminalManagerState> {
  final Ref _ref;
  final Map<String, TerminalController> _controllers = {};

  TerminalManager(this._ref) : super(const TerminalManagerState());

  /// Create a new terminal with optional name and starting directory
  Future<void> createTerminal({String? name, String? cwd}) async {
    final counter = state.terminalCounter + 1;
    final terminalName = name ?? 'Terminal $counter';
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    if (kDebugMode) {
      debugPrint('[TerminalManager] Creating terminal: id=$id, name=$terminalName, cwd=$cwd');
    }

    // Create controller for this terminal
    final controller = TerminalController(_ref, id);
    _controllers[id] = controller;

    // Initialize the terminal session
    await controller.createSession(cwd: cwd);

    // Update state with the new terminal
    state = state.copyWith(
      terminals: {...state.terminals, id: controller.state},
      activeTerminalId: id,
      terminalCounter: counter,
    );

    if (kDebugMode) {
      debugPrint('[TerminalManager] Terminal created: id=$id, total terminals=${state.terminals.length}');
    }
  }

  /// Switch to an existing terminal
  void switchToTerminal(String id) {
    if (state.terminals.containsKey(id)) {
      if (kDebugMode) {
        debugPrint('[TerminalManager] Switching to terminal: $id');
      }
      state = state.copyWith(activeTerminalId: id);
    }
  }

  /// Close a terminal by ID
  Future<void> closeTerminal(String id) async {
    if (kDebugMode) {
      debugPrint('[TerminalManager] Closing terminal: $id');
    }

    final controller = _controllers[id];
    if (controller != null) {
      await controller.destroy();
      _controllers.remove(id);
    }

    final newTerminals = Map<String, TerminalSession>.from(state.terminals);
    newTerminals.remove(id);

    // If we closed the active terminal, switch to another one
    String? newActiveId = state.activeTerminalId;
    if (state.activeTerminalId == id) {
      newActiveId = newTerminals.keys.isNotEmpty ? newTerminals.keys.first : null;
      if (kDebugMode && newActiveId != null) {
        debugPrint('[TerminalManager] Closed active terminal, switching to: $newActiveId');
      }
    }

    state = state.copyWith(
      terminals: newTerminals,
      activeTerminalId: newActiveId,
    );

    if (kDebugMode) {
      debugPrint('[TerminalManager] Terminal closed. Remaining: ${newTerminals.length}');
    }
  }

  /// Close all terminals
  Future<void> closeAllTerminals() async {
    if (kDebugMode) {
      debugPrint('[TerminalManager] Closing all ${state.terminals.length} terminals');
    }

    for (final id in state.terminals.keys.toList()) {
      await closeTerminal(id);
    }

    state = state.copyWith(
      terminals: {},
      activeTerminalId: null,
    );
  }

  /// Rename a terminal
  void renameTerminal(String id, String newName) {
    final terminal = state.terminals[id];
    if (terminal != null) {
      final updated = terminal.copyWith(name: newName);
      state = state.copyWith(
        terminals: {...state.terminals, id: updated},
      );
    }
  }

  /// Get controller for a specific terminal
  TerminalController? getController(String id) => _controllers[id];

  /// Get the currently active controller
  TerminalController? get activeController =>
      state.activeTerminalId != null ? _controllers[state.activeTerminalId] : null;

  /// Get the currently active terminal session
  TerminalSession? get activeTerminal =>
      state.activeTerminalId != null ? state.terminals[state.activeTerminalId] : null;

  /// Update terminal state (called by controllers when state changes)
  void updateTerminalState(String id, TerminalSession newState) {
    if (state.terminals.containsKey(id)) {
      state = state.copyWith(
        terminals: {...state.terminals, id: newState},
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }
}
