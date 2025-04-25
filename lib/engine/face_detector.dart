import 'package:flutter/services.dart';

import 'engine.src.dart';

class FaceDetector extends Component {
  late double nativeHandler;

  FaceDetector() {
    nativeHandler = createInstance();
  }

  @override
  double createInstance() {
    return allocate();
  }

  Future<int> loadModel(AssetBundle assetBundle) async {
    // Implement native load model logic
    return nativeLoadModel(assetBundle);
  }

  Future<List<FaceBox>> detectBitmap(Uint8List bitmapData) async {
    // Validate bitmap data configuration (for simplicity, we assume ARGB_8888)
    // Bitmap.Config.ARGB_8888 equivalent check in Dart
    return nativeDetectBitmap(bitmapData);
  }

  Future<List<FaceBox>> detectYuv({
    required Uint8List yuv,
    required int previewWidth,
    required int previewHeight,
    required int orientation,
  }) async {
    if (previewWidth * previewHeight * 3 ~/ 2 != yuv.length) {
      throw ArgumentError("Invalid YUV data");
    }

    return nativeDetectYuv(
      yuv,
      previewWidth,
      previewHeight,
      orientation,
    );
  }

  @override
  void destroy() {
    deallocate();
  }

  ////////////////////// Native //////////////////////
  double allocate() {
    // TODO: Implement native allocation
    return 0;
  }

  void deallocate() {
    // TODO: Implement native deallocation
  }

  Future<int> nativeLoadModel(AssetBundle assetBundle) async {
    // TODO: Implement native load model
    return 0;
  }

  Future<List<FaceBox>> nativeDetectBitmap(Uint8List bitmapData) async {
    // TODO: Implement native detect bitmap logic
    return [];
  }

  Future<List<FaceBox>> nativeDetectYuv(
    Uint8List yuv,
    int previewWidth,
    int previewHeight,
    int orientation,
  ) async {
    // TODO: Implement native detect YUV logic
    return [];
  }
}

