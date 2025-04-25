class ModelConfig {
  double scale;
  double shiftX;
  double shiftY;
  int height;
  int width;
  String name;
  bool orgResize;

  ModelConfig({
    this.scale = 0.0,
    this.shiftX = 0.0,
    this.shiftY = 0.0,
    this.height = 0,
    this.width = 0,
    this.name = "",
    this.orgResize = false,
  });

  // Optional: Add a factory constructor to parse from JSON if needed
  factory ModelConfig.fromJson(Map<String, dynamic> json) {
    return ModelConfig(
      scale: json['scale'] ?? 0.0,
      shiftX: json['shift_x'] ?? 0.0,
      shiftY: json['shift_y'] ?? 0.0,
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
      name: json['name'] ?? "",
      orgResize: json['org_resize'] ?? false,
    );
  }

  // Optional: Add a method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'scale': scale,
      'shift_x': shiftX,
      'shift_y': shiftY,
      'height': height,
      'width': width,
      'name': name,
      'org_resize': orgResize,
    };
  }
}
