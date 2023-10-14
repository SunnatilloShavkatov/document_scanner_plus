import 'dart:convert';

import 'dart:io';

class ScannedImage {
  ScannedImage({
    this.croppedImage,
    this.width,
    this.initialImage,
    this.height,
  });

  /// Parse a JSON message that is returned from platform channel.
  factory ScannedImage.fromJson(String str) =>
      ScannedImage.fromMap(json.decode(str));

  /// Convert a map (json) to a ScannedImage instance.
  factory ScannedImage.fromMap(Map<String, dynamic> json) => ScannedImage(
        croppedImage: json['croppedImage'],
        width: json['width'],
        initialImage: json['initialImage'],
        height: json['height'],
      );

  /// Cropped image (scanned document) file location.
  String? croppedImage;

  /// Cropped image (scanned document) width.
  int? width;

  /// The initial image before cropping the document.
  String? initialImage;

  /// Cropped image (scanned document) height.
  int? height;

  /// Get croppedImage (scanned document) as File.
  File getScannedDocumentAsFile() => File.fromUri(
        Uri.parse(croppedImage!),
      );
}
