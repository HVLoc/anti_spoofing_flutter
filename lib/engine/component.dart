import 'dart:ffi'; // For handling native libraries
import 'dart:io'; // For platform-specific checks

abstract class Component {
  static bool libraryFound = false;
  static const String tag = "Component";

  Component() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Load the native library. Replace "engine" with your library name
        DynamicLibrary.open("engine");
        libraryFound = true;
      }
    } catch (e) {
      print("$tag: Failed to load library - ${e.toString()}");
    }
  }

  double createInstance(); // Abstract method
  void destroy(); // Abstract method
}