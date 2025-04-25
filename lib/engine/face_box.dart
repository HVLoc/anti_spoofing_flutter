class FaceBox {
  final int left;
  final int top;
  final int right;
  final int bottom;
  double confidence;

  FaceBox({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.confidence,
  });

  factory FaceBox.fromJson(Map<String, dynamic> json) {
    return FaceBox(
      left: json['left'],
      top: json['top'],
      right: json['right'],
      bottom: json['bottom'],
      confidence: json['confidence']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
      'confidence': confidence,
    };
  }
}
