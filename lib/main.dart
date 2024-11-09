import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kuliah_plugin/widget/filter_carousel.dart';
// import 'package:kuliah_plugin/red_text_widget.dart';
import 'package:kuliah_plugin/widget/takePicture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final camera = await availableCameras();
  final firstCamera = camera.first;
  final secondCamera = camera.last;

  runApp(
    MaterialApp(
      home: TakepictureScreen(camera: firstCamera),
      debugShowCheckedModeBanner: false,
    ),
  );
}
