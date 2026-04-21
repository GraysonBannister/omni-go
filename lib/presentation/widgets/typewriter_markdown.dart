import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

/// A blinking cursor widget that mimics a terminal block cursor.
class BlinkingCursor extends StatefulWidget {
  final Color color;
  final double width;
  final double height;

  const BlinkingCursor({
    super.key,
    required this.color,
    this.width = 8,
    this.height = 18,
  });

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value > 0.5 ? 1.0 : 0.0,
          child: Container(
            width: widget.width,
            height: widget.height,
            color: widget.color,
          ),
        );
      },
    );
  }
}

/// A markdown widget that displays text with a typewriter/terminal effect.
/// Characters are revealed one by one with a blinking cursor following the text.
class TypewriterMarkdown extends StatefulWidget {
  final String content;
  final bool isStreaming;
  final Duration charDelay;
  final MarkdownStyleSheet? styleSheet;

  const TypewriterMarkdown({
    super.key,
    required this.content,
    required this.isStreaming,
    this.charDelay = const Duration(milliseconds: 12),
    this.styleSheet,
  });

  @override
  State<TypewriterMarkdown> createState() => _TypewriterMarkdownState();
}

class _TypewriterMarkdownState extends State<TypewriterMarkdown> {
  int _displayedLength = 0;
  Timer? _timer;
  String _lastContent = '';
  int _hapticCounter = 0;

  @override
  void initState() {
    super.initState();
    _lastContent = widget.content;
    _startAnimation();
  }

  @override
  void didUpdateWidget(TypewriterMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If streaming stopped, complete the animation instantly
    if (!widget.isStreaming && oldWidget.isStreaming) {
      _finishAnimation();
      return;
    }

    // If content changed, handle the update
    if (widget.content != _lastContent) {
      _lastContent = widget.content;

      // Check if new content extends from old content (streaming update)
      if (widget.content.startsWith(oldWidget.content.substring(
        0,
        oldWidget.content.length > _displayedLength
            ? _displayedLength
            : oldWidget.content.length,
      ))) {
        // Content is extending — don't cancel/restart the timer if it's already
        // ticking. The periodic callback reads widget.content.length dynamically,
        // so it will naturally chase the growing content without a restart.
        if (_displayedLength > widget.content.length) {
          _displayedLength = widget.content.length;
        }
        if (_timer == null || !_timer!.isActive) {
          _startAnimation();
        }
      } else {
        // Content changed completely, reset animation
        _displayedLength = 0;
        _startAnimation();
      }
    }
  }

  void _startAnimation() {
    _timer?.cancel();

    // If already at full content, don't start timer
    if (_displayedLength >= widget.content.length) {
      return;
    }

    _timer = Timer.periodic(widget.charDelay, (_) {
      if (!mounted) return;

      setState(() {
        final target = widget.content.length;
        if (_displayedLength < target) {
          // Reveal more characters - batch reveal for performance during fast streaming
          final remaining = target - _displayedLength;
          final charsToReveal = widget.isStreaming && remaining > 50 ? 3 : 1;
          _displayedLength = (_displayedLength + charsToReveal).clamp(0, target);

          // Trigger haptic feedback while streaming assistant response
          // Throttled to every 5 characters to avoid overwhelming the user
          if (widget.isStreaming) {
            _hapticCounter += charsToReveal;
            if (_hapticCounter >= 5) {
              _hapticCounter = 0;
              HapticFeedback.lightImpact();
            }
          }
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _finishAnimation() {
    _timer?.cancel();
    if (mounted && _displayedLength < widget.content.length) {
      setState(() {
        _displayedLength = widget.content.length;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If no content and not streaming, show nothing
    if (widget.content.isEmpty && !widget.isStreaming) {
      return const SizedBox.shrink();
    }

    // Get the displayed portion of content
    final displayedText = widget.content.substring(
      0,
      _displayedLength.clamp(0, widget.content.length),
    );

    final hasMoreContent = _displayedLength < widget.content.length;
    final shouldShowCursor = widget.isStreaming || hasMoreContent;
    final isComplete = !widget.isStreaming && !hasMoreContent;

    // Once complete, use MarkdownBody for proper formatting
    if (isComplete) {
      return MarkdownBody(
        data: displayedText,
        styleSheet: widget.styleSheet ??
            MarkdownStyleSheet(
              p: GoogleFonts.jetBrainsMono(
                color: theme.colorScheme.onSurface,
                fontSize: 14,
                height: 1.5,
              ),
              code: GoogleFonts.jetBrainsMono(
                color: theme.colorScheme.onSurface,
                fontSize: 13,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
      );
    }

    // During streaming, use Text.rich with inline cursor for proper cursor positioning
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: displayedText,
            style: GoogleFonts.jetBrainsMono(
              color: theme.colorScheme.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (shouldShowCursor)
            WidgetSpan(
              child: BlinkingCursor(
                color: theme.colorScheme.primary,
                width: 8,
                height: 18,
              ),
              alignment: PlaceholderAlignment.middle,
            ),
        ],
      ),
    );
  }
}
