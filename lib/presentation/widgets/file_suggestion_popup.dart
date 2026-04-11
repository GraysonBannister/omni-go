import 'package:flutter/material.dart';
import '../../data/models/file_item.dart';

/// A popup that displays file suggestions when the user types "@" in chat.
/// 
/// Shows a scrollable list of matching files with icons and highlighting.
class FileSuggestionPopup extends StatelessWidget {
  /// List of files to display
  final List<FileItem> files;
  
  /// Current search query (for highlighting matches)
  final String query;
  
  /// Currently highlighted index (for keyboard navigation)
  final int highlightedIndex;
  
  /// Called when a file is selected
  final ValueChanged<FileItem> onSelect;
  
  /// Called when the popup should close (e.g., on background tap)
  final VoidCallback onClose;
  
  /// Maximum height of the popup
  final double maxHeight;
  
  /// Width of the popup
  final double width;

  const FileSuggestionPopup({
    super.key,
    required this.files,
    required this.query,
    required this.highlightedIndex,
    required this.onSelect,
    required this.onClose,
    this.maxHeight = 300,
    this.width = 350,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          maxWidth: width,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.zero,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      files.length == 1 
                          ? '1 file found' 
                          : '${files.length} files found',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  // Keyboard hints
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _KeyboardHint(icon: Icons.keyboard_arrow_up),
                      _KeyboardHint(icon: Icons.keyboard_arrow_down),
                      const SizedBox(width: 4),
                      Text(
                        'to navigate',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _KeyboardHint(label: '↵'),
                      const SizedBox(width: 4),
                      Text(
                        'to select',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // File list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  final isHighlighted = index == highlightedIndex;
                  
                  return _FileSuggestionItem(
                    file: file,
                    query: query,
                    isHighlighted: isHighlighted,
                    onTap: () => onSelect(file),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single file suggestion item in the popup
class _FileSuggestionItem extends StatelessWidget {
  final FileItem file;
  final String query;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _FileSuggestionItem({
    required this.file,
    required this.query,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: isHighlighted 
          ? theme.colorScheme.primaryContainer.withOpacity(0.5)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // File or folder icon
              _FileIcon(file: file),
              const SizedBox(width: 12),
              
              // File name with highlighted match
              Expanded(
                child: _HighlightedText(
                  text: file.name,
                  query: query,
                  highlightStyle: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  ),
                  baseStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ) ?? const TextStyle(),
                ),
              ),
              
              // Directory indicator for folders
              if (file.isDirectory)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Text(
                    'folder',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                      fontSize: 10,
                    ),
                  ),
                ),
              
              // Show file extension badge for files
              if (file.isFile && file.name.contains('.'))
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getExtensionColor(file.extension, theme),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Text(
                    file.extension.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getExtensionColor(String extension, ThemeData theme) {
    // Common extension colors
    final extColors = {
      'dart': Colors.blue,
      'js': Colors.yellow,
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
    
    return extColors[extension.toLowerCase()] ?? theme.colorScheme.primaryContainer;
  }
}

/// Widget that highlights matching query text
class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle highlightStyle;
  final TextStyle baseStyle;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.highlightStyle,
    required this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: baseStyle);
    }
    
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matches = <TextSpan>[];
    
    int currentIndex = 0;
    while (true) {
      final matchIndex = lowerText.indexOf(lowerQuery, currentIndex);
      if (matchIndex == -1) break;
      
      // Add text before match
      if (matchIndex > currentIndex) {
        matches.add(TextSpan(
          text: text.substring(currentIndex, matchIndex),
          style: baseStyle,
        ));
      }
      
      // Add highlighted match
      matches.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: highlightStyle,
      ));
      
      currentIndex = matchIndex + query.length;
    }
    
    // Add remaining text
    if (currentIndex < text.length) {
      matches.add(TextSpan(
        text: text.substring(currentIndex),
        style: baseStyle,
      ));
    }
    
    return RichText(
      text: TextSpan(children: matches),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Icon widget for file/folder
class _FileIcon extends StatelessWidget {
  final FileItem file;

  const _FileIcon({required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (file.isDirectory) {
      return Icon(
        Icons.folder,
        size: 20,
        color: theme.colorScheme.tertiary,
      );
    }
    
    // File icon with color based on extension
    final color = _getFileIconColor(file.extension, theme);
    return Icon(
      Icons.insert_drive_file,
      size: 20,
      color: color,
    );
  }
  
  Color _getFileIconColor(String extension, ThemeData theme) {
    final extColors = {
      'dart': Colors.blue,
      'js': Colors.yellow.shade700,
      'ts': Colors.blue.shade700,
      'json': Colors.green,
      'md': Colors.grey,
      'yaml': Colors.purple,
      'html': Colors.orange,
      'css': Colors.blue.shade300,
      'py': Colors.blue.shade500,
    };
    
    return extColors[extension.toLowerCase()] ?? theme.colorScheme.onSurfaceVariant;
  }
}

/// Small keyboard hint widget
class _KeyboardHint extends StatelessWidget {
  final IconData? icon;
  final String? label;

  const _KeyboardHint({this.icon, this.label})
      : assert(icon != null || label != null, 'Must provide icon or label');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: icon != null
          ? Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant)
          : Text(
              label!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
