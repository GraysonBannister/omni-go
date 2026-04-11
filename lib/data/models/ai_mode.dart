import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_mode.freezed.dart';
part 'ai_mode.g.dart';

/// Color converter for JSON serialization
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}

/// IconData converter for JSON serialization
class IconDataConverter implements JsonConverter<IconData, String> {
  const IconDataConverter();

  @override
  IconData fromJson(String json) {
    // Map of icon names to IconData
    const iconMap = <String, IconData>{
      'code': Icons.code,
      'account_balance': Icons.account_balance,
      'visibility': Icons.visibility,
      'shield': Icons.shield,
      'bug_report': Icons.bug_report,
    };
    return iconMap[json] ?? Icons.code;
  }

  @override
  String toJson(IconData icon) {
    // Use codePoint for comparison since IconData doesn't have primitive equality
    switch (icon.codePoint) {
      case 0xe86f: // Icons.code
        return 'code';
      case 0xe84c: // Icons.account_balance
        return 'account_balance';
      case 0xe8f4: // Icons.visibility
        return 'visibility';
      case 0xe8e8: // Icons.shield
        return 'shield';
      case 0xe868: // Icons.bug_report
        return 'bug_report';
      default:
        return 'code';
    }
  }
}

/// Represents an AI mode configuration
@freezed
class AIMode with _$AIMode {
  const AIMode._();

  const factory AIMode({
    /// Unique identifier for the mode (code, architect, review, security, debug)
    required String id,

    /// Display name for the mode
    required String name,

    /// Short description of the mode's purpose
    required String description,

    /// Icon data for the mode
    @IconDataConverter() required IconData iconData,

    /// Primary color for the mode (matches omni-code-v2 colors)
    @ColorConverter() required Color color,

    /// Additional system prompt text appended for this mode
    String? systemPromptAppend,

    /// List of tools to disable in this mode (empty means all tools enabled)
    @Default([]) List<String> disabledTools,

    /// Temperature setting for this mode (null means use default)
    double? temperature,

    /// Whether this mode uses plan mode
    @Default(false) bool planMode,
  }) = _AIMode;

  factory AIMode.fromJson(Map<String, dynamic> json) => _$AIModeFromJson(json);

  /// Get the background color (10% opacity)
  @JsonKey(ignore: true)
  Color get backgroundColor => color.withOpacity(0.1);
}

/// Predefined AI modes matching omni-code-v2
class DefaultAIModes {
  // Code mode - Blue
  static final code = AIMode(
    id: 'code',
    name: 'Code',
    description: 'General coding assistance',
    iconData: Icons.code,
    color: const Color(0xFF3B82F6),
    systemPromptAppend: '''You are in coding mode. Focus on implementing changes efficiently. Write clean, well-structured code. Test when possible.

PLAN REFERENCE:
When working on a task:
1. Check if PLAN.md exists using ReadPlan tool
2. Reference the plan for context on current task and overall progress
3. After completing work, use UpdatePlan to check off relevant items
4. Add implementation notes to the plan if decisions were made

Do NOT create new plans in code mode - only reference or update existing plans.''',
    disabledTools: const [],
    temperature: 0.3,
    planMode: false,
  );

  // Architect mode - Amber
  static final architect = AIMode(
    id: 'architect',
    name: 'Architect',
    description: 'Design and architecture planning',
    iconData: Icons.account_balance,
    color: const Color(0xFFF59E0B),
    systemPromptAppend: '''You are in architect mode. Focus on high-level design, planning, and code review. Prefer reading and analysis over writing code. Suggest implementation strategies without modifying files directly.

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

The PLAN.md serves as the single source of truth for the project roadmap.''',
    disabledTools: const ['Write', 'Edit', 'MultiFileEdit', 'DiffEdit', 'Bash', 'GitCommit'],
    planMode: true,
  );

  // Review mode - Purple
  static final review = AIMode(
    id: 'review',
    name: 'Review',
    description: 'Code review and analysis',
    iconData: Icons.visibility,
    color: const Color(0xFF8B5CF6),
    systemPromptAppend: 'You are in code review mode. Analyze code for bugs, security issues, performance problems, and style. Provide specific, actionable feedback. Do not make changes.',
    disabledTools: const ['Write', 'Edit', 'MultiFileEdit', 'DiffEdit', 'Bash', 'GitCommit'],
    planMode: true,
  );

  // Security mode - Red
  static final security = AIMode(
    id: 'security',
    name: 'Security',
    description: 'Security audit and fixes',
    iconData: Icons.shield,
    color: const Color(0xFFEF4444),
    systemPromptAppend: 'You are in security audit mode. Focus exclusively on identifying security vulnerabilities: injection flaws, authentication issues, data exposure, misconfigurations. Report findings with severity ratings.',
    disabledTools: const ['Write', 'Edit', 'MultiFileEdit', 'DiffEdit', 'Bash', 'GitCommit'],
    planMode: true,
  );

  // Debug mode - Green
  static final debug = AIMode(
    id: 'debug',
    name: 'Debug',
    description: 'Debugging and troubleshooting',
    iconData: Icons.bug_report,
    color: const Color(0xFF10B981),
    systemPromptAppend: 'You are in debug mode. Focus on diagnosing issues: read logs, trace code paths, inspect state, run targeted tests. Be methodical and systematic.',
    disabledTools: const [],
    temperature: 0.2,
    planMode: false,
  );

  /// All available modes in order
  static final List<AIMode> all = [
    code,
    architect,
    review,
    security,
    debug,
  ];

  /// Default mode (code)
  static AIMode get defaultMode => code;

  /// Get a mode by its ID
  static AIMode? fromId(String? id) {
    if (id == null) return null;
    try {
      return all.firstWhere((mode) => mode.id == id);
    } catch (_) {
      return null;
    }
  }
}
