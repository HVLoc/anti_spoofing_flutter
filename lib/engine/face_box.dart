import 'dart:ffi' as ffi;

base class FaceBox extends ffi.Struct {
  @ffi.Int32()
  external int left;

  @ffi.Int32()
  external final int top;

  @ffi.Int32()
  external final int right;

  @ffi.Int32()
  external final int bottom;

  @ffi.Float()
  external double confidence;

  // FaceBox({
  //   required this.left,
  //   required this.top,
  //   required this.right,
  //   required this.bottom,
  //   required this.confidence,
  // });
  //
  // factory FaceBox.fromJson(Map<String, dynamic> json) {
  //   return FaceBox(
  //     left: json['left'],
  //     top: json['top'],
  //     right: json['right'],
  //     bottom: json['bottom'],
  //     confidence: json['confidence']?.toDouble() ?? 0.0,
  //   );
  // }
  //
  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
        'confidence': confidence,
      };

  @override
  String toString() => 'FaceBox($left, $top, $right, $bottom, $confidence)';
}

base class FaceBoxArray extends ffi.Struct {
  external ffi.Pointer<FaceBox> faces;

  @ffi.Int32()
  external int length;
}
