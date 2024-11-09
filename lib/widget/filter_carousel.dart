import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:kuliah_plugin/widget/filter_selector.dart';

class PhotoFilterCarousel extends StatefulWidget {
  final CameraController cameraController;
  final ValueNotifier<Color> filterColor;

  const PhotoFilterCarousel({
    super.key,
    required this.cameraController,
    required this.filterColor,
  });

  @override
  State<PhotoFilterCarousel> createState() => _PhotoFilterCarouselState();
}

class _PhotoFilterCarouselState extends State<PhotoFilterCarousel> {
  final _filters = [
    Colors.transparent,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
    ),
  ];

  void _onFilterChanged(Color value) {
    widget.filterColor.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          _buildCameraPreview(),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: _buildFilterSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return ValueListenableBuilder<Color>(
      valueListenable: widget.filterColor,
      builder: (context, color, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            color.withOpacity(0.3),
            BlendMode.overlay,
          ),
          child: ClipRect(
            child: AspectRatio(
              aspectRatio: widget.cameraController.value.aspectRatio,
              child: CameraPreview(widget.cameraController),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSelector() {
    return FilterSelector(
      onFilterChanged: _onFilterChanged,
      filters: _filters,
    );
  }
}
