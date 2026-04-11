// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChangePreviewData _$ChangePreviewDataFromJson(Map<String, dynamic> json) {
  return _ChangePreviewData.fromJson(json);
}

/// @nodoc
mixin _$ChangePreviewData {
  String get toolCallId => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get toolName => throw _privateConstructorUsedError;
  ChangeType get changeType => throw _privateConstructorUsedError;
  int get startLine => throw _privateConstructorUsedError;
  int get endLine => throw _privateConstructorUsedError;
  int get lineCount => throw _privateConstructorUsedError;
  int get additions => throw _privateConstructorUsedError;
  int get deletions => throw _privateConstructorUsedError;
  String get diffContent => throw _privateConstructorUsedError;
  String? get beforeSnippet => throw _privateConstructorUsedError;
  String? get afterSnippet => throw _privateConstructorUsedError;
  ChangeStatus get status => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ChangePreviewData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangePreviewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangePreviewDataCopyWith<ChangePreviewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePreviewDataCopyWith<$Res> {
  factory $ChangePreviewDataCopyWith(
          ChangePreviewData value, $Res Function(ChangePreviewData) then) =
      _$ChangePreviewDataCopyWithImpl<$Res, ChangePreviewData>;
  @useResult
  $Res call(
      {String toolCallId,
      String messageId,
      String filePath,
      String fileName,
      String toolName,
      ChangeType changeType,
      int startLine,
      int endLine,
      int lineCount,
      int additions,
      int deletions,
      String diffContent,
      String? beforeSnippet,
      String? afterSnippet,
      ChangeStatus status,
      DateTime timestamp});
}

/// @nodoc
class _$ChangePreviewDataCopyWithImpl<$Res, $Val extends ChangePreviewData>
    implements $ChangePreviewDataCopyWith<$Res> {
  _$ChangePreviewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangePreviewData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolCallId = null,
    Object? messageId = null,
    Object? filePath = null,
    Object? fileName = null,
    Object? toolName = null,
    Object? changeType = null,
    Object? startLine = null,
    Object? endLine = null,
    Object? lineCount = null,
    Object? additions = null,
    Object? deletions = null,
    Object? diffContent = null,
    Object? beforeSnippet = freezed,
    Object? afterSnippet = freezed,
    Object? status = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      toolCallId: null == toolCallId
          ? _value.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      changeType: null == changeType
          ? _value.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as ChangeType,
      startLine: null == startLine
          ? _value.startLine
          : startLine // ignore: cast_nullable_to_non_nullable
              as int,
      endLine: null == endLine
          ? _value.endLine
          : endLine // ignore: cast_nullable_to_non_nullable
              as int,
      lineCount: null == lineCount
          ? _value.lineCount
          : lineCount // ignore: cast_nullable_to_non_nullable
              as int,
      additions: null == additions
          ? _value.additions
          : additions // ignore: cast_nullable_to_non_nullable
              as int,
      deletions: null == deletions
          ? _value.deletions
          : deletions // ignore: cast_nullable_to_non_nullable
              as int,
      diffContent: null == diffContent
          ? _value.diffContent
          : diffContent // ignore: cast_nullable_to_non_nullable
              as String,
      beforeSnippet: freezed == beforeSnippet
          ? _value.beforeSnippet
          : beforeSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      afterSnippet: freezed == afterSnippet
          ? _value.afterSnippet
          : afterSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChangeStatus,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangePreviewDataImplCopyWith<$Res>
    implements $ChangePreviewDataCopyWith<$Res> {
  factory _$$ChangePreviewDataImplCopyWith(_$ChangePreviewDataImpl value,
          $Res Function(_$ChangePreviewDataImpl) then) =
      __$$ChangePreviewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String toolCallId,
      String messageId,
      String filePath,
      String fileName,
      String toolName,
      ChangeType changeType,
      int startLine,
      int endLine,
      int lineCount,
      int additions,
      int deletions,
      String diffContent,
      String? beforeSnippet,
      String? afterSnippet,
      ChangeStatus status,
      DateTime timestamp});
}

/// @nodoc
class __$$ChangePreviewDataImplCopyWithImpl<$Res>
    extends _$ChangePreviewDataCopyWithImpl<$Res, _$ChangePreviewDataImpl>
    implements _$$ChangePreviewDataImplCopyWith<$Res> {
  __$$ChangePreviewDataImplCopyWithImpl(_$ChangePreviewDataImpl _value,
      $Res Function(_$ChangePreviewDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangePreviewData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolCallId = null,
    Object? messageId = null,
    Object? filePath = null,
    Object? fileName = null,
    Object? toolName = null,
    Object? changeType = null,
    Object? startLine = null,
    Object? endLine = null,
    Object? lineCount = null,
    Object? additions = null,
    Object? deletions = null,
    Object? diffContent = null,
    Object? beforeSnippet = freezed,
    Object? afterSnippet = freezed,
    Object? status = null,
    Object? timestamp = null,
  }) {
    return _then(_$ChangePreviewDataImpl(
      toolCallId: null == toolCallId
          ? _value.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      changeType: null == changeType
          ? _value.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as ChangeType,
      startLine: null == startLine
          ? _value.startLine
          : startLine // ignore: cast_nullable_to_non_nullable
              as int,
      endLine: null == endLine
          ? _value.endLine
          : endLine // ignore: cast_nullable_to_non_nullable
              as int,
      lineCount: null == lineCount
          ? _value.lineCount
          : lineCount // ignore: cast_nullable_to_non_nullable
              as int,
      additions: null == additions
          ? _value.additions
          : additions // ignore: cast_nullable_to_non_nullable
              as int,
      deletions: null == deletions
          ? _value.deletions
          : deletions // ignore: cast_nullable_to_non_nullable
              as int,
      diffContent: null == diffContent
          ? _value.diffContent
          : diffContent // ignore: cast_nullable_to_non_nullable
              as String,
      beforeSnippet: freezed == beforeSnippet
          ? _value.beforeSnippet
          : beforeSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      afterSnippet: freezed == afterSnippet
          ? _value.afterSnippet
          : afterSnippet // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChangeStatus,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangePreviewDataImpl
    with DiagnosticableTreeMixin
    implements _ChangePreviewData {
  const _$ChangePreviewDataImpl(
      {required this.toolCallId,
      required this.messageId,
      required this.filePath,
      required this.fileName,
      required this.toolName,
      required this.changeType,
      required this.startLine,
      required this.endLine,
      required this.lineCount,
      required this.additions,
      required this.deletions,
      required this.diffContent,
      this.beforeSnippet,
      this.afterSnippet,
      this.status = ChangeStatus.pending,
      required this.timestamp});

  factory _$ChangePreviewDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangePreviewDataImplFromJson(json);

  @override
  final String toolCallId;
  @override
  final String messageId;
  @override
  final String filePath;
  @override
  final String fileName;
  @override
  final String toolName;
  @override
  final ChangeType changeType;
  @override
  final int startLine;
  @override
  final int endLine;
  @override
  final int lineCount;
  @override
  final int additions;
  @override
  final int deletions;
  @override
  final String diffContent;
  @override
  final String? beforeSnippet;
  @override
  final String? afterSnippet;
  @override
  @JsonKey()
  final ChangeStatus status;
  @override
  final DateTime timestamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ChangePreviewData(toolCallId: $toolCallId, messageId: $messageId, filePath: $filePath, fileName: $fileName, toolName: $toolName, changeType: $changeType, startLine: $startLine, endLine: $endLine, lineCount: $lineCount, additions: $additions, deletions: $deletions, diffContent: $diffContent, beforeSnippet: $beforeSnippet, afterSnippet: $afterSnippet, status: $status, timestamp: $timestamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ChangePreviewData'))
      ..add(DiagnosticsProperty('toolCallId', toolCallId))
      ..add(DiagnosticsProperty('messageId', messageId))
      ..add(DiagnosticsProperty('filePath', filePath))
      ..add(DiagnosticsProperty('fileName', fileName))
      ..add(DiagnosticsProperty('toolName', toolName))
      ..add(DiagnosticsProperty('changeType', changeType))
      ..add(DiagnosticsProperty('startLine', startLine))
      ..add(DiagnosticsProperty('endLine', endLine))
      ..add(DiagnosticsProperty('lineCount', lineCount))
      ..add(DiagnosticsProperty('additions', additions))
      ..add(DiagnosticsProperty('deletions', deletions))
      ..add(DiagnosticsProperty('diffContent', diffContent))
      ..add(DiagnosticsProperty('beforeSnippet', beforeSnippet))
      ..add(DiagnosticsProperty('afterSnippet', afterSnippet))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('timestamp', timestamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePreviewDataImpl &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            (identical(other.changeType, changeType) ||
                other.changeType == changeType) &&
            (identical(other.startLine, startLine) ||
                other.startLine == startLine) &&
            (identical(other.endLine, endLine) || other.endLine == endLine) &&
            (identical(other.lineCount, lineCount) ||
                other.lineCount == lineCount) &&
            (identical(other.additions, additions) ||
                other.additions == additions) &&
            (identical(other.deletions, deletions) ||
                other.deletions == deletions) &&
            (identical(other.diffContent, diffContent) ||
                other.diffContent == diffContent) &&
            (identical(other.beforeSnippet, beforeSnippet) ||
                other.beforeSnippet == beforeSnippet) &&
            (identical(other.afterSnippet, afterSnippet) ||
                other.afterSnippet == afterSnippet) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      toolCallId,
      messageId,
      filePath,
      fileName,
      toolName,
      changeType,
      startLine,
      endLine,
      lineCount,
      additions,
      deletions,
      diffContent,
      beforeSnippet,
      afterSnippet,
      status,
      timestamp);

  /// Create a copy of ChangePreviewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePreviewDataImplCopyWith<_$ChangePreviewDataImpl> get copyWith =>
      __$$ChangePreviewDataImplCopyWithImpl<_$ChangePreviewDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangePreviewDataImplToJson(
      this,
    );
  }
}

abstract class _ChangePreviewData implements ChangePreviewData {
  const factory _ChangePreviewData(
      {required final String toolCallId,
      required final String messageId,
      required final String filePath,
      required final String fileName,
      required final String toolName,
      required final ChangeType changeType,
      required final int startLine,
      required final int endLine,
      required final int lineCount,
      required final int additions,
      required final int deletions,
      required final String diffContent,
      final String? beforeSnippet,
      final String? afterSnippet,
      final ChangeStatus status,
      required final DateTime timestamp}) = _$ChangePreviewDataImpl;

  factory _ChangePreviewData.fromJson(Map<String, dynamic> json) =
      _$ChangePreviewDataImpl.fromJson;

  @override
  String get toolCallId;
  @override
  String get messageId;
  @override
  String get filePath;
  @override
  String get fileName;
  @override
  String get toolName;
  @override
  ChangeType get changeType;
  @override
  int get startLine;
  @override
  int get endLine;
  @override
  int get lineCount;
  @override
  int get additions;
  @override
  int get deletions;
  @override
  String get diffContent;
  @override
  String? get beforeSnippet;
  @override
  String? get afterSnippet;
  @override
  ChangeStatus get status;
  @override
  DateTime get timestamp;

  /// Create a copy of ChangePreviewData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangePreviewDataImplCopyWith<_$ChangePreviewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChangeSummary _$ChangeSummaryFromJson(Map<String, dynamic> json) {
  return _ChangeSummary.fromJson(json);
}

/// @nodoc
mixin _$ChangeSummary {
  int get totalPending => throw _privateConstructorUsedError;
  int get totalAccepted => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;

  /// Serializes this ChangeSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeSummaryCopyWith<ChangeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeSummaryCopyWith<$Res> {
  factory $ChangeSummaryCopyWith(
          ChangeSummary value, $Res Function(ChangeSummary) then) =
      _$ChangeSummaryCopyWithImpl<$Res, ChangeSummary>;
  @useResult
  $Res call({int totalPending, int totalAccepted, int totalRejected});
}

/// @nodoc
class _$ChangeSummaryCopyWithImpl<$Res, $Val extends ChangeSummary>
    implements $ChangeSummaryCopyWith<$Res> {
  _$ChangeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPending = null,
    Object? totalAccepted = null,
    Object? totalRejected = null,
  }) {
    return _then(_value.copyWith(
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalAccepted: null == totalAccepted
          ? _value.totalAccepted
          : totalAccepted // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeSummaryImplCopyWith<$Res>
    implements $ChangeSummaryCopyWith<$Res> {
  factory _$$ChangeSummaryImplCopyWith(
          _$ChangeSummaryImpl value, $Res Function(_$ChangeSummaryImpl) then) =
      __$$ChangeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalPending, int totalAccepted, int totalRejected});
}

/// @nodoc
class __$$ChangeSummaryImplCopyWithImpl<$Res>
    extends _$ChangeSummaryCopyWithImpl<$Res, _$ChangeSummaryImpl>
    implements _$$ChangeSummaryImplCopyWith<$Res> {
  __$$ChangeSummaryImplCopyWithImpl(
      _$ChangeSummaryImpl _value, $Res Function(_$ChangeSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPending = null,
    Object? totalAccepted = null,
    Object? totalRejected = null,
  }) {
    return _then(_$ChangeSummaryImpl(
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalAccepted: null == totalAccepted
          ? _value.totalAccepted
          : totalAccepted // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeSummaryImpl
    with DiagnosticableTreeMixin
    implements _ChangeSummary {
  const _$ChangeSummaryImpl(
      {required this.totalPending,
      required this.totalAccepted,
      required this.totalRejected});

  factory _$ChangeSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangeSummaryImplFromJson(json);

  @override
  final int totalPending;
  @override
  final int totalAccepted;
  @override
  final int totalRejected;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ChangeSummary(totalPending: $totalPending, totalAccepted: $totalAccepted, totalRejected: $totalRejected)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ChangeSummary'))
      ..add(DiagnosticsProperty('totalPending', totalPending))
      ..add(DiagnosticsProperty('totalAccepted', totalAccepted))
      ..add(DiagnosticsProperty('totalRejected', totalRejected));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeSummaryImpl &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.totalAccepted, totalAccepted) ||
                other.totalAccepted == totalAccepted) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalPending, totalAccepted, totalRejected);

  /// Create a copy of ChangeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeSummaryImplCopyWith<_$ChangeSummaryImpl> get copyWith =>
      __$$ChangeSummaryImplCopyWithImpl<_$ChangeSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeSummaryImplToJson(
      this,
    );
  }
}

abstract class _ChangeSummary implements ChangeSummary {
  const factory _ChangeSummary(
      {required final int totalPending,
      required final int totalAccepted,
      required final int totalRejected}) = _$ChangeSummaryImpl;

  factory _ChangeSummary.fromJson(Map<String, dynamic> json) =
      _$ChangeSummaryImpl.fromJson;

  @override
  int get totalPending;
  @override
  int get totalAccepted;
  @override
  int get totalRejected;

  /// Create a copy of ChangeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeSummaryImplCopyWith<_$ChangeSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PendingChangesResponse _$PendingChangesResponseFromJson(
    Map<String, dynamic> json) {
  return _PendingChangesResponse.fromJson(json);
}

/// @nodoc
mixin _$PendingChangesResponse {
  String get conversationId => throw _privateConstructorUsedError;
  List<ChangePreviewData> get pendingChanges =>
      throw _privateConstructorUsedError;
  ChangeSummary get summary => throw _privateConstructorUsedError;

  /// Serializes this PendingChangesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PendingChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingChangesResponseCopyWith<PendingChangesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingChangesResponseCopyWith<$Res> {
  factory $PendingChangesResponseCopyWith(PendingChangesResponse value,
          $Res Function(PendingChangesResponse) then) =
      _$PendingChangesResponseCopyWithImpl<$Res, PendingChangesResponse>;
  @useResult
  $Res call(
      {String conversationId,
      List<ChangePreviewData> pendingChanges,
      ChangeSummary summary});

  $ChangeSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$PendingChangesResponseCopyWithImpl<$Res,
        $Val extends PendingChangesResponse>
    implements $PendingChangesResponseCopyWith<$Res> {
  _$PendingChangesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? pendingChanges = null,
    Object? summary = null,
  }) {
    return _then(_value.copyWith(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      pendingChanges: null == pendingChanges
          ? _value.pendingChanges
          : pendingChanges // ignore: cast_nullable_to_non_nullable
              as List<ChangePreviewData>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as ChangeSummary,
    ) as $Val);
  }

  /// Create a copy of PendingChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChangeSummaryCopyWith<$Res> get summary {
    return $ChangeSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PendingChangesResponseImplCopyWith<$Res>
    implements $PendingChangesResponseCopyWith<$Res> {
  factory _$$PendingChangesResponseImplCopyWith(
          _$PendingChangesResponseImpl value,
          $Res Function(_$PendingChangesResponseImpl) then) =
      __$$PendingChangesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String conversationId,
      List<ChangePreviewData> pendingChanges,
      ChangeSummary summary});

  @override
  $ChangeSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$PendingChangesResponseImplCopyWithImpl<$Res>
    extends _$PendingChangesResponseCopyWithImpl<$Res,
        _$PendingChangesResponseImpl>
    implements _$$PendingChangesResponseImplCopyWith<$Res> {
  __$$PendingChangesResponseImplCopyWithImpl(
      _$PendingChangesResponseImpl _value,
      $Res Function(_$PendingChangesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PendingChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? pendingChanges = null,
    Object? summary = null,
  }) {
    return _then(_$PendingChangesResponseImpl(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      pendingChanges: null == pendingChanges
          ? _value._pendingChanges
          : pendingChanges // ignore: cast_nullable_to_non_nullable
              as List<ChangePreviewData>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as ChangeSummary,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingChangesResponseImpl
    with DiagnosticableTreeMixin
    implements _PendingChangesResponse {
  const _$PendingChangesResponseImpl(
      {required this.conversationId,
      required final List<ChangePreviewData> pendingChanges,
      required this.summary})
      : _pendingChanges = pendingChanges;

  factory _$PendingChangesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingChangesResponseImplFromJson(json);

  @override
  final String conversationId;
  final List<ChangePreviewData> _pendingChanges;
  @override
  List<ChangePreviewData> get pendingChanges {
    if (_pendingChanges is EqualUnmodifiableListView) return _pendingChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingChanges);
  }

  @override
  final ChangeSummary summary;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PendingChangesResponse(conversationId: $conversationId, pendingChanges: $pendingChanges, summary: $summary)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PendingChangesResponse'))
      ..add(DiagnosticsProperty('conversationId', conversationId))
      ..add(DiagnosticsProperty('pendingChanges', pendingChanges))
      ..add(DiagnosticsProperty('summary', summary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingChangesResponseImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            const DeepCollectionEquality()
                .equals(other._pendingChanges, _pendingChanges) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, conversationId,
      const DeepCollectionEquality().hash(_pendingChanges), summary);

  /// Create a copy of PendingChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingChangesResponseImplCopyWith<_$PendingChangesResponseImpl>
      get copyWith => __$$PendingChangesResponseImplCopyWithImpl<
          _$PendingChangesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingChangesResponseImplToJson(
      this,
    );
  }
}

abstract class _PendingChangesResponse implements PendingChangesResponse {
  const factory _PendingChangesResponse(
      {required final String conversationId,
      required final List<ChangePreviewData> pendingChanges,
      required final ChangeSummary summary}) = _$PendingChangesResponseImpl;

  factory _PendingChangesResponse.fromJson(Map<String, dynamic> json) =
      _$PendingChangesResponseImpl.fromJson;

  @override
  String get conversationId;
  @override
  List<ChangePreviewData> get pendingChanges;
  @override
  ChangeSummary get summary;

  /// Create a copy of PendingChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingChangesResponseImplCopyWith<_$PendingChangesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ChangeReviewResponse _$ChangeReviewResponseFromJson(Map<String, dynamic> json) {
  return _ChangeReviewResponse.fromJson(json);
}

/// @nodoc
mixin _$ChangeReviewResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this ChangeReviewResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeReviewResponseCopyWith<ChangeReviewResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeReviewResponseCopyWith<$Res> {
  factory $ChangeReviewResponseCopyWith(ChangeReviewResponse value,
          $Res Function(ChangeReviewResponse) then) =
      _$ChangeReviewResponseCopyWithImpl<$Res, ChangeReviewResponse>;
  @useResult
  $Res call({bool success, String? error});
}

/// @nodoc
class _$ChangeReviewResponseCopyWithImpl<$Res,
        $Val extends ChangeReviewResponse>
    implements $ChangeReviewResponseCopyWith<$Res> {
  _$ChangeReviewResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangeReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeReviewResponseImplCopyWith<$Res>
    implements $ChangeReviewResponseCopyWith<$Res> {
  factory _$$ChangeReviewResponseImplCopyWith(_$ChangeReviewResponseImpl value,
          $Res Function(_$ChangeReviewResponseImpl) then) =
      __$$ChangeReviewResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? error});
}

/// @nodoc
class __$$ChangeReviewResponseImplCopyWithImpl<$Res>
    extends _$ChangeReviewResponseCopyWithImpl<$Res, _$ChangeReviewResponseImpl>
    implements _$$ChangeReviewResponseImplCopyWith<$Res> {
  __$$ChangeReviewResponseImplCopyWithImpl(_$ChangeReviewResponseImpl _value,
      $Res Function(_$ChangeReviewResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangeReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
  }) {
    return _then(_$ChangeReviewResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeReviewResponseImpl
    with DiagnosticableTreeMixin
    implements _ChangeReviewResponse {
  const _$ChangeReviewResponseImpl({required this.success, this.error});

  factory _$ChangeReviewResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangeReviewResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ChangeReviewResponse(success: $success, error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ChangeReviewResponse'))
      ..add(DiagnosticsProperty('success', success))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeReviewResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, error);

  /// Create a copy of ChangeReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeReviewResponseImplCopyWith<_$ChangeReviewResponseImpl>
      get copyWith =>
          __$$ChangeReviewResponseImplCopyWithImpl<_$ChangeReviewResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeReviewResponseImplToJson(
      this,
    );
  }
}

abstract class _ChangeReviewResponse implements ChangeReviewResponse {
  const factory _ChangeReviewResponse(
      {required final bool success,
      final String? error}) = _$ChangeReviewResponseImpl;

  factory _ChangeReviewResponse.fromJson(Map<String, dynamic> json) =
      _$ChangeReviewResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get error;

  /// Create a copy of ChangeReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeReviewResponseImplCopyWith<_$ChangeReviewResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AcceptAllChangesResponse _$AcceptAllChangesResponseFromJson(
    Map<String, dynamic> json) {
  return _AcceptAllChangesResponse.fromJson(json);
}

/// @nodoc
mixin _$AcceptAllChangesResponse {
  bool get success => throw _privateConstructorUsedError;
  List<String> get accepted => throw _privateConstructorUsedError;
  List<Map<String, String>> get failed => throw _privateConstructorUsedError;

  /// Serializes this AcceptAllChangesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AcceptAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AcceptAllChangesResponseCopyWith<AcceptAllChangesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcceptAllChangesResponseCopyWith<$Res> {
  factory $AcceptAllChangesResponseCopyWith(AcceptAllChangesResponse value,
          $Res Function(AcceptAllChangesResponse) then) =
      _$AcceptAllChangesResponseCopyWithImpl<$Res, AcceptAllChangesResponse>;
  @useResult
  $Res call(
      {bool success, List<String> accepted, List<Map<String, String>> failed});
}

/// @nodoc
class _$AcceptAllChangesResponseCopyWithImpl<$Res,
        $Val extends AcceptAllChangesResponse>
    implements $AcceptAllChangesResponseCopyWith<$Res> {
  _$AcceptAllChangesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AcceptAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? accepted = null,
    Object? failed = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      accepted: null == accepted
          ? _value.accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failed: null == failed
          ? _value.failed
          : failed // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcceptAllChangesResponseImplCopyWith<$Res>
    implements $AcceptAllChangesResponseCopyWith<$Res> {
  factory _$$AcceptAllChangesResponseImplCopyWith(
          _$AcceptAllChangesResponseImpl value,
          $Res Function(_$AcceptAllChangesResponseImpl) then) =
      __$$AcceptAllChangesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success, List<String> accepted, List<Map<String, String>> failed});
}

/// @nodoc
class __$$AcceptAllChangesResponseImplCopyWithImpl<$Res>
    extends _$AcceptAllChangesResponseCopyWithImpl<$Res,
        _$AcceptAllChangesResponseImpl>
    implements _$$AcceptAllChangesResponseImplCopyWith<$Res> {
  __$$AcceptAllChangesResponseImplCopyWithImpl(
      _$AcceptAllChangesResponseImpl _value,
      $Res Function(_$AcceptAllChangesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AcceptAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? accepted = null,
    Object? failed = null,
  }) {
    return _then(_$AcceptAllChangesResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      accepted: null == accepted
          ? _value._accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failed: null == failed
          ? _value._failed
          : failed // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AcceptAllChangesResponseImpl
    with DiagnosticableTreeMixin
    implements _AcceptAllChangesResponse {
  const _$AcceptAllChangesResponseImpl(
      {required this.success,
      required final List<String> accepted,
      required final List<Map<String, String>> failed})
      : _accepted = accepted,
        _failed = failed;

  factory _$AcceptAllChangesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AcceptAllChangesResponseImplFromJson(json);

  @override
  final bool success;
  final List<String> _accepted;
  @override
  List<String> get accepted {
    if (_accepted is EqualUnmodifiableListView) return _accepted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accepted);
  }

  final List<Map<String, String>> _failed;
  @override
  List<Map<String, String>> get failed {
    if (_failed is EqualUnmodifiableListView) return _failed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failed);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AcceptAllChangesResponse(success: $success, accepted: $accepted, failed: $failed)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AcceptAllChangesResponse'))
      ..add(DiagnosticsProperty('success', success))
      ..add(DiagnosticsProperty('accepted', accepted))
      ..add(DiagnosticsProperty('failed', failed));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcceptAllChangesResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._accepted, _accepted) &&
            const DeepCollectionEquality().equals(other._failed, _failed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      const DeepCollectionEquality().hash(_accepted),
      const DeepCollectionEquality().hash(_failed));

  /// Create a copy of AcceptAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AcceptAllChangesResponseImplCopyWith<_$AcceptAllChangesResponseImpl>
      get copyWith => __$$AcceptAllChangesResponseImplCopyWithImpl<
          _$AcceptAllChangesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AcceptAllChangesResponseImplToJson(
      this,
    );
  }
}

abstract class _AcceptAllChangesResponse implements AcceptAllChangesResponse {
  const factory _AcceptAllChangesResponse(
          {required final bool success,
          required final List<String> accepted,
          required final List<Map<String, String>> failed}) =
      _$AcceptAllChangesResponseImpl;

  factory _AcceptAllChangesResponse.fromJson(Map<String, dynamic> json) =
      _$AcceptAllChangesResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<String> get accepted;
  @override
  List<Map<String, String>> get failed;

  /// Create a copy of AcceptAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AcceptAllChangesResponseImplCopyWith<_$AcceptAllChangesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RejectAllChangesResponse _$RejectAllChangesResponseFromJson(
    Map<String, dynamic> json) {
  return _RejectAllChangesResponse.fromJson(json);
}

/// @nodoc
mixin _$RejectAllChangesResponse {
  bool get success => throw _privateConstructorUsedError;
  List<String> get rejected => throw _privateConstructorUsedError;
  List<Map<String, String>> get failed => throw _privateConstructorUsedError;

  /// Serializes this RejectAllChangesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RejectAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RejectAllChangesResponseCopyWith<RejectAllChangesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectAllChangesResponseCopyWith<$Res> {
  factory $RejectAllChangesResponseCopyWith(RejectAllChangesResponse value,
          $Res Function(RejectAllChangesResponse) then) =
      _$RejectAllChangesResponseCopyWithImpl<$Res, RejectAllChangesResponse>;
  @useResult
  $Res call(
      {bool success, List<String> rejected, List<Map<String, String>> failed});
}

/// @nodoc
class _$RejectAllChangesResponseCopyWithImpl<$Res,
        $Val extends RejectAllChangesResponse>
    implements $RejectAllChangesResponseCopyWith<$Res> {
  _$RejectAllChangesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RejectAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? rejected = null,
    Object? failed = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      rejected: null == rejected
          ? _value.rejected
          : rejected // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failed: null == failed
          ? _value.failed
          : failed // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectAllChangesResponseImplCopyWith<$Res>
    implements $RejectAllChangesResponseCopyWith<$Res> {
  factory _$$RejectAllChangesResponseImplCopyWith(
          _$RejectAllChangesResponseImpl value,
          $Res Function(_$RejectAllChangesResponseImpl) then) =
      __$$RejectAllChangesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success, List<String> rejected, List<Map<String, String>> failed});
}

/// @nodoc
class __$$RejectAllChangesResponseImplCopyWithImpl<$Res>
    extends _$RejectAllChangesResponseCopyWithImpl<$Res,
        _$RejectAllChangesResponseImpl>
    implements _$$RejectAllChangesResponseImplCopyWith<$Res> {
  __$$RejectAllChangesResponseImplCopyWithImpl(
      _$RejectAllChangesResponseImpl _value,
      $Res Function(_$RejectAllChangesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RejectAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? rejected = null,
    Object? failed = null,
  }) {
    return _then(_$RejectAllChangesResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      rejected: null == rejected
          ? _value._rejected
          : rejected // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failed: null == failed
          ? _value._failed
          : failed // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectAllChangesResponseImpl
    with DiagnosticableTreeMixin
    implements _RejectAllChangesResponse {
  const _$RejectAllChangesResponseImpl(
      {required this.success,
      required final List<String> rejected,
      required final List<Map<String, String>> failed})
      : _rejected = rejected,
        _failed = failed;

  factory _$RejectAllChangesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RejectAllChangesResponseImplFromJson(json);

  @override
  final bool success;
  final List<String> _rejected;
  @override
  List<String> get rejected {
    if (_rejected is EqualUnmodifiableListView) return _rejected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rejected);
  }

  final List<Map<String, String>> _failed;
  @override
  List<Map<String, String>> get failed {
    if (_failed is EqualUnmodifiableListView) return _failed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failed);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RejectAllChangesResponse(success: $success, rejected: $rejected, failed: $failed)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RejectAllChangesResponse'))
      ..add(DiagnosticsProperty('success', success))
      ..add(DiagnosticsProperty('rejected', rejected))
      ..add(DiagnosticsProperty('failed', failed));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectAllChangesResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._rejected, _rejected) &&
            const DeepCollectionEquality().equals(other._failed, _failed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      const DeepCollectionEquality().hash(_rejected),
      const DeepCollectionEquality().hash(_failed));

  /// Create a copy of RejectAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectAllChangesResponseImplCopyWith<_$RejectAllChangesResponseImpl>
      get copyWith => __$$RejectAllChangesResponseImplCopyWithImpl<
          _$RejectAllChangesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectAllChangesResponseImplToJson(
      this,
    );
  }
}

abstract class _RejectAllChangesResponse implements RejectAllChangesResponse {
  const factory _RejectAllChangesResponse(
          {required final bool success,
          required final List<String> rejected,
          required final List<Map<String, String>> failed}) =
      _$RejectAllChangesResponseImpl;

  factory _RejectAllChangesResponse.fromJson(Map<String, dynamic> json) =
      _$RejectAllChangesResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<String> get rejected;
  @override
  List<Map<String, String>> get failed;

  /// Create a copy of RejectAllChangesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectAllChangesResponseImplCopyWith<_$RejectAllChangesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
