import 'package:flutter/material.dart';
import '../../data/models/message.dart';

// ─── Priority input keys shown first in the detail panel ──────────────────────
const _kPriorityKeys = ['command', 'path', 'file_path', 'pattern', 'query', 'url'];
const _kSearchTools = {'Grep', 'Glob', 'SemanticSearch', 'QueryCodebase'};
const _kReadTools = {'Read', 'FileTree', 'RepoMap', 'GitDiff', 'GitLog', 'PreviewDiff'};
const _kLintTools = {'ReadLints', 'LintFix'};
const _kMaxOutputLines = 40;

String _truncate(String s, int max) =>
    s.length <= max ? s : '${s.substring(0, max - 3)}...';

String _getToolSummary(Message msg) {
  final name = msg.toolName ?? 'Tool';
  final input = msg.toolCalls.isNotEmpty ? msg.toolCalls.first.input : <String, dynamic>{};

  if (name == 'Read' && input['path'] != null) {
    final filename = (input['path'] as String).split('/').last;
    return 'Read ${_truncate(filename, 40)}';
  }
  if (name == 'FileTree' && input['path'] != null) {
    final dirname = (input['path'] as String).split('/').last;
    return 'Listed ${_truncate(dirname, 30)}';
  }
  if ((name == 'Grep' || name == 'Glob') && input['pattern'] != null) {
    return '$name ${_truncate(input['pattern'] as String, 35)}';
  }
  if (name == 'SemanticSearch' && input['query'] != null) {
    return 'Search ${_truncate(input['query'] as String, 35)}';
  }
  if (name == 'QueryCodebase' && input['query'] != null) {
    return 'Query ${_truncate(input['query'] as String, 35)}';
  }
  if ((name == 'ProcessManager' || name == 'BashExec' || name == 'Bash') &&
      (input['command'] ?? input['cmd']) != null) {
    final cmd = ((input['command'] ?? input['cmd']) as String).split(' ').first;
    return '$name ${_truncate(cmd, 30)}';
  }
  if ((name == 'WebFetch' || name == 'HTTPClient') && input['url'] != null) {
    final hostname = (input['url'] as String)
        .replaceFirst(RegExp(r'^https?://'), '')
        .split('/')
        .first;
    return 'Fetch ${_truncate(hostname, 35)}';
  }
  if (name == 'GitDiff') return 'Git diff';
  if (name == 'GitLog') return 'Git log';
  if (name == 'ReadLints') {
    final files = input['files'] ?? input['path'];
    if (files != null) {
      final fileStr = files is List ? files.first.toString() : files.toString();
      return 'Lint check ${_truncate(fileStr.split('/').last, 30)}';
    }
    return 'Checked lints';
  }
  if (name == 'LintFix') return 'Fixed lints';
  if (name == 'RepoMap') return 'Repo map';
  if (name == 'Write' && input['file_path'] != null) {
    final filename = (input['file_path'] as String).split('/').last;
    return 'Write ${_truncate(filename, 35)}';
  }
  if (name == 'Edit' && input['file_path'] != null) {
    final filename = (input['file_path'] as String).split('/').last;
    return 'Edit ${_truncate(filename, 35)}';
  }
  if (name == 'StrReplace' && input['path'] != null) {
    final filename = (input['path'] as String).split('/').last;
    return 'Edit ${_truncate(filename, 35)}';
  }

  final hint = input['name'] ?? input['title'] ?? input['path'] ??
      input['command'] ?? input['query'];
  if (hint != null) {
    return '$name ${_truncate(hint.toString(), 30)}';
  }
  return name;
}

String _generateGroupSummary(List<Message> tools) {
  final searches = tools.where((t) => _kSearchTools.contains(t.toolName)).length;
  final reads = tools.where((t) => _kReadTools.contains(t.toolName)).length;
  final lints = tools.where((t) => _kLintTools.contains(t.toolName)).length;
  final other = tools.length - searches - reads - lints;

  final parts = <String>[];
  if (searches > 0) parts.add('$searches search${searches != 1 ? 'es' : ''}');
  if (reads > 0) parts.add('$reads file${reads != 1 ? 's' : ''}');
  if (lints > 0) parts.add('$lints lint${lints != 1 ? 's' : ''}');
  if (other > 0) parts.add('$other other');

  if (parts.isEmpty) return '${tools.length} tool${tools.length != 1 ? 's' : ''}';
  return 'Explored ${parts.join(', ')}';
}

String _formatDuration(DateTime start, DateTime end) {
  final ms = end.difference(start).inMilliseconds;
  if (ms < 1000) return '${ms}ms';
  final s = ms / 1000.0;
  return '${s.toStringAsFixed(1)}s';
}

String _formatInputValue(dynamic value) {
  if (value == null) return 'null';
  if (value is String) return value;
  if (value is Map || value is List) {
    return value.toString();
  }
  return value.toString();
}

/// Sorts input entries: priority keys first (in order), then alphabetical rest.
List<MapEntry<String, dynamic>> _sortedInputEntries(Map<String, dynamic> input) {
  final priority = <MapEntry<String, dynamic>>[];
  final rest = <MapEntry<String, dynamic>>[];
  for (final key in _kPriorityKeys) {
    if (input.containsKey(key)) {
      priority.add(MapEntry(key, input[key]));
    }
  }
  for (final entry in input.entries) {
    if (!_kPriorityKeys.contains(entry.key)) {
      rest.add(entry);
    }
  }
  rest.sort((a, b) => a.key.compareTo(b.key));
  return [...priority, ...rest];
}

// ─── Status dot ───────────────────────────────────────────────────────────────

enum _ToolStatus { pending, running, completed, error }

_ToolStatus _getStatus(Message tool) {
  if (tool.type == MessageType.error) return _ToolStatus.error;
  if (!tool.isComplete) {
    return tool.toolCalls.isNotEmpty ? _ToolStatus.running : _ToolStatus.pending;
  }
  if (tool.toolCalls.any((c) => c.isError)) return _ToolStatus.error;
  return _ToolStatus.completed;
}

class _StatusDot extends StatefulWidget {
  final _ToolStatus status;
  const _StatusDot({required this.status});

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacity;

  @override
  void initState() {
    super.initState();
    if (widget.status == _ToolStatus.running) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      )..repeat(reverse: true);
      _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(_controller!);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (widget.status) {
      case _ToolStatus.completed:
        color = const Color(0xFF4CAF50);
        break;
      case _ToolStatus.error:
        color = const Color(0xFFF44336);
        break;
      case _ToolStatus.running:
        color = const Color(0xFFFFC107);
        break;
      case _ToolStatus.pending:
        color = Colors.grey;
        break;
    }

    Widget dot = Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );

    if (widget.status == _ToolStatus.running && _opacity != null) {
      dot = FadeTransition(opacity: _opacity!, child: dot);
    }

    return dot;
  }
}

// ─── Tool detail panel ────────────────────────────────────────────────────────

class _ToolDetail extends StatefulWidget {
  final Message tool;
  const _ToolDetail({required this.tool});

  @override
  State<_ToolDetail> createState() => _ToolDetailState();
}

class _ToolDetailState extends State<_ToolDetail> {
  bool _outputExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final monoStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 11,
      color: theme.colorScheme.onSurface.withOpacity(0.75),
      height: 1.45,
    );
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withOpacity(0.4),
      letterSpacing: 0.6,
    );
    final panelBg = isDark
        ? theme.colorScheme.surface.withOpacity(0.5)
        : theme.colorScheme.surfaceVariant.withOpacity(0.4);
    final borderColor = theme.colorScheme.outline.withOpacity(0.2);

    final call = widget.tool.toolCalls.isNotEmpty ? widget.tool.toolCalls.first : null;
    final input = call?.input ?? <String, dynamic>{};
    final output = call?.output ?? widget.tool.error ?? '';
    final isError = _getStatus(widget.tool) == _ToolStatus.error;

    // Duration
    String? durationStr;
    if (call != null && call.completedAt != null && widget.tool.timestamp != null) {
      durationStr = _formatDuration(widget.tool.timestamp!, call.completedAt!);
    }

    // Output truncation
    final outputLines = output.split('\n');
    final truncated = outputLines.length > _kMaxOutputLines;
    final visibleOutput = _outputExpanded || !truncated
        ? output
        : outputLines.take(_kMaxOutputLines).join('\n');
    final hiddenCount = truncated ? outputLines.length - _kMaxOutputLines : 0;

    final sortedInput = _sortedInputEntries(input);

    return Container(
      margin: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Input ──────────────────────────────────────────────────────────
          if (sortedInput.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Text('INPUT', style: labelStyle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: sortedInput.map((e) {
                  final valueStr = _formatInputValue(e.value);
                  final isLong = valueStr.contains('\n') || valueStr.length > 80;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: isLong
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${e.key}:',
                                style: monoStyle.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: SelectableText(valueStr, style: monoStyle),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${e.key}: ',
                                style: monoStyle.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Flexible(
                                child: Text(valueStr, style: monoStyle),
                              ),
                            ],
                          ),
                  );
                }).toList(),
              ),
            ),
            Divider(height: 1, thickness: 1, color: borderColor),
          ],

          // ── Output / Error ─────────────────────────────────────────────────
          if (output.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Row(
                children: [
                  Text(isError ? 'ERROR' : 'OUTPUT', style: labelStyle),
                  if (durationStr != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      durationStr,
                      style: labelStyle?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.25),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isError
                          ? theme.colorScheme.errorContainer.withOpacity(0.3)
                          : theme.colorScheme.surface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isError
                            ? theme.colorScheme.error.withOpacity(0.3)
                            : borderColor,
                        width: 1,
                      ),
                    ),
                    child: SelectableText(
                      visibleOutput,
                      style: monoStyle.copyWith(
                        color: isError
                            ? theme.colorScheme.error.withOpacity(0.85)
                            : monoStyle.color,
                      ),
                    ),
                  ),
                  if (truncated)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => setState(() => _outputExpanded = !_outputExpanded),
                      child: Text(
                        _outputExpanded
                            ? 'Show less'
                            : 'Show $hiddenCount more line${hiddenCount != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // ── Running indicator (no output yet) ─────────────────────────────
          if (output.isEmpty && _getStatus(widget.tool) == _ToolStatus.running)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Running…',
                style: monoStyle.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.35),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Main widget ──────────────────────────────────────────────────────────────

class CollapsibleToolSummary extends StatefulWidget {
  final List<Message> tools;

  const CollapsibleToolSummary({super.key, required this.tools});

  @override
  State<CollapsibleToolSummary> createState() => _CollapsibleToolSummaryState();
}

class _CollapsibleToolSummaryState extends State<CollapsibleToolSummary> {
  bool _groupExpanded = false;
  final Set<String> _expandedToolIds = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.tools.isEmpty) return const SizedBox.shrink();

    final summaryText = widget.tools.length == 1
        ? _getToolSummary(widget.tools.first)
        : _generateGroupSummary(widget.tools);

    final hasErrors = widget.tools.any((t) =>
        t.type == MessageType.error ||
        (t.toolCalls.isNotEmpty && t.toolCalls.any((c) => c.isError)));

    final textColor = hasErrors
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Group header ─────────────────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _groupExpanded = !_groupExpanded),
            borderRadius: BorderRadius.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _groupExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.35),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    summaryText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Per-tool rows ────────────────────────────────────────────────
          if (_groupExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: widget.tools.map((tool) {
                  final status = _getStatus(tool);
                  final isToolExpanded = _expandedToolIds.contains(tool.id);
                  final rowColor = status == _ToolStatus.error
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface.withOpacity(0.6);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Per-tool header row
                      InkWell(
                        onTap: () => setState(() {
                          if (isToolExpanded) {
                            _expandedToolIds.remove(tool.id);
                          } else {
                            _expandedToolIds.add(tool.id);
                          }
                        }),
                        borderRadius: BorderRadius.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StatusDot(status: status),
                              const SizedBox(width: 6),
                              Text(
                                _getToolSummary(tool),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: rowColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                isToolExpanded
                                    ? Icons.expand_more
                                    : Icons.chevron_right,
                                size: 12,
                                color: theme.colorScheme.onSurface.withOpacity(0.25),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tool detail panel
                      if (isToolExpanded)
                        _ToolDetail(tool: tool),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
