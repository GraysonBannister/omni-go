import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/file_item.dart';
import '../../data/models/file_reference.dart';
import '../../data/models/image_attachment.dart';
import 'file_suggestion_popup.dart';
import 'file_reference_chip.dart';
import 'image_attachment_chip.dart';

/// A custom chat input field that supports @ file/folder referencing and image attachments.
///
/// When the user types "@", a popup appears showing matching files from the project.
/// Users can navigate with arrow keys and select files to include as context.
/// Also supports attaching images from gallery or camera.
class ChatInputField extends StatefulWidget {
  /// Controller for the text input
  final TextEditingController controller;

  /// Called when the user submits a message
  final VoidCallback onSend;

  /// List of available files to search
  final List<FileItem> availableFiles;

  /// Called when file references change
  final ValueChanged<List<FileReference>>? onReferencesChanged;

  /// Called when image attachments change
  final ValueChanged<List<ImageAttachment>>? onImagesChanged;

  /// Whether the input is enabled
  final bool enabled;

  /// Hint text to display when input is empty
  final String? hintText;

  /// Maximum number of lines
  final int? maxLines;

  /// Maximum number of images that can be attached
  final int maxImageAttachments;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.availableFiles,
    this.onReferencesChanged,
    this.onImagesChanged,
    this.enabled = true,
    this.hintText,
    this.maxLines,
    this.maxImageAttachments = 5,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  /// Whether the suggestion popup is visible
  bool _showSuggestions = false;

  /// Current search query (text after @)
  String _searchQuery = '';

  /// Current cursor position when @ was triggered
  int _mentionStartIndex = -1;

  /// List of selected file references
  final List<FileReference> _selectedReferences = [];

  /// List of selected image attachments
  final List<ImageAttachment> _selectedImages = [];

  /// Focus node for the text field
  final FocusNode _focusNode = FocusNode();

  /// Key for getting the render box position
  final GlobalKey _inputKey = GlobalKey();

  /// Currently highlighted suggestion index
  int _highlightedIndex = 0;

  /// Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  /// Called when the text changes - detect @ mentions
  void _onTextChanged() {
    final text = widget.controller.text;
    final cursorPosition = widget.controller.selection.baseOffset;
    
    // Check if we're in mention mode
    if (_mentionStartIndex >= 0) {
      // Check if cursor moved before the mention start
      if (cursorPosition < _mentionStartIndex) {
        _closeSuggestions();
        return;
      }
      
      // Extract the search query
      if (cursorPosition > _mentionStartIndex) {
        final query = text.substring(_mentionStartIndex, cursorPosition);
        // Check if query contains whitespace (end mention)
        if (query.contains(' ') || query.contains('\n')) {
          _closeSuggestions();
          return;
        }
        setState(() {
          _searchQuery = query.substring(1); // Remove the @
          _highlightedIndex = 0;
        });
      }
    } else {
      // Check if @ was just typed before cursor
      if (cursorPosition > 0 && cursorPosition <= text.length) {
        final charAtCursor = text.substring(cursorPosition - 1, cursorPosition);
        if (charAtCursor == '@') {
          // Check if @ is at start or preceded by whitespace
          if (cursorPosition == 1 || 
              text[cursorPosition - 2].trim().isEmpty) {
            setState(() {
              _mentionStartIndex = cursorPosition - 1;
              _showSuggestions = true;
              _searchQuery = '';
              _highlightedIndex = 0;
            });
          }
        }
      }
    }
  }

  /// Close the suggestion popup
  void _closeSuggestions() {
    setState(() {
      _showSuggestions = false;
      _searchQuery = '';
      _mentionStartIndex = -1;
      _highlightedIndex = 0;
    });
  }

  /// Get filtered list of matching files
  List<FileItem> get _filteredFiles {
    if (_searchQuery.isEmpty) {
      return widget.availableFiles.take(50).toList();
    }
    
    final query = _searchQuery.toLowerCase();
    return widget.availableFiles
        .where((file) => file.name.toLowerCase().contains(query))
        .take(50)
        .toList();
  }

  /// Select a file from the suggestion list
  void _selectFile(FileItem file) {
    final reference = FileReference.fromFileItem(file);
    
    setState(() {
      _selectedReferences.add(reference);
    });
    
    // Update the text to replace @query with @filename
    final text = widget.controller.text;
    final cursorPosition = widget.controller.selection.baseOffset;
    
    if (_mentionStartIndex >= 0 && cursorPosition >= _mentionStartIndex) {
      final beforeMention = text.substring(0, _mentionStartIndex);
      final afterMention = cursorPosition < text.length 
          ? text.substring(cursorPosition) 
          : '';
      
      final newText = '$beforeMention@${file.name} $afterMention';
      
      widget.controller.text = newText;
      widget.controller.selection = TextSelection.collapsed(
        offset: _mentionStartIndex + file.name.length + 2, // +2 for @ and space
      );
    }
    
    _closeSuggestions();
    
    // Notify parent of reference changes
    widget.onReferencesChanged?.call(List.unmodifiable(_selectedReferences));
    
    // Keep focus on input
    _focusNode.requestFocus();
  }

  /// Remove a selected reference
  void _removeReference(FileReference reference) {
    setState(() {
      _selectedReferences.removeWhere((r) => r.path == reference.path);
    });
    
    // Also remove from text
    final text = widget.controller.text;
    final displayText = reference.displayText;
    final index = text.indexOf(displayText);
    
    if (index >= 0) {
      widget.controller.text = text.replaceRange(index, index + displayText.length, '');
    }
    
    widget.onReferencesChanged?.call(List.unmodifiable(_selectedReferences));
  }

  /// Handle keyboard events for navigation
  void _handleKeyEvent(KeyEvent event) {
    if (!_showSuggestions) return;
    
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          setState(() {
            _highlightedIndex = (_highlightedIndex + 1).clamp(0, _filteredFiles.length - 1);
          });
          break;
        case LogicalKeyboardKey.arrowUp:
          setState(() {
            _highlightedIndex = (_highlightedIndex - 1).clamp(0, _filteredFiles.length - 1);
          });
          break;
        case LogicalKeyboardKey.enter:
          if (_filteredFiles.isNotEmpty) {
            _selectFile(_filteredFiles[_highlightedIndex]);
          }
          break;
        case LogicalKeyboardKey.escape:
          _closeSuggestions();
          break;
      }
    }
  }

  /// Clear all references (call when message is sent)
  void clearReferences() {
    setState(() {
      _selectedReferences.clear();
    });
    widget.onReferencesChanged?.call([]);
  }

  /// Clear all image attachments (call when message is sent)
  void clearImages() {
    setState(() {
      _selectedImages.clear();
    });
    widget.onImagesChanged?.call([]);
  }

  /// Pick an image from the gallery
  Future<void> _pickFromGallery() async {
    if (!widget.enabled) return;
    if (_selectedImages.length >= widget.maxImageAttachments) {
      _showMaxImagesWarning();
      return;
    }

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final attachment = ImageAttachment.fromPath(pickedFile.path, fileName: pickedFile.name);
        setState(() {
          _selectedImages.add(attachment);
        });
        widget.onImagesChanged?.call(List.unmodifiable(_selectedImages));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  /// Take a photo with the camera
  Future<void> _takePhoto() async {
    if (!widget.enabled) return;
    if (_selectedImages.length >= widget.maxImageAttachments) {
      _showMaxImagesWarning();
      return;
    }

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final attachment = ImageAttachment.fromPath(pickedFile.path, fileName: pickedFile.name);
        setState(() {
          _selectedImages.add(attachment);
        });
        widget.onImagesChanged?.call(List.unmodifiable(_selectedImages));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture photo: $e')),
        );
      }
    }
  }

  /// Show a bottom sheet to choose image source
  void _showImageSourceDialog() {
    if (!widget.enabled) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show warning when max images reached
  void _showMaxImagesWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Maximum ${widget.maxImageAttachments} images allowed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Remove a selected image
  void _removeImage(ImageAttachment image) {
    setState(() {
      _selectedImages.removeWhere((img) => img.id == image.id);
    });
    widget.onImagesChanged?.call(List.unmodifiable(_selectedImages));
  }

  /// Show full screen preview of an image
  void _previewImage(ImageAttachment image) {
    ImagePreviewDialog.show(context, image);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredFiles = _filteredFiles;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selected image attachments chips
        if (_selectedImages.isNotEmpty)
          ImageAttachmentChipRow(
            attachments: _selectedImages,
            onRemove: _removeImage,
            onTap: _previewImage,
          ),

        // Selected file references chips
        if (_selectedReferences.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            constraints: const BoxConstraints(maxHeight: 100),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedReferences
                    .map((ref) => FileReferenceChip(
                          reference: ref,
                          onRemove: () => _removeReference(ref),
                        ))
                    .toList(),
              ),
            ),
          ),

        // Terminal-styled input field
        KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: _handleKeyEvent,
          child: CompositedTransformTarget(
            link: LayerLink(),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Terminal prompt symbol
                  Text(
                    '> ',
                    style: GoogleFonts.jetBrainsMono(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  // Terminal input field
                  Expanded(
                    child: TextField(
                      key: _inputKey,
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      maxLines: widget.maxLines,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => widget.onSend(),
                      style: GoogleFonts.jetBrainsMono(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                      cursorColor: theme.colorScheme.primary,
                      cursorWidth: 8,
                      cursorRadius: Radius.zero,
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? 'Type a message... Use @ to reference files',
                        hintStyle: GoogleFonts.jetBrainsMono(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                  // Photo/Camera button
                  if (widget.enabled)
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
                      onPressed: _showImageSourceDialog,
                      color: theme.colorScheme.primary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Attach photo',
                    ),
                  // Send button
                  if (widget.enabled)
                    IconButton(
                      icon: const Icon(Icons.send, size: 20),
                      onPressed: widget.onSend,
                      color: theme.colorScheme.primary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // File suggestion popup
        if (_showSuggestions && filteredFiles.isNotEmpty)
          FileSuggestionPopup(
            files: filteredFiles,
            query: _searchQuery,
            highlightedIndex: _highlightedIndex,
            onSelect: _selectFile,
            onClose: _closeSuggestions,
          ),
      ],
    );
  }
}

/// Extension to get file references and images from the input field
extension ChatInputFieldStateExtension on GlobalKey<_ChatInputFieldState> {
  List<FileReference>? get references {
    return currentState?._selectedReferences;
  }

  List<ImageAttachment>? get images {
    return currentState?._selectedImages;
  }

  void clearReferences() {
    currentState?.clearReferences();
  }

  void clearImages() {
    currentState?.clearImages();
  }
}
