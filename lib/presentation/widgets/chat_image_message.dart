import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../data/models/image_attachment.dart';

/// Displays images within chat message bubbles.
/// 
/// This widget handles both locally stored images (File) and
/// base64 encoded images that were received from the server.
class ChatImageMessage extends StatelessWidget {
  final List<ImageAttachment> attachments;
  final bool isUser;

  const ChatImageMessage({
    super.key,
    required this.attachments,
    this.isUser = true,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show single image or grid for multiple
    if (attachments.length == 1) {
      return _buildSingleImage(context, attachments.first);
    } else {
      return _buildImageGrid(context, attachments);
    }
  }

  Widget _buildSingleImage(BuildContext context, ImageAttachment attachment) {
    return GestureDetector(
      onTap: () => _showFullScreenPreview(context, attachment),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildImageWidget(context, attachment),
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<ImageAttachment> attachments) {
    // Determine grid layout based on count
    int crossAxisCount = 2;
    if (attachments.length == 2) {
      crossAxisCount = 2;
    } else if (attachments.length >= 3) {
      crossAxisCount = 3;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final attachment = attachments[index];
        return GestureDetector(
          onTap: () => _showFullScreenPreview(context, attachment),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(context, attachment),
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(BuildContext context, ImageAttachment attachment) {
    // If we have a local file path, use Image.file
    if (attachment.path.isNotEmpty && File(attachment.path).existsSync()) {
      return Image.file(
        File(attachment.path),
        fit: BoxFit.cover,
        errorBuilder: (ctx, error, stackTrace) {
          return _buildErrorWidget(ctx);
        },
      );
    }

    // If we have base64 data, decode and display
    if (attachment.base64Data != null && attachment.base64Data!.isNotEmpty) {
      try {
        final bytes = base64Decode(attachment.base64Data!);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, stackTrace) {
            return _buildErrorWidget(ctx);
          },
        );
      } catch (e) {
        return _buildErrorWidget(context);
      }
    }

    return _buildErrorWidget(context);
  }

  Widget _buildErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.errorContainer,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: theme.colorScheme.error,
          size: 32,
        ),
      ),
    );
  }

  void _showFullScreenPreview(BuildContext context, ImageAttachment attachment) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => Navigator.of(dialogContext).pop(),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImageWidget(dialogContext, attachment),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays images from base64 data (for images received in messages).
class Base64ImageWidget extends StatelessWidget {
  final String base64Data;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback? onTap;

  const Base64ImageWidget({
    super.key,
    required this.base64Data,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final bytes = base64Decode(base64Data);
      return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            bytes,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return _buildError(context);
            },
          ),
        ),
      );
    } catch (e) {
      return _buildError(context);
    }
  }

  Widget _buildError(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      color: theme.colorScheme.errorContainer,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}
