import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/line_change.dart';

/// A code viewer widget that displays file content with git diff line indicators
///
/// Shows a colored gutter on the left side indicating:
/// - Green: Added lines
/// - Yellow/Orange: Modified lines
/// - Red: Deleted lines
/// - No color: Unchanged lines
class CodeViewerWithDiff extends StatefulWidget {
  /// The file content to display
  final String content;

  /// List of line changes from git diff
  final List<LineChange> changes;

  /// Whether to show line numbers
  final bool showLineNumbers;

  /// Whether the content is selectable
  final bool selectable;

  /// Font size for the code
  final double fontSize;

  /// Line height
  final double lineHeight;

  const CodeViewerWithDiff({
    super.key,
    required this.content,
    required this.changes,
    this.showLineNumbers = true,
    this.selectable = true,
    this.fontSize = 14,
    this.lineHeight = 1.5,
  });

  @override
  State<CodeViewerWithDiff> createState() => _CodeViewerWithDiffState();
}

class _CodeViewerWithDiffState extends State<CodeViewerWithDiff> {
  late final ScrollController _verticalController;
  late final ScrollController _horizontalController;
  final Map<int, LineChangeType> _changeMap = {};

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _horizontalController = ScrollController();
    _buildChangeMap();
  }

  @override
  void didUpdateWidget(CodeViewerWithDiff oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.changes != widget.changes) {
      _buildChangeMap();
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  void _buildChangeMap() {
    _changeMap.clear();
    for (final change in widget.changes) {
      _changeMap[change.lineNumber] = change.type;
    }
  }

  /// Get the color for a line based on its change type
  Color? _getLineColor(LineChangeType? type, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case LineChangeType.added:
        // Green for added lines
        return isDark ? const Color(0xFF2D5A3D) : const Color(0xFFD4F5D4);
      case LineChangeType.modified:
        // Yellow/Orange for modified lines
        return isDark ? const Color(0xFF5A4D2D) : const Color(0xFFFFF3CD);
      case LineChangeType.deleted:
        // Red for deleted lines (shown at the position where content was removed)
        return isDark ? const Color(0xFF5A2D2D) : const Color(0xFFF5D4D4);
      default:
        // No color for unchanged lines
        return null;
    }
  }

  /// Get the gutter indicator color
  Color _getGutterColor(LineChangeType? type, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case LineChangeType.added:
        return isDark ? Colors.green.shade400 : Colors.green;
      case LineChangeType.modified:
        return isDark ? Colors.orange.shade400 : Colors.orange;
      case LineChangeType.deleted:
        return isDark ? Colors.red.shade400 : Colors.red;
      default:
        return Colors.transparent;
    }
  }

  List<String> get _lines {
    if (widget.content.isEmpty) return [''];
    return widget.content.split('\n');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = _lines;

    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gutter with colored indicators and optional line numbers
            _buildGutter(lines, theme),
            // Code content
            Expanded(
              child: _buildCodeContent(lines, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGutter(List<String> lines, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          right: BorderSide(
            color: theme.dividerColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(lines.length, (index) {
            final lineNumber = index + 1; // 1-indexed
            final changeType = _changeMap[lineNumber];
            final gutterColor = _getGutterColor(changeType, context);

            return Container(
              height: widget.fontSize * widget.lineHeight,
              decoration: BoxDecoration(
                color: changeType != null
                    ? _getLineColor(changeType, context)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Colored indicator strip
                  Container(
                    width: 4,
                    height: double.infinity,
                    color: gutterColor,
                  ),
                  // Line number
                  if (widget.showLineNumbers)
                    Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$lineNumber',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: widget.fontSize - 2,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          height: widget.lineHeight,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCodeContent(List<String> lines, ThemeData theme) {
    final textSpans = <TextSpan>[];

    for (var i = 0; i < lines.length; i++) {
      final lineNumber = i + 1;
      final changeType = _changeMap[lineNumber];
      final lineColor = _getLineColor(changeType, context);

      // Add newline for all lines except the last one
      final lineText = i < lines.length - 1 ? '${lines[i]}\n' : lines[i];

      textSpans.add(
        TextSpan(
          text: lineText,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: widget.fontSize,
            height: widget.lineHeight,
            backgroundColor: lineColor,
            color: theme.colorScheme.onSurface,
          ),
        ),
      );
    }

    final richText = Text.rich(
      TextSpan(children: textSpans),
      softWrap: false,
      overflow: TextOverflow.visible,
    );

    if (widget.selectable) {
      return SelectableText.rich(
        TextSpan(children: textSpans),
        scrollPhysics: const NeverScrollableScrollPhysics(),
        onTap: () {
          // Allow text selection
        },
        contextMenuBuilder: (context, editableTextState) {
          return AdaptiveTextSelectionToolbar.buttonItems(
            buttonItems: editableTextState.contextMenuButtonItems,
            anchors: editableTextState.contextMenuAnchors,
          );
        },
      );
    }

    return richText;
  }
}

/// Extension to handle context menu
class AdaptiveTextSelectionToolbar {
  static Widget buttonItems({
    required List<ContextMenuButtonItem> buttonItems,
    required TextSelectionToolbarAnchors anchors,
  }) {
    return TextSelectionToolbar(
      anchorAbove: anchors.primaryAnchor,
      anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
      children: buttonItems.map((buttonItem) {
        return TextSelectionToolbarTextButton(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          onPressed: buttonItem.onPressed,
          child: Text(buttonItem.label ?? ''),
        );
      }).toList(),
    );
  }
}

/// A simplified code editor with diff indicators
/// This is a non-editable view - for editing, use a different widget
class CodeViewerWithDiffSimplified extends StatelessWidget {
  final String content;
  final List<LineChange> changes;
  final bool showLineNumbers;

  const CodeViewerWithDiffSimplified({
    super.key,
    required this.content,
    required this.changes,
    this.showLineNumbers = true,
  });

  @override
  Widget build(BuildContext context) {
    return CodeViewerWithDiff(
      content: content,
      changes: changes,
      showLineNumbers: showLineNumbers,
      selectable: true,
    );
  }
}
