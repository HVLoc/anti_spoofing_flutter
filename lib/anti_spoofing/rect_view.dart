import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class RectView extends StatelessWidget {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final Color color;
  final double textSize;
  final double textPadding;
  final double radius;
  final double lineLength;
  final double confidence;

  const RectView({
    super.key,
    this.x1 = 0,
    this.y1 = 0,
    this.x2 = 100,
    this.y2 = 100,
    this.color = Colors.red,
    this.textSize = 50,
    this.textPadding = 8,
    this.radius = 5,
    this.lineLength = 45,
    this.confidence = 0.789,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _RectPainter(
        rect: Rect.fromLTRB(x1, y1, x2, y2),
        color: color,
        textSize: textSize,
        textPadding: textPadding,
        radius: radius,
        lineLength: lineLength,
        confidence: confidence,
      ),
    );
  }
}

class _RectPainter extends CustomPainter {
  final Rect rect;
  final Color color;
  final double textSize;
  final double textPadding;
  final double radius;
  final double lineLength;
  final double confidence;

  _RectPainter({
    required this.rect,
    required this.color,
    required this.textSize,
    required this.textPadding,
    required this.radius,
    required this.lineLength,
    required this.confidence,
  });

  final DecimalFormat = NumberFormat("0.000");

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Vẽ các góc bo + đoạn thẳng 4 góc
    void drawCorner(Rect arcRect, double startAngle, double sweepAngle) {
      canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
    }

    // Left Top
    canvas.drawLine(Offset(rect.left, rect.top + lineLength),
        Offset(rect.left, rect.top + radius), paint);
    drawCorner(Rect.fromLTWH(rect.left, rect.top, radius * 2, radius * 2),
        180 * 3.1416 / 180, 90 * 3.1416 / 180);
    canvas.drawLine(Offset(rect.left + radius, rect.top),
        Offset(rect.left + lineLength, rect.top), paint);

    // Right Top
    canvas.drawLine(Offset(rect.right - lineLength, rect.top),
        Offset(rect.right - radius, rect.top), paint);
    drawCorner(
        Rect.fromLTWH(
            rect.right - radius * 2, rect.top, radius * 2, radius * 2),
        270 * 3.1416 / 180,
        90 * 3.1416 / 180);
    canvas.drawLine(Offset(rect.right, rect.top + radius),
        Offset(rect.right, rect.top + lineLength), paint);

    // Left Bottom
    canvas.drawLine(Offset(rect.left, rect.bottom - lineLength),
        Offset(rect.left, rect.bottom - radius), paint);
    drawCorner(
        Rect.fromLTWH(
            rect.left, rect.bottom - radius * 2, radius * 2, radius * 2),
        180 * 3.1416 / 180,
        -90 * 3.1416 / 180);
    canvas.drawLine(Offset(rect.left + radius, rect.bottom),
        Offset(rect.left + lineLength, rect.bottom), paint);

    // Right Bottom
    canvas.drawLine(Offset(rect.right - lineLength, rect.bottom),
        Offset(rect.right - radius, rect.bottom), paint);
    drawCorner(
        Rect.fromLTWH(rect.right - radius * 2, rect.bottom - radius * 2,
            radius * 2, radius * 2),
        90 * 3.1416 / 180,
        -90 * 3.1416 / 180);
    canvas.drawLine(Offset(rect.right, rect.bottom - radius),
        Offset(rect.right, rect.bottom - lineLength), paint);

    // Text background
    final textPainter = TextPainter(
      text: TextSpan(
        text: DecimalFormat.format(confidence),
        style: TextStyle(fontSize: textSize, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    final bgRect = Rect.fromLTWH(
      rect.left,
      rect.top - textHeight - 2 * textPadding,
      textWidth + 2 * textPadding,
      textHeight + 2 * textPadding,
    );

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, fillPaint);

    // Draw text
    textPainter.paint(
      canvas,
      Offset(rect.left + textPadding, rect.top - textHeight - textPadding),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
