import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CaptureImage());
}

class CaptureImage extends StatefulWidget {
  const CaptureImage({Key? key}) : super(key: key);

  @override
  State<CaptureImage> createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  final ImagePicker _picker = ImagePicker();
  String imagePath = 'default';
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Upload an image"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Image.file(File(imagePath)),

      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.image),
          onPressed: () async {
            // add functionality to upload an image
            image = await _picker.pickImage(source: ImageSource.camera);
            setState(() {
              imagePath = image!.path;
            });
          }),
    ));
  }
}
