import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CarouselFlowDelegate extends FlowDelegate {
  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;
    // All available painting width
    final size = context.size.width;

    // The distance that a single item "page" takes up
    final itemExtent = size / filtersPerScreen;

    // The current scroll position expressed as an item fraction
    final active = viewportOffset.pixels / itemExtent;

    // Index of the first item we need to paint at this moment
    final min = math.max(0, active.floor() - 3).toInt();
    // Index of the last item we need to paint at this moment
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Generate transforms for the visible items and sort by distance
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();

      // Calculate scale and opacity based on distance from center
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}
