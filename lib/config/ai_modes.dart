import 'package:flutter/material.dart';

/// AI Mode configuration matching omni-code-v2 implementation
/// Each mode configures how the AI assistant behaves

/// Available AI modes
enum AIModeType {
  code,
  architect,
  review,
  security,
  debug,
}

/// Extension to get configuration for each mode type
extension AIModeTypeConfig on AIModeType {
  /// Unique identifier for the mode
  String get id => name;

  /// Display name for the mode
  String get displayName {
    switch (this) {
      case AIModeType.code:
        return 'Code';
      case AIModeType.architect:
        return 'Architect';
      case AIModeType.review:
        return 'Review';
      case AIModeType.security:
        return 'Security';
      case AIModeType.debug:
        return 'Debug';
    }
  }

  /// Short description of the mode's purpose
  String get description {
    switch (this) {
      case AIModeType.code:
        return 'General coding assistance';
      case AIModeType.architect:
        return 'Design and architecture planning';
      case AIModeType.review:
        return 'Code review and analysis';
      case AIModeType.security:
        return 'Security audit and fixes';
      case AIModeType.debug:
        return 'Debugging and troubleshooting';
    }
  }

  /// Icon data for the mode
  IconData get iconData {
    switch (this) {
      case AIModeType.code:
        return Icons.code;
      case AIModeType.architect:
        return Icons.account_balance;
      case AIModeType.review:
        return Icons.visibility;
      case AIModeType.security:
        return Icons.shield;
      case AIModeType.debug:
        return Icons.bug_report;
    }
  }

  /// Primary color for the mode (matching omni-code-v2 colors)
  Color get color {
    switch (this) {
      case AIModeType.code:
        return const Color(0xFF3B82F6); // Blue
      case AIModeType.architect:
        return const Color(0xFFF59E0B); // Amber
      case AIModeType.review:
        return const Color(0xFF8B5CF6); // Purple
      case AIModeType.security:
        return const Color(0xFFEF4444); // Red
      case AIModeType.debug:
        return const Color(0xFF10B981); // Green
    }
  }

  /// Background color overlay (10% opacity)
  Color get backgroundColor {
    return color.withOpacity(0.1);
  }

  /// Additional system prompt text appended for this mode
  String? get systemPromptAppend {
    switch (this) {
      case AIModeType.code:
        return '''You are in coding mode. Focus on implementing changes efficiently. Write clean, well-structured code. Test when possible.

PLAN REFERENCE:
When working on a task:
1. Check if PLAN.md exists using ReadPlan tool
2. Reference the plan for context on current task and overall progress
3. After completing work, use UpdatePlan to check off relevant items
4. Add implementation notes to the plan if decisions were made

Do NOT create new plans in code mode - only reference or update existing plans.''';

      case AIModeType.architect:
        return '''You are in architect mode. Focus on high-level design, planning, and code review. Prefer reading and analysis over writing code. Suggest implementation strategies without modifying files directly.

PLAN MANAGEMENT:
When creating a plan:
1. Use CreatePlan tool to generate PLAN.md with markdown checkboxes for all tasks
2. Structure tasks in logical phases/sections (e.g., "Phase 1: Setup", "Phase 2: Implementation")
3. Each task should be specific and actionable
4. Include an Overview section explaining the approach

When reviewing/updating:
1. Use ReadPlan to check current status
2. Use UpdatePlan to mark items complete or add new tasks
3. Keep the plan current with implementation progress

The PLAN.md serves as the single source of truth for the project roadmap.''';

      case AIModeType.review:
        return 'You are in code review mode. Analyze code for bugs, security issues, performance problems, and style. Provide specific, actionable feedback. Do not make changes.';

      case AIModeType.security:
        return 'You are in security audit mode. Focus exclusively on identifying security vulnerabilities: injection flaws, authentication issues, data exposure, misconfigurations. Report findings with severity ratings.';

      case AIModeType.debug:
        return 'You are in debug mode. Focus on diagnosing issues: read logs, trace code paths, inspect state, run targeted tests. Be methodical and systematic.';
    }
  }

  /// List of tools to disable in this mode (empty means all tools enabled)
  List<String> get disabledTools {
    switch (this) {
      case AIModeType.code:
        return []; // All tools enabled
      case AIModeType.architect:
      case AIModeType.review:
      case AIModeType.security:
        return ['Write', 'Edit', 'MultiFileEdit', 'DiffEdit', 'Bash', 'GitCommit'];
      case AIModeType.debug:
        return []; // All tools enabled
    }
  }

  /// Temperature setting for this mode (null means use default)
  double? get temperature {
    switch (this) {
      case AIModeType.code:
        return 0.3;
      case AIModeType.debug:
        return 0.2;
      case AIModeType.architect:
      case AIModeType.review:
      case AIModeType.security:
        return null;
    }
  }

  /// Whether this mode uses plan mode
  bool get planMode {
    switch (this) {
      case AIModeType.code:
      case AIModeType.debug:
        return false;
      case AIModeType.architect:
      case AIModeType.review:
      case AIModeType.security:
        return true;
    }
  }
}

/// All available AI modes in order
final List<AIModeType> allAIModes = [
  AIModeType.code,
  AIModeType.architect,
  AIModeType.review,
  AIModeType.security,
  AIModeType.debug,
];

/// Default AI mode when none is selected
const AIModeType defaultAIMode = AIModeType.code;

/// Get an AIModeType from its string ID
AIModeType? getAIModeFromId(String? id) {
  if (id == null) return null;
  try {
    return AIModeType.values.firstWhere((mode) => mode.id == id);
  } catch (_) {
    return null;
  }
}
