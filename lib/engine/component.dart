import 'dart:ffi' as ffi;
import 'dart:io'; // For platform-specific checks

abstract class Component {
  static bool libraryFound = false;

  static late ffi.DynamicLibrary lib;

  Component() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Load the native library. Replace "engine" with your library name
        lib =   ffi.DynamicLibrary.open("libengine.so");
        libraryFound = true;
      }
    } catch (e) {
      print(" Failed to load library - ${e.toString()}");
    }
  }

  // static final ffi.DynamicLibrary lib =  {
  //   if (Platform.isAndroid) {
  //     return ffi.DynamicLibrary.open("libengine.so");
  //   } else if (Platform.isIOS) {
  //     return ffi.DynamicLibrary.process();
  //   } else {
  //     throw UnsupportedError("Platform not supported");
  //   }
  // }();

  double createInstance(); // Abstract method
  
  void destroy(); // Abstract method
}
