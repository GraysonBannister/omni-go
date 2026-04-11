// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AgentEvent _$AgentEventFromJson(Map<String, dynamic> json) {
  return _AgentEvent.fromJson(json);
}

/// @nodoc
mixin _$AgentEvent {
  AgentEventType get type => throw _privateConstructorUsedError;
  String? get conversationId => throw _privateConstructorUsedError;
  String? get delta => throw _privateConstructorUsedError;
  Map<String, dynamic>? get message => throw _privateConstructorUsedError;
  String? get toolName => throw _privateConstructorUsedError;
  String? get toolId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get input => throw _privateConstructorUsedError;
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;
  String? get progressMessage => throw _privateConstructorUsedError;
  double? get totalCost => throw _privateConstructorUsedError;
  double? get turnCost => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get taskId => throw _privateConstructorUsedError;
  String? get capability => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool? get taskSuccess => throw _privateConstructorUsedError;
  int? get durationMs => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get fileChanges =>
      throw _privateConstructorUsedError; // Change preview fields
  String? get filePath => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  String? get changeType => throw _privateConstructorUsedError;
  int? get startLine => throw _privateConstructorUsedError;
  int? get endLine => throw _privateConstructorUsedError;
  int? get lineCount => throw _privateConstructorUsedError;
  String? get diffContent => throw _privateConstructorUsedError;
  String? get beforeSnippet => throw _privateConstructorUsedError;
  String? get afterSnippet => throw _privateConstructorUsedError;
  int? get additions => throw _privateConstructorUsedError;
  int? get deletions => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get requestId => throw _privateConstructorUsedError;
  String? get prompt => throw _privateConstructorUsedError;
  String? get terminalCommand => throw _privateConstructorUsedError;
  bool? get waitForInput => throw _privateConstructorUsedError;
  String? get placeholder => throw _privateConstructorUsedError;
  String? get response => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this AgentEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AgentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgentEventCopyWith<AgentEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgentEventCopyWith<$Res> {
  factory $AgentEventCopyWith(
          AgentEvent value, $Res Function(AgentEvent) then) =
      _$AgentEventCopyWithImpl<$Res, AgentEvent>;
  @useResult
  $Res call(
      {AgentEventType type,
      String? conversationId,
      String? delta,
      Map<String, dynamic>? message,
      String? toolName,
      String? toolId,
      Map<String, dynamic>? input,
      Map<String, dynamic>? result,
      String? progressMessage,
      double? totalCost,
      double? turnCost,
      String? error,
      String? taskId,
      String? capability,
      String? description,
      bool? taskSuccess,
      int? durationMs,
      String? summary,
      List<Map<String, dynamic>>? fileChanges,
      String? filePath,
      String? fileName,
      String? changeType,
      int? startLine,
      int? endLine,
      int? lineCount,
      String? diffContent,
      String? beforeSnippet,
      String? afterSnippet,
      int? additions,
      int? deletions,
      String? status,
      String? requestId,
      String? prompt,
      String? terminalCommand,
      bool? waitForInput,
      String? placeholder,
      String? response,
      DateTime? timestamp});
}

/// @nodoc
class _$AgentEventCopyWithImpl<$Res, $Val extends AgentEvent>
    implements $AgentEventCopyWith<$Res> {
  _$AgentEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? conversationId = freezed,
    Object? delta = freezed,
    Object? message = freezed,
    Object? toolName = freezed,
    Object? toolId = freezed,
    Object? input = freezed,
    Object? result = freezed,
    Object? progressMessage = freezed,
    Object? totalCost = freezed,
    Object? turnCost = freezed,
    Object? error = freezed,
    Object? taskId = freezed,
    Object? capability = freezed,
    Object? description = freezed,
    Object? taskSuccess = freezed,
    Object? durationMs = freezed,
    Object? summary = freezed,
    Object? fileChanges = freezed,
    Object? filePath = freezed,
    Object? fileName = freezed,
    Object? changeType = freezed,
    Object? startLine = freezed,
    Object? endLine = freezed,
    Object? lineCount = freezed,
    Object? diffContent = freezed,
    Object? beforeSnippet = freezed,
    Object? afterSnippet = freezed,
    Object? additions = freezed,
    Object? deletions = freezed,
    Object? status = freezed,
    Object? requestId = freezed,
    Object? prompt = freezed,
    Object? terminalCommand = freezed,
    Object? waitForInput = freezed,
    Object? placeholder = freezed,
    Object? response = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AgentEventType,
      conversationId: freezed == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String?,
      delta: freezed == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      toolName: freezed == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String?,
      toolId: freezed == toolId
          ? _value.toolId
          : toolId // ignore: cast_nullable_to_non_nullable
              as String?,
      input: freezed == input
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      progressMessage: freezed == progressMessage
          ? _value.progressMessage
          : progressMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCost: freezed == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double?,
      turnCost: freezed == turnCost
          ? _value.turnCost
          : turnCost // ignore: cast_nullable_to_non_nullable
              as double?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      capability: freezed == capability
          ? _value.capability
          : capability // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      taskSuccess: freezed == taskSuccess
          ? _value.taskSuccess
          : taskSuccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      durationMs: freezed == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      fileChanges: freezed == fileChanges
          ? _value.fileChanges
          : fileChanges // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      changeType: freezed == changeType
          ? _value.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as String?,
      startLine: freezed == startLine
          ? _value.startLine
          : startLine // ignore: cast_nullable_to_non_nullable
              as int?,
      endLine: freezed == endLine
          ? _value.endLine
          : endLine // ignore: cast_nullable_to_non_nullable
              as int?,
      lineCount: freezed == lineCount
          ? _value.lineCount
          : lineCount // ignore: cast_nullable_to_non_nullable
              as int?,
      diffContent: freezed == diffContent
          ? _value.diffContent
          : diffContent // ignore: cast_nullable_to_non_nullable
              as String?,
      beforeSnippet: freezed == beforeSnippet
          ? _value.beforeSnippet
          : beforeSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      afterSnippet: freezed == afterSnippet
          ? _value.afterSnippet
          : afterSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      additions: freezed == additions
          ? _value.additions
          : additions // ignore: cast_nullable_to_non_nullable
              as int?,
      deletions: freezed == deletions
          ? _value.deletions
          : deletions // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      terminalCommand: freezed == terminalCommand
          ? _value.terminalCommand
          : terminalCommand // ignore: cast_nullable_to_non_nullable
              as String?,
      waitForInput: freezed == waitForInput
          ? _value.waitForInput
          : waitForInput // ignore: cast_nullable_to_non_nullable
              as bool?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgentEventImplCopyWith<$Res>
    implements $AgentEventCopyWith<$Res> {
  factory _$$AgentEventImplCopyWith(
          _$AgentEventImpl value, $Res Function(_$AgentEventImpl) then) =
      __$$AgentEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AgentEventType type,
      String? conversationId,
      String? delta,
      Map<String, dynamic>? message,
      String? toolName,
      String? toolId,
      Map<String, dynamic>? input,
      Map<String, dynamic>? result,
      String? progressMessage,
      double? totalCost,
      double? turnCost,
      String? error,
      String? taskId,
      String? capability,
      String? description,
      bool? taskSuccess,
      int? durationMs,
      String? summary,
      List<Map<String, dynamic>>? fileChanges,
      String? filePath,
      String? fileName,
      String? changeType,
      int? startLine,
      int? endLine,
      int? lineCount,
      String? diffContent,
      String? beforeSnippet,
      String? afterSnippet,
      int? additions,
      int? deletions,
      String? status,
      String? requestId,
      String? prompt,
      String? terminalCommand,
      bool? waitForInput,
      String? placeholder,
      String? response,
      DateTime? timestamp});
}

/// @nodoc
class __$$AgentEventImplCopyWithImpl<$Res>
    extends _$AgentEventCopyWithImpl<$Res, _$AgentEventImpl>
    implements _$$AgentEventImplCopyWith<$Res> {
  __$$AgentEventImplCopyWithImpl(
      _$AgentEventImpl _value, $Res Function(_$AgentEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AgentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? conversationId = freezed,
    Object? delta = freezed,
    Object? message = freezed,
    Object? toolName = freezed,
    Object? toolId = freezed,
    Object? input = freezed,
    Object? result = freezed,
    Object? progressMessage = freezed,
    Object? totalCost = freezed,
    Object? turnCost = freezed,
    Object? error = freezed,
    Object? taskId = freezed,
    Object? capability = freezed,
    Object? description = freezed,
    Object? taskSuccess = freezed,
    Object? durationMs = freezed,
    Object? summary = freezed,
    Object? fileChanges = freezed,
    Object? filePath = freezed,
    Object? fileName = freezed,
    Object? changeType = freezed,
    Object? startLine = freezed,
    Object? endLine = freezed,
    Object? lineCount = freezed,
    Object? diffContent = freezed,
    Object? beforeSnippet = freezed,
    Object? afterSnippet = freezed,
    Object? additions = freezed,
    Object? deletions = freezed,
    Object? status = freezed,
    Object? requestId = freezed,
    Object? prompt = freezed,
    Object? terminalCommand = freezed,
    Object? waitForInput = freezed,
    Object? placeholder = freezed,
    Object? response = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$AgentEventImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AgentEventType,
      conversationId: freezed == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String?,
      delta: freezed == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value._message
          : message // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      toolName: freezed == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String?,
      toolId: freezed == toolId
          ? _value.toolId
          : toolId // ignore: cast_nullable_to_non_nullable
              as String?,
      input: freezed == input
          ? _value._input
          : input // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      result: freezed == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      progressMessage: freezed == progressMessage
          ? _value.progressMessage
          : progressMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCost: freezed == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double?,
      turnCost: freezed == turnCost
          ? _value.turnCost
          : turnCost // ignore: cast_nullable_to_non_nullable
              as double?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      capability: freezed == capability
          ? _value.capability
          : capability // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      taskSuccess: freezed == taskSuccess
          ? _value.taskSuccess
          : taskSuccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      durationMs: freezed == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      fileChanges: freezed == fileChanges
          ? _value._fileChanges
          : fileChanges // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      changeType: freezed == changeType
          ? _value.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as String?,
      startLine: freezed == startLine
          ? _value.startLine
          : startLine // ignore: cast_nullable_to_non_nullable
              as int?,
      endLine: freezed == endLine
          ? _value.endLine
          : endLine // ignore: cast_nullable_to_non_nullable
              as int?,
      lineCount: freezed == lineCount
          ? _value.lineCount
          : lineCount // ignore: cast_nullable_to_non_nullable
              as int?,
      diffContent: freezed == diffContent
          ? _value.diffContent
          : diffContent // ignore: cast_nullable_to_non_nullable
              as String?,
      beforeSnippet: freezed == beforeSnippet
          ? _value.beforeSnippet
          : beforeSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      afterSnippet: freezed == afterSnippet
          ? _value.afterSnippet
          : afterSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      additions: freezed == additions
          ? _value.additions
          : additions // ignore: cast_nullable_to_non_nullable
              as int?,
      deletions: freezed == deletions
          ? _value.deletions
          : deletions // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      terminalCommand: freezed == terminalCommand
          ? _value.terminalCommand
          : terminalCommand // ignore: cast_nullable_to_non_nullable
              as String?,
      waitForInput: freezed == waitForInput
          ? _value.waitForInput
          : waitForInput // ignore: cast_nullable_to_non_nullable
              as bool?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgentEventImpl with DiagnosticableTreeMixin implements _AgentEvent {
  const _$AgentEventImpl(
      {required this.type,
      this.conversationId,
      this.delta,
      final Map<String, dynamic>? message,
      this.toolName,
      this.toolId,
      final Map<String, dynamic>? input,
      final Map<String, dynamic>? result,
      this.progressMessage,
      this.totalCost,
      this.turnCost,
      this.error,
      this.taskId,
      this.capability,
      this.description,
      this.taskSuccess,
      this.durationMs,
      this.summary,
      final List<Map<String, dynamic>>? fileChanges,
      this.filePath,
      this.fileName,
      this.changeType,
      this.startLine,
      this.endLine,
      this.lineCount,
      this.diffContent,
      this.beforeSnippet,
      this.afterSnippet,
      this.additions,
      this.deletions,
      this.status,
      this.requestId,
      this.prompt,
      this.terminalCommand,
      this.waitForInput,
      this.placeholder,
      this.response,
      this.timestamp})
      : _message = message,
        _input = input,
        _result = result,
        _fileChanges = fileChanges;

  factory _$AgentEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgentEventImplFromJson(json);

  @override
  final AgentEventType type;
  @override
  final String? conversationId;
  @override
  final String? delta;
  final Map<String, dynamic>? _message;
  @override
  Map<String, dynamic>? get message {
    final value = _message;
    if (value == null) return null;
    if (_message is EqualUnmodifiableMapView) return _message;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? toolName;
  @override
  final String? toolId;
  final Map<String, dynamic>? _input;
  @override
  Map<String, dynamic>? get input {
    final value = _input;
    if (value == null) return null;
    if (_input is EqualUnmodifiableMapView) return _input;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? progressMessage;
  @override
  final double? totalCost;
  @override
  final double? turnCost;
  @override
  final String? error;
  @override
  final String? taskId;
  @override
  final String? capability;
  @override
  final String? description;
  @override
  final bool? taskSuccess;
  @override
  final int? durationMs;
  @override
  final String? summary;
  final List<Map<String, dynamic>>? _fileChanges;
  @override
  List<Map<String, dynamic>>? get fileChanges {
    final value = _fileChanges;
    if (value == null) return null;
    if (_fileChanges is EqualUnmodifiableListView) return _fileChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Change preview fields
  @override
  final String? filePath;
  @override
  final String? fileName;
  @override
  final String? changeType;
  @override
  final int? startLine;
  @override
  final int? endLine;
  @override
  final int? lineCount;
  @override
  final String? diffContent;
  @override
  final String? beforeSnippet;
  @override
  final String? afterSnippet;
  @override
  final int? additions;
  @override
  final int? deletions;
  @override
  final String? status;
  @override
  final String? requestId;
  @override
  final String? prompt;
  @override
  final String? terminalCommand;
  @override
  final bool? waitForInput;
  @override
  final String? placeholder;
  @override
  final String? response;
  @override
  final DateTime? timestamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AgentEvent(type: $type, conversationId: $conversationId, delta: $delta, message: $message, toolName: $toolName, toolId: $toolId, input: $input, result: $result, progressMessage: $progressMessage, totalCost: $totalCost, turnCost: $turnCost, error: $error, taskId: $taskId, capability: $capability, description: $description, taskSuccess: $taskSuccess, durationMs: $durationMs, summary: $summary, fileChanges: $fileChanges, filePath: $filePath, fileName: $fileName, changeType: $changeType, startLine: $startLine, endLine: $endLine, lineCount: $lineCount, diffContent: $diffContent, beforeSnippet: $beforeSnippet, afterSnippet: $afterSnippet, additions: $additions, deletions: $deletions, status: $status, requestId: $requestId, prompt: $prompt, terminalCommand: $terminalCommand, waitForInput: $waitForInput, placeholder: $placeholder, response: $response, timestamp: $timestamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AgentEvent'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('conversationId', conversationId))
      ..add(DiagnosticsProperty('delta', delta))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('toolName', toolName))
      ..add(DiagnosticsProperty('toolId', toolId))
      ..add(DiagnosticsProperty('input', input))
      ..add(DiagnosticsProperty('result', result))
      ..add(DiagnosticsProperty('progressMessage', progressMessage))
      ..add(DiagnosticsProperty('totalCost', totalCost))
      ..add(DiagnosticsProperty('turnCost', turnCost))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('taskId', taskId))
      ..add(DiagnosticsProperty('capability', capability))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('taskSuccess', taskSuccess))
      ..add(DiagnosticsProperty('durationMs', durationMs))
      ..add(DiagnosticsProperty('summary', summary))
      ..add(DiagnosticsProperty('fileChanges', fileChanges))
      ..add(DiagnosticsProperty('filePath', filePath))
      ..add(DiagnosticsProperty('fileName', fileName))
      ..add(DiagnosticsProperty('changeType', changeType))
      ..add(DiagnosticsProperty('startLine', startLine))
      ..add(DiagnosticsProperty('endLine', endLine))
      ..add(DiagnosticsProperty('lineCount', lineCount))
      ..add(DiagnosticsProperty('diffContent', diffContent))
      ..add(DiagnosticsProperty('beforeSnippet', beforeSnippet))
      ..add(DiagnosticsProperty('afterSnippet', afterSnippet))
      ..add(DiagnosticsProperty('additions', additions))
      ..add(DiagnosticsProperty('deletions', deletions))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('requestId', requestId))
      ..add(DiagnosticsProperty('prompt', prompt))
      ..add(DiagnosticsProperty('terminalCommand', terminalCommand))
      ..add(DiagnosticsProperty('waitForInput', waitForInput))
      ..add(DiagnosticsProperty('placeholder', placeholder))
      ..add(DiagnosticsProperty('response', response))
      ..add(DiagnosticsProperty('timestamp', timestamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgentEventImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            const DeepCollectionEquality().equals(other._message, _message) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            (identical(other.toolId, toolId) || other.toolId == toolId) &&
            const DeepCollectionEquality().equals(other._input, _input) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.progressMessage, progressMessage) ||
                other.progressMessage == progressMessage) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.turnCost, turnCost) ||
                other.turnCost == turnCost) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.capability, capability) ||
                other.capability == capability) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.taskSuccess, taskSuccess) ||
                other.taskSuccess == taskSuccess) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._fileChanges, _fileChanges) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.changeType, changeType) ||
                other.changeType == changeType) &&
            (identical(other.startLine, startLine) ||
                other.startLine == startLine) &&
            (identical(other.endLine, endLine) || other.endLine == endLine) &&
            (identical(other.lineCount, lineCount) ||
                other.lineCount == lineCount) &&
            (identical(other.diffContent, diffContent) ||
                other.diffContent == diffContent) &&
            (identical(other.beforeSnippet, beforeSnippet) ||
                other.beforeSnippet == beforeSnippet) &&
            (identical(other.afterSnippet, afterSnippet) ||
                other.afterSnippet == afterSnippet) &&
            (identical(other.additions, additions) ||
                other.additions == additions) &&
            (identical(other.deletions, deletions) ||
                other.deletions == deletions) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.terminalCommand, terminalCommand) ||
                other.terminalCommand == terminalCommand) &&
            (identical(other.waitForInput, waitForInput) ||
                other.waitForInput == waitForInput) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        type,
        conversationId,
        delta,
        const DeepCollectionEquality().hash(_message),
        toolName,
        toolId,
        const DeepCollectionEquality().hash(_input),
        const DeepCollectionEquality().hash(_result),
        progressMessage,
        totalCost,
        turnCost,
        error,
        taskId,
        capability,
        description,
        taskSuccess,
        durationMs,
        summary,
        const DeepCollectionEquality().hash(_fileChanges),
        filePath,
        fileName,
        changeType,
        startLine,
        endLine,
        lineCount,
        diffContent,
        beforeSnippet,
        afterSnippet,
        additions,
        deletions,
        status,
        requestId,
        prompt,
        terminalCommand,
        waitForInput,
        placeholder,
        response,
        timestamp
      ]);

  /// Create a copy of AgentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgentEventImplCopyWith<_$AgentEventImpl> get copyWith =>
      __$$AgentEventImplCopyWithImpl<_$AgentEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AgentEventImplToJson(
      this,
    );
  }
}

abstract class _AgentEvent implements AgentEvent {
  const factory _AgentEvent(
      {required final AgentEventType type,
      final String? conversationId,
      final String? delta,
      final Map<String, dynamic>? message,
      final String? toolName,
      final String? toolId,
      final Map<String, dynamic>? input,
      final Map<String, dynamic>? result,
      final String? progressMessage,
      final double? totalCost,
      final double? turnCost,
      final String? error,
      final String? taskId,
      final String? capability,
      final String? description,
      final bool? taskSuccess,
      final int? durationMs,
      final String? summary,
      final List<Map<String, dynamic>>? fileChanges,
      final String? filePath,
      final String? fileName,
      final String? changeType,
      final int? startLine,
      final int? endLine,
      final int? lineCount,
      final String? diffContent,
      final String? beforeSnippet,
      final String? afterSnippet,
      final int? additions,
      final int? deletions,
      final String? status,
      final String? requestId,
      final String? prompt,
      final String? terminalCommand,
      final bool? waitForInput,
      final String? placeholder,
      final String? response,
      final DateTime? timestamp}) = _$AgentEventImpl;

  factory _AgentEvent.fromJson(Map<String, dynamic> json) =
      _$AgentEventImpl.fromJson;

  @override
  AgentEventType get type;
  @override
  String? get conversationId;
  @override
  String? get delta;
  @override
  Map<String, dynamic>? get message;
  @override
  String? get toolName;
  @override
  String? get toolId;
  @override
  Map<String, dynamic>? get input;
  @override
  Map<String, dynamic>? get result;
  @override
  String? get progressMessage;
  @override
  double? get totalCost;
  @override
  double? get turnCost;
  @override
  String? get error;
  @override
  String? get taskId;
  @override
  String? get capability;
  @override
  String? get description;
  @override
  bool? get taskSuccess;
  @override
  int? get durationMs;
  @override
  String? get summary;
  @override
  List<Map<String, dynamic>>? get fileChanges; // Change preview fields
  @override
  String? get filePath;
  @override
  String? get fileName;
  @override
  String? get changeType;
  @override
  int? get startLine;
  @override
  int? get endLine;
  @override
  int? get lineCount;
  @override
  String? get diffContent;
  @override
  String? get beforeSnippet;
  @override
  String? get afterSnippet;
  @override
  int? get additions;
  @override
  int? get deletions;
  @override
  String? get status;
  @override
  String? get requestId;
  @override
  String? get prompt;
  @override
  String? get terminalCommand;
  @override
  bool? get waitForInput;
  @override
  String? get placeholder;
  @override
  String? get response;
  @override
  DateTime? get timestamp;

  /// Create a copy of AgentEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgentEventImplCopyWith<_$AgentEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
