import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../data/models/agent_event.dart';
import '../../data/models/terminal_session.dart';
import '../../data/repositories/remote_repository.dart';
import 'server_provider.dart';
import 'terminal_manager_provider.dart';

/// Provider for accessing a specific terminal controller by ID
final terminalControllerProvider = StateNotifierProvider.family<TerminalController, TerminalSession, String>((ref, id) {
  final manager = ref.read(terminalManagerProvider.notifier);
  final controller = manager.getController(id);
  if (controller == null) {
    throw StateError('Terminal controller not found for id: $id');
  }
  return controller;
});

class TerminalController extends StateNotifier<TerminalSession> {
  final Ref _ref;
  final String terminalId;
  RemoteRepository? _repository;
  final _bufferController = StreamController<String>.broadcast();

  TerminalController(this._ref, this.terminalId)
      : super(TerminalSession.create(name: 'Terminal', cwd: null));

  Stream<String> get outputStream => _bufferController.stream;

  Future<void> createSession({String? cwd, int cols = 80, int rows = 24}) async {
    if (kDebugMode) debugPrint('[Terminal] createSession: id=$terminalId cwd=$cwd cols=$cols rows=$rows');
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      _repository = repo;

      if (kDebugMode) debugPrint('[Terminal] createSession: calling repo.createTerminal...');
      final session = await repo.createTerminal(id: terminalId, cwd: cwd, cols: cols, rows: rows);
      if (kDebugMode) debugPrint('[Terminal] createSession: success id=${session.id}, calling _connectToTerminal');
      state = session.copyWith(name: state.name);  // Preserve the name
      _connectToTerminal();
    } on Failure catch (e) {
      if (kDebugMode) debugPrint('[Terminal] createSession: Failure: ${e.message}');
      state = state.copyWith(buffer: 'Error: ${e.message}');
    } catch (e) {
      if (kDebugMode) debugPrint('[Terminal] createSession: exception: $e');
      state = state.copyWith(buffer: 'Error: $e');
    }
  }

  void _connectToTerminal() {
    if (kDebugMode) debugPrint('[Terminal] _connectToTerminal: id=$terminalId, repository=${_repository != null}');
    if (_repository == null) {
      if (kDebugMode) debugPrint('[Terminal] _connectToTerminal: ABORTING — repository is null');
      return;
    }

    _repository!.connectToTerminal(
      terminalId,
      onEvent: _handleTerminalEvent,
      onError: (failure) {
        final msg = '\n[Error: ${failure.message}]\n';
        _bufferController.add(msg);
        state = state.copyWith(buffer: state.buffer + msg);
      },
      onConnect: () { if (kDebugMode) debugPrint('Connected to terminal ${state.id}'); },
      onDisconnect: () {
        if (kDebugMode) debugPrint('Disconnected from terminal ${state.id}');
        state = state.copyWith(isConnected: false);
      },
    );
  }

  void _handleTerminalEvent(AgentEvent event) {
    if (kDebugMode) {
      final preview = event.delta != null
          ? '"${event.delta!.substring(0, event.delta!.length.clamp(0, 40))}"'
          : 'null';
      debugPrint('[Terminal] _handleTerminalEvent: id=$terminalId, type=${event.type}, delta=$preview');
    }
    if (event.type == AgentEventType.connected) {
      const msg = '\n[Connected]\n';
      _bufferController.add(msg);
      state = state.copyWith(buffer: state.buffer + msg, isConnected: true);
      _notifyManager();
      if (kDebugMode) debugPrint('[Terminal] _handleTerminalEvent: buffer updated with [Connected], isConnected=true');
    }
    if (event.delta != null) {
      final cleaned = _cleanOutput(event.delta!);
      if (cleaned.isNotEmpty) {
        _bufferController.add(cleaned);
        state = state.copyWith(buffer: state.buffer + cleaned);
        _notifyManager();
        if (kDebugMode) debugPrint('[Terminal] _handleTerminalEvent: appended ${cleaned.length} chars to buffer');
      } else {
        if (kDebugMode) debugPrint('[Terminal] _handleTerminalEvent: delta was non-null but cleaned to empty');
      }
    }
  }

  /// Strip ANSI/VT escape sequences and normalize line endings so the output
  /// can be displayed in a plain text widget.
  static String _cleanOutput(String raw) {
    var s = raw;
    // OSC sequences: \x1b] ... \x07  or  \x1b] ... \x1b\  (ST)
    s = s.replaceAll(RegExp(r'\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)'), '');
    // CSI sequences: \x1b[ ... <letter>
    s = s.replaceAll(RegExp(r'\x1b\[[0-9;?]*[a-zA-Z]'), '');
    // DCS / PM / APC / SOS sequences
    s = s.replaceAll(RegExp(r'\x1b[PX^_][^\x1b]*(?:\x1b\\|$)'), '');
    // Remaining two-character escape sequences: \x1b <char>
    s = s.replaceAll(RegExp(r'\x1b.'), '');
    // \r\n → \n, then lone \r → \n
    s = s.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    // Strip non-printable control characters except \n and \t
    s = s.replaceAll(RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]'), '');
    return s;
  }

  Future<void> write(String data) async {
    if (_repository == null) return;
    try {
      await _repository!.writeToTerminal(terminalId, data);
    } catch (e) { if (kDebugMode) debugPrint('Failed to write to terminal: $e'); }
  }

  Future<void> resize(int cols, int rows) async {
    if (_repository == null) return;
    try {
      await _repository!.resizeTerminal(terminalId, cols, rows);
      state = state.copyWith(cols: cols, rows: rows);
      _notifyManager();
    } catch (e) { if (kDebugMode) debugPrint('Failed to resize terminal: $e'); }
  }

  Future<void> destroy() async {
    if (_repository == null) return;
    try {
      _repository!.disconnectFromTerminal();
      await _repository!.destroyTerminal(terminalId);
    } catch (e) { if (kDebugMode) debugPrint('Failed to destroy terminal: $e'); }
    state = TerminalSession(
      id: '',
      name: state.name,
      isConnected: false,
      createdAt: DateTime.now(),
    );
  }

  /// Notify the manager of state changes so the terminals map stays in sync
  void _notifyManager() {
    try {
      final manager = _ref.read(terminalManagerProvider.notifier);
      manager.updateTerminalState(terminalId, state);
    } catch (e) {
      // Manager might not be available during initialization
    }
  }

  void clearBuffer() {
    state = state.copyWith(buffer: '');
    _notifyManager();
  }

  void dispose() {
    _bufferController.close();
    super.dispose();
  }
}
