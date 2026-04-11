import 'package:flutter/material.dart';

/// Collapsible thinking/reasoning row — styled identically to tool call rows.
/// Collapsed: bare inline "Thought briefly" with a chevron.
/// Expanded: left-border-only content block with the reasoning text.
class ThinkingSection extends StatefulWidget {
  final String thinking;

  const ThinkingSection({super.key, required this.thinking});

  @override
  State<ThinkingSection> createState() => _ThinkingSectionState();
}

class _ThinkingSectionState extends State<ThinkingSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurface.withOpacity(0.5);
    final chevronColor = theme.colorScheme.onSurface.withOpacity(0.35);
    final borderColor = theme.colorScheme.outline.withOpacity(0.25);

    final labelStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      color: mutedColor,
    );
    final contentStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      color: theme.colorScheme.onSurface.withOpacity(0.6),
      height: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row — identical structure to CollapsibleToolSummary group header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _expanded ? Icons.expand_more : Icons.chevron_right,
                    size: 14,
                    color: chevronColor,
                  ),
                  const SizedBox(width: 4),
                  Text('Thought briefly', style: labelStyle),
                ],
              ),
            ),
          ),

          // Expanded content — left border only, no background box
          if (_expanded)
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 2, bottom: 4),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: borderColor, width: 2),
                  ),
                ),
                padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6),
                child: SelectableText(
                  widget.thinking,
                  style: contentStyle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
