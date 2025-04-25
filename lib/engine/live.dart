import 'dart:convert'; // For JSON parsing
import 'package:flutter/services.dart';

import 'engine.src.dart'; // For AssetBundle equivalent

class Live extends Component {
  late double nativeHandler;

  Live() {
    nativeHandler = createInstance();
  }

  @override
  double createInstance() {
    return allocate();
  }

  @override
  void destroy() {
    deallocate();
  }

  Future<int> loadModel(AssetBundle assetBundle) async {
    final configs = await parseConfig(assetBundle);

    if (configs.isEmpty) {
      print("$tag: parse model config failed");
      return -1;
    }

    return await nativeLoadModel(assetBundle, configs);
  }

  Future<double> detect({
    required Uint8List yuv,
    required int previewWidth,
    required int previewHeight,
    required int orientation,
    required FaceBox faceBox,
  }) async {
    if (previewWidth * previewHeight * 3 ~/ 2 != yuv.length) {
      throw ArgumentError("Invalid YUV data");
    }

    return await nativeDetectYuv(
      yuv,
      previewWidth,
      previewHeight,
      orientation,
      faceBox.left,
      faceBox.top,
      faceBox.right,
      faceBox.bottom,
    );
  }

  Future<List<ModelConfig>> parseConfig(AssetBundle assetBundle) async {
    final String jsonString = await assetBundle.loadString('assets/live/config.json');
    final List<dynamic> jsonArray = jsonDecode(jsonString);

    return jsonArray.map((config) {
      return ModelConfig(
        name: config['name'] ?? "",
        width: config['width'] ?? 0,
        height: config['height'] ?? 0,
        scale: (config['scale'] ?? 0.0).toDouble(),
        shiftX: (config['shift_x'] ?? 0.0).toDouble(),
        shiftY: (config['shift_y'] ?? 0.0).toDouble(),
        orgResize: config['org_resize'] ?? false,
      );
    }).toList();
  }

  ////////////////////// Native //////////////////////
  double allocate() {
    // TODO: Implement native allocation
    return 0;
  }

  void deallocate() {
    // TODO: Implement native deallocation
  }

  Future<int> nativeLoadModel(
    AssetBundle assetBundle,
    List<ModelConfig> configs,
  ) async {
    // TODO: Implement native load model logic
    return 0;
  }

  Future<double> nativeDetectYuv(
    Uint8List yuv,
    int previewWidth,
    int previewHeight,
    int orientation,
    int left,
    int top,
    int right,
    int bottom,
  ) async {
    // TODO: Implement native detect YUV logic
    return 0.0;
  }

  static const String tag = "Live";
}

