import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../engine/engine.src.dart';

import 'detection_result.dart';

class EngineWrapper {
  final FaceDetector faceDetector = FaceDetector();
  final Live live = Live();

  EngineWrapper();

  Future<bool> init() async {
    final retFace = await faceDetector.loadModel();
    if (retFace == 0) {
      final retLive = await live.loadModel();
      return retLive == 0;
    }
    return false;
  }

  void destroy() {
    faceDetector.destroy();
    live.destroy();
  }

  Future<DetectionResult> detect({
    required Uint8List yuv,
    required int width,
    required int height,
    required int orientation,
  }) async {
    final boxes = await faceDetector.detectYuv(
      yuv: yuv,
      previewWidth: width,
      previewHeight: height,
      orientation: orientation,
    );

    if (boxes.isNotEmpty) {
      final begin = DateTime.now().millisecondsSinceEpoch;
      final box = boxes.first;

      final conf = await live.detect(
        yuv: yuv,
        previewWidth: width,
        previewHeight: height,
        orientation: orientation,
        faceBox: box,
      );

      box.confidence = conf;

      final end = DateTime.now().millisecondsSinceEpoch;

      return DetectionResult.fromFaceBox(box, end - begin, true);
    }

    return DetectionResult();
  }
}
