import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DashPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  DashPainter({
    this.color = const Color(0xFFE7EEF8),
    this.strokeWidth = 1.5,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = borderRadius.toRRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    final Path path = Path()..addRRect(rrect);

    for (final ui.PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}

class DashedContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  const DashedContainer({
    super.key,
    required this.child,
    this.color = const Color(0xFFE7EEF8),
    this.strokeWidth = 1.5,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
