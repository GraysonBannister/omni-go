import 'package:flutter/material.dart';
import '../../data/models/file_reference.dart';

/// A chip widget that displays a file reference with an icon and remove button.
/// 
/// Used to show selected file references above the chat input field.
class FileReferenceChip extends StatelessWidget {
  /// The file reference to display
  final FileReference reference;
  
  /// Called when the remove button is tapped
  final VoidCallback onRemove;
  
  /// Optional: Called when the chip is tapped
  final VoidCallback? onTap;
  
  /// Whether the chip is in a compact mode (smaller padding)
  final bool compact;

  const FileReferenceChip({
    super.key,
    required this.reference,
    required this.onRemove,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Get colors based on file type
    final chipColor = reference.isDirectory
        ? theme.colorScheme.tertiaryContainer
        : _getFileColor(reference.extension, theme);
    
    final foregroundColor = reference.isDirectory
        ? theme.colorScheme.onTertiaryContainer
        : _getFileForegroundColor(reference.extension, theme, isDark);
    
    return Material(
      color: Colors.transparent,
      child:       InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.zero,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: compact ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: chipColor.withOpacity(0.15),
            borderRadius: BorderRadius.zero,
            border: Border.all(
              color: chipColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // File/Folder icon
              Icon(
                reference.isDirectory ? Icons.folder : Icons.insert_drive_file,
                size: compact ? 14 : 16,
                color: foregroundColor,
              ),
              const SizedBox(width: 6),
              
              // File name
              Flexible(
                child: Text(
                  reference.name,
                  style: (compact 
                      ? theme.textTheme.bodySmall 
                      : theme.textTheme.bodyMedium
                  )?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Remove button
              const SizedBox(width: 4),
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.zero,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.close,
                    size: compact ? 12 : 14,
                    color: foregroundColor.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Get background color based on file extension
  Color _getFileColor(String extension, ThemeData theme) {
    final extColors = {
      'dart': Colors.blue,
      'js': Colors.yellow.shade700,
      'ts': Colors.blue.shade700,
      'tsx': Colors.blue.shade600,
      'jsx': Colors.yellow.shade700,
      'json': Colors.green,
      'md': Colors.grey,
      'yaml': Colors.purple,
      'yml': Colors.purple,
      'html': Colors.orange,
      'css': Colors.blue.shade300,
      'scss': Colors.pink,
      'py': Colors.blue.shade500,
      'go': Colors.cyan,
      'rs': Colors.orange.shade700,
      'java': Colors.red.shade400,
      'kt': Colors.purple.shade400,
      'swift': Colors.orange,
      'php': Colors.indigo,
      'rb': Colors.red,
    };
    
    return extColors[extension.toLowerCase()] ?? theme.colorScheme.primary;
  }
  
  /// Get foreground color based on file extension
  Color _getFileForegroundColor(String extension, ThemeData theme, bool isDark) {
    final color = _getFileColor(extension, theme);
    
    // For dark backgrounds, use the color directly if it's bright enough
    // Otherwise adjust it to be more visible
    if (isDark) {
      // Check if color is dark
      final luminance = color.computeLuminance();
      if (luminance < 0.5) {
        // Dark color on dark background - lighten it
        return color.withLightness(0.7);
      }
    }
    
    return color;
  }
}

/// Extension to adjust color lightness
extension _ColorExtension on Color {
  Color withLightness(double targetLightness) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(targetLightness).toColor();
  }
}

/// A row of file reference chips that can be used in message bubbles
class FileReferenceChipRow extends StatelessWidget {
  /// List of file references to display
  final List<FileReference> references;
  
  /// Called when a chip is removed (optional, if null chips are not removable)
  final ValueChanged<FileReference>? onRemove;
  
  /// Whether chips are compact
  final bool compact;
  
  /// Maximum chips to show before "+N more"
  final int maxChips;

  const FileReferenceChipRow({
    super.key,
    required this.references,
    this.onRemove,
    this.compact = false,
    this.maxChips = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (references.isEmpty) return const SizedBox.shrink();
    
    final displayRefs = references.length > maxChips 
        ? references.take(maxChips).toList() 
        : references;
    
    final remainingCount = references.length - maxChips;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...displayRefs.map((ref) => FileReferenceChip(
            reference: ref,
            onRemove: onRemove != null ? () => onRemove!(ref) : () {},
            compact: compact,
          )),
          
          if (remainingCount > 0)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 12,
                vertical: compact ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                '+$remainingCount more',
                style: (compact 
                    ? theme.textTheme.bodySmall 
                    : theme.textTheme.bodyMedium
                )?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
