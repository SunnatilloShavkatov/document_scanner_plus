import 'dart:io';

import 'package:document_scanner_plus/document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? scannedDocument;
  Future<PermissionStatus>? cameraPermissionFuture;

  @override
  void initState() {
    super.initState();
    cameraPermissionFuture = Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: FutureBuilder<PermissionStatus>(
            future: cameraPermissionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.isGranted) {
                  return Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: scannedDocument != null
                                ? Image(
                                    image: FileImage(scannedDocument!),
                                  )
                                : DocumentScanner(
                                    onDocumentScanned: (scannedImage) {
                                      setState(() {
                                        scannedDocument = scannedImage
                                            .getScannedDocumentAsFile();
                                        // imageLocation = image;
                                      });
                                    },
                                  ),
                          ),
                        ],
                      ),
                      scannedDocument != null
                          ? Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: TextButton(
                                child: const Text('retry'),
                                onPressed: () {
                                  setState(() {
                                    scannedDocument = null;
                                  });
                                },
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('camera permission denied'),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      );
}
