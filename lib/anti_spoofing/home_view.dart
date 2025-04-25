import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:anti_spoofing_app/anti_spoofing/detection_result.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../engine/engine.src.dart';


void main() => runApp(const MaterialApp(home: FaceDetectionDemo()));

class FaceDetectionDemo extends StatefulWidget {
  const FaceDetectionDemo({super.key});

  @override
  State<FaceDetectionDemo> createState() => _FaceDetectionDemoState();
}

class _FaceDetectionDemoState extends State<FaceDetectionDemo> {
  CameraController? controller;
  DetectionResult? lastResult;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(
      front,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller!.initialize();

    controller!.startImageStream((CameraImage image) async {
      if (isDetecting) return;
      isDetecting = true;

      try {
        final bytes = _convertYUV420toBytes(image);
        final result = await Live.detect(
        yuv:   bytes,
          previewWidth: image.width,
          previewHeight: image.height,
          orientation: 0,
          // faceBox: 
        );

        lastResult = DetectionResult.fromFaceBox(
          FaceBox(
            left: result.left,
            top: result.top,
            right: result.right,
            bottom: result.bottom,
            confidence: result.confidence,
          ),
          DateTime.now().millisecondsSinceEpoch,
          true,
        );

        if (mounted) {
          setState(() {
            lastResult = result;
          });
        }
      } catch (e) {
        debugPrint('Detection error: $e');
      }

      isDetecting = false;
    });

    setState(() {});
  }

  Uint8List _convertYUV420toBytes(CameraImage image) {
    final y = image.planes[0].bytes;
    final u = image.planes[1].bytes;
    final v = image.planes[2].bytes;

    return Uint8List(y.length + u.length + v.length)
      ..setRange(0, y.length, y)
      ..setRange(y.length, y.length + u.length, u)
      ..setRange(y.length + u.length, y.length + u.length + v.length, v);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          if (lastResult?.hasFace == true)
            Positioned.fill(
              child: CustomPaint(
                painter: FacePainter(lastResult!),
              ),
            ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final DetectionResult result;

  FacePainter(this.result);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = result.rect;
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(rect, paint);

    final textSpan = TextSpan(
      text: 'Conf: ${result.confidence.toStringAsFixed(2)}',
      style: const TextStyle(color: Colors.greenAccent, fontSize: 16),
    );

    final tp = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );

    tp.layout();
    tp.paint(canvas, rect.topLeft - const Offset(0, 20));
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) => true;
}
