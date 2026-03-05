import 'dart:ui';

import 'package:flutter/material.dart';


class DashedBorder extends StatelessWidget {
  final Widget child;

  const DashedBorder({super.key, required this.child,
  this.color
  });
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(color: color),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({this.color});
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color??Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final dashWidth = 5.0;
    final dashSpace = 3.0;

    PathMetrics metrics = path.computeMetrics();
    for (PathMetric metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, nextDistance),
          paint,
        );
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class DashedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DashedLine({
    super.key,
    this.height = 1,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: color, height: height),
      child: SizedBox(height: height),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final double height;
  final Color color;

  _DashedLinePainter({required this.height, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = height;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}