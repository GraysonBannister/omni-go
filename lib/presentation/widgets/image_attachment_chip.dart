import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/image_attachment.dart';

/// A small chip widget that displays a thumbnail of a selected image
/// with an option to remove it.
class ImageAttachmentChip extends StatelessWidget {
  final ImageAttachment attachment;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const ImageAttachmentChip({
    super.key,
    required this.attachment,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image thumbnail
              Image.file(
                File(attachment.path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.colorScheme.errorContainer,
                    child: Icon(
                      Icons.broken_image,
                      color: theme.colorScheme.error,
                      size: 24,
                    ),
                  );
                },
              ),
              // Remove button overlay
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A row of image attachment chips with horizontal scrolling.
class ImageAttachmentChipRow extends StatelessWidget {
  final List<ImageAttachment> attachments;
  final ValueChanged<ImageAttachment> onRemove;
  final ValueChanged<ImageAttachment>? onTap;

  const ImageAttachmentChipRow({
    super.key,
    required this.attachments,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final attachment = attachments[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ImageAttachmentChip(
              attachment: attachment,
              onRemove: () => onRemove(attachment),
              onTap: onTap != null ? () => onTap!(attachment) : null,
            ),
          );
        },
      ),
    );
  }
}

/// A full-screen dialog to preview an image attachment.
class ImagePreviewDialog extends StatelessWidget {
  final ImageAttachment attachment;

  const ImagePreviewDialog({
    super.key,
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(attachment.path),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, ImageAttachment attachment) {
    showDialog(
      context: context,
      builder: (context) => ImagePreviewDialog(attachment: attachment),
    );
  }
}
