import 'package:flutter/material.dart';

class CoverView extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final Color backColor;

  const CoverView({
    super.key,
    this.horizontalPadding = 0.0,
    this.verticalPadding = 0.0,
    this.backColor = Colors.blue,  // Default to blue for background
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: CoverPainter(
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        backColor: backColor,
      ),
    );
  }
}

class CoverPainter extends CustomPainter {
  final double horizontalPadding;
  final double verticalPadding;
  final Color backColor;

  CoverPainter({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.backColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backColor
      ..blendMode = BlendMode.srcOut;

    // Draw the background rectangle
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw the transparent rectangle (cut-out area)
    final rect = Rect.fromLTWH(
      horizontalPadding,
      verticalPadding,
      size.width - 2 * horizontalPadding,
      size.height - 2 * verticalPadding,
    );
    
    paint.color = Colors.transparent;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;  // This widget does not need to repaint by default
  }
}
