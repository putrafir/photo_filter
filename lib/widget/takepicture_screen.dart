import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kuliah_plugin/widget/filter_carousel.dart';

class TakepictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakepictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _TakepictureScreenState createState() => _TakepictureScreenState();
}

class _TakepictureScreenState extends State<TakepictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Uint8List? _capturedImageBytes;

  final _filterColor = ValueNotifier<Color>(Colors.transparent);

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _filterColor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                if (_capturedImageBytes == null)
                  Positioned.fill(
                    child: PhotoFilterCarousel(
                      cameraController: _controller,
                      filterColor: _filterColor,
                    ),
                  ),
                if (_capturedImageBytes != null)
                  Positioned.fill(
                    child: ValueListenableBuilder<Color>(
                      valueListenable: _filterColor,
                      builder: (context, color, child) {
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            color.withOpacity(0.5),
                            BlendMode.color,
                          ),
                          child: Image.memory(
                            _capturedImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            final bytes = await image.readAsBytes();
            setState(() {
              _capturedImageBytes = bytes;
            });
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
