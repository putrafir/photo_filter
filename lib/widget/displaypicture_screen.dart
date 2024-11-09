import 'dart:io';

import 'package:flutter/material.dart';

class DisplaypictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplaypictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display the picture'),
      ),
      body: Image.file(File(imagePath)),
    );
  }
}
