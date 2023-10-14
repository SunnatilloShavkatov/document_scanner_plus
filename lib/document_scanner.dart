import 'dart:async';
import 'dart:io' show Platform;

import 'package:document_scanner_plus/scanned_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:document_scanner_plus/scanned_image.dart';

const String _methodChannelIdentifier = 'document_scanner';

class DocumentScanner extends StatefulWidget {
  const DocumentScanner({
    super.key,
    required this.onDocumentScanned,
    this.noGrayScale = true,
  });

  /// onDocumentScanned gets called when the scanner successfully scans a rectangle (document)
  final void Function(ScannedImage) onDocumentScanned;

  final bool noGrayScale;

  final MethodChannel _channel = const MethodChannel(_methodChannelIdentifier);

  @override
  State<DocumentScanner> createState() => _DocState();
}

class _DocState extends State<DocumentScanner> {
  @override
  void initState() {
    widget._channel.setMethodCallHandler(_onDocumentScanned);
    super.initState();
  }

  Future<dynamic> _onDocumentScanned(MethodCall call) async {
    if (call.method == 'onPictureTaken') {
      final Map<String, dynamic> argsAsMap =
          Map<String, dynamic>.from(call.arguments);

      final ScannedImage scannedImage = ScannedImage.fromMap(argsAsMap);

      if (scannedImage.croppedImage != null) {
        widget.onDocumentScanned(scannedImage);
      }
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _methodChannelIdentifier,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: _getParams(),
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: _methodChannelIdentifier,
        creationParams: _getParams(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      throw Exception('Current Platform is not supported');
    }
  }

  Map<String, dynamic> _getParams() {
    final Map<String, dynamic> allParams = {
      'noGrayScale': widget.noGrayScale,
    };

    final Map<String, dynamic> nonNullParams = {};
    allParams.forEach((key, value) {
      if (value != null) {
        nonNullParams.addAll({key: value});
      }
    });

    return nonNullParams;
  }
}
