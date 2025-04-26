import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:anti_spoofing_app/anti_spoofing/detection_result.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../engine/engine.src.dart';
import '../utils/utils.src.dart';
import 'anti_spoofing.src.dart';

void main() => runApp(const MaterialApp(home: FaceDetectionDemo()));

class FaceDetectionDemo extends StatefulWidget {
  const FaceDetectionDemo({super.key});

  @override
  State<FaceDetectionDemo> createState() => _FaceDetectionDemoState();
}

class _FaceDetectionDemoState extends State<FaceDetectionDemo>
    with WidgetsBindingObserver {
  CameraController? cameraController;
  DetectionResult? lastResult;
  double threshold = 0.915;
  bool isDetecting = false;
  int previewWidth = 640;
  int previewHeight = 480;

  late EngineWrapper engineWrapper;
  bool enginePrepared = false;

  int frameOrientation = 7;
  double factorX = 0;
  double factorY = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    WidgetsBinding.instance.addObserver(this);
    if (state == AppLifecycleState.resumed) {
      //TODOL check lại
      // engineWrapper = EngineWrapper(assetBundle:  assets);
      enginePrepared = await engineWrapper.init();

      // if (!enginePrepared) {
      //     Toast.makeText(this, "Engine init failed.", Toast.LENGTH_LONG).show()
      // }
    } else if (state == AppLifecycleState.paused) {
      cameraController?.stopImageStream();
      cameraController?.dispose();
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(
      front,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await initCameraController();

    cameraController!.startImageStream((CameraImage image) async {
      if (isDetecting) return;
      isDetecting = true;

      try {
        final bytes = _convertYUV420toBytes(image);
        final result = await engineWrapper.detect(
          yuv: bytes,
          width: image.width,
          height: image.height,
          orientation: frameOrientation,
        );

        final rect = calculateBoxLocationOnScreen(
            result.left, result.top, result.right, result.bottom);

        lastResult = result.updateLocation(rect);
        DetectionResult.fromFaceBox(
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
    cameraController?.dispose();
    cameraController = null;
    engineWrapper.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(cameraController!),
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

  Rect calculateBoxLocationOnScreen(
    int left,
    int top,
    int right,
    int bottom,
  ) {
    return Rect.fromLTRB(
      left * factorX,
      top * factorY,
      right * factorX,
      bottom * factorY,
    );
  }

  Future<void> initCameraController() async {
    PermissionStatus permissionStatus =
        await checkPermission([Permission.camera]);
    switch (permissionStatus) {
      case PermissionStatus.granted:
        {
          await cameraController?.initialize();
        }
        break;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        // ShowPopup.openAppSetting();
        break;
      default:
        return;
    }
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
