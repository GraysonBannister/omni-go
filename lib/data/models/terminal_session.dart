import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminal_session.freezed.dart';
part 'terminal_session.g.dart';

@freezed
class TerminalSession with _$TerminalSession {
  const factory TerminalSession({
    required String id,
    @Default('Terminal') String name,
    @Default('') String buffer,
    @Default('') String currentInput,
    @Default([]) List<String> history,
    @Default(false) bool isConnected,
    @Default(80) int cols,
    @Default(24) int rows,
    String? cwd,
    DateTime? createdAt,
  }) = _TerminalSession;

  factory TerminalSession.fromJson(Map<String, dynamic> json) =>
      _$TerminalSessionFromJson(json);

  factory TerminalSession.create({String? name, String? cwd}) => TerminalSession(
        id: '',
        name: name ?? 'Terminal',
        cwd: cwd,
        createdAt: DateTime.now(),
      );
}

@freezed
class TerminalOutput with _$TerminalOutput {
  const factory TerminalOutput({
    required String sessionId,
    required String data,
    DateTime? timestamp,
  }) = _TerminalOutput;

  factory TerminalOutput.fromJson(Map<String, dynamic> json) =>
      _$TerminalOutputFromJson(json);
}
