import 'dart:convert';
import 'dart:io';

/// Represents an image attachment to be included with a chat message.
///
/// This model handles both local file storage for preview and base64
/// encoding for transmission to the server.
class ImageAttachment {
  /// Unique identifier for this attachment
  final String id;

  /// Local file path to the image
  final String path;

  /// MIME type of the image (e.g., image/jpeg, image/png)
  final String mediaType;

  /// Base64 encoded image data for transmission
  /// This is computed lazily when needed for sending
  final String? base64Data;

  /// Optional thumbnail path for preview (smaller version)
  final String? thumbnailPath;

  /// Original file name
  final String fileName;

  /// File size in bytes
  final int? fileSize;

  const ImageAttachment({
    required this.id,
    required this.path,
    required this.mediaType,
    this.base64Data,
    this.thumbnailPath,
    required this.fileName,
    this.fileSize,
  });

  /// Creates an ImageAttachment from a picked file path.
  /// 
  /// The [path] should be the absolute path to the image file.
  /// The [fileName] is extracted from the path if not provided.
  /// The [mediaType] is determined from the file extension.
  factory ImageAttachment.fromPath(String path, {String? fileName}) {
    final actualFileName = fileName ?? path.split('/').last.split('\\').last;
    final extension = actualFileName.split('.').last.toLowerCase();

    String mediaType;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        mediaType = 'image/jpeg';
        break;
      case 'png':
        mediaType = 'image/png';
        break;
      case 'gif':
        mediaType = 'image/gif';
        break;
      case 'webp':
        mediaType = 'image/webp';
        break;
      case 'heic':
      case 'heif':
        mediaType = 'image/heic';
        break;
      default:
        mediaType = 'image/jpeg';
    }

    return ImageAttachment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      path: path,
      mediaType: mediaType,
      fileName: actualFileName,
    );
  }

  /// Reads the image file and encodes it as base64 for transmission.
  /// 
  /// Returns a new ImageAttachment with the base64Data populated.
  /// This can throw if the file cannot be read.
  Future<ImageAttachment> encodeForTransmission() async {
    if (base64Data != null) {
      return this;
    }

    final file = File(path);
    final bytes = await file.readAsBytes();
    final encoded = base64Encode(bytes);

    return ImageAttachment(
      id: id,
      path: path,
      mediaType: mediaType,
      base64Data: encoded,
      thumbnailPath: thumbnailPath,
      fileName: fileName,
      fileSize: bytes.length,
    );
  }

  /// Converts this attachment to a JSON content block format
  /// compatible with the omni-code-v2 API.
  /// 
  /// This requires base64Data to be populated first (call encodeForTransmission).
  Map<String, dynamic> toContentBlock() {
    if (base64Data == null) {
      throw StateError('ImageAttachment must be encoded before converting to content block. Call encodeForTransmission() first.');
    }

    return {
      'type': 'image',
      'source': {
        'type': 'base64',
        'media_type': mediaType,
        'data': base64Data,
      },
    };
  }

  /// Creates an ImageAttachment from a JSON content block.
  factory ImageAttachment.fromContentBlock(Map<String, dynamic> block) {
    final source = block['source'] as Map<String, dynamic>?;
    if (source == null) {
      throw ArgumentError('Invalid image content block: missing source');
    }

    return ImageAttachment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      path: '', // No local path when receiving from server
      mediaType: source['media_type'] as String? ?? 'image/jpeg',
      base64Data: source['data'] as String?,
      fileName: 'image_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Returns a copy with updated fields
  ImageAttachment copyWith({
    String? id,
    String? path,
    String? mediaType,
    String? base64Data,
    String? thumbnailPath,
    String? fileName,
    int? fileSize,
  }) {
    return ImageAttachment(
      id: id ?? this.id,
      path: path ?? this.path,
      mediaType: mediaType ?? this.mediaType,
      base64Data: base64Data ?? this.base64Data,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  @override
  String toString() {
    return 'ImageAttachment(id: $id, fileName: $fileName, mediaType: $mediaType, path: $path, hasBase64: ${base64Data != null})';
  }
}
