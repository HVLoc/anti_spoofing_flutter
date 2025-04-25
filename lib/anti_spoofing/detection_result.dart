import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../engine/engine.src.dart';

class DetectionResult extends ChangeNotifier {
  int _left = 0;
  int _top = 0;
  int _right = 0;
  int _bottom = 0;
  double _confidence = 0.0;
  bool _hasFace = false;

  int time = 0;
  double threshold = 0.0;

  DetectionResult();

  DetectionResult.fromFaceBox(FaceBox faceBox, this.time, this._hasFace) {
    _left = faceBox.left;
    _top = faceBox.top;
    _right = faceBox.right;
    _bottom = faceBox.bottom;
    _confidence = faceBox.confidence;
  }

  int get left => _left;
  set left(int value) {
    _left = value;
    notifyListeners();
  }

  int get top => _top;
  set top(int value) {
    _top = value;
    notifyListeners();
  }

  int get right => _right;
  set right(int value) {
    _right = value;
    notifyListeners();
  }

  int get bottom => _bottom;
  set bottom(int value) {
    _bottom = value;
    notifyListeners();
  }

  double get confidence => _confidence;
  set confidence(double value) {
    _confidence = value;
    notifyListeners();
  }

  bool get hasFace => _hasFace;
  set hasFace(bool value) {
    _hasFace = value;
    notifyListeners();
  }

  Rect get rect => Rect.fromLTRB(
        _left.toDouble(),
        _top.toDouble(),
        _right.toDouble(),
        _bottom.toDouble(),
      );

  DetectionResult updateLocation(Rect rect) {
    left = rect.left.toInt();
    top = rect.top.toInt();
    right = rect.right.toInt();
    bottom = rect.bottom.toInt();
    return this;
  }
}
