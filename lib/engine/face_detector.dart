import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'engine.src.dart';

// Native function types (C side)
typedef _AllocateNativeC = ffi.Double Function();
typedef _DeallocateNativeC = ffi.Void Function(ffi.IntPtr);
typedef _LoadModelNativeC = ffi.Int32 Function(ffi.Dart_CObject);
typedef _DetectYuvNativeC = ffi.Pointer<FaceBoxArray> Function(
    ffi.Dart_CObject, ffi.Pointer<ffi.Uint8>, ffi.Int32, ffi.Int32, ffi.Int32);

// Dart function types (Dart side)
typedef _AllocateDart = double Function();
typedef _DeallocateDart = void Function(int);
typedef _LoadModelDart = int Function(ffi.Dart_CObject);
typedef _DetectYuvDart = ffi.Pointer<FaceBoxArray> Function(
    ffi.Dart_CObject, ffi.Pointer<ffi.Uint8>, int, int, int);

// Đối tượng FaceDetector
class FaceDetector extends Component {
  final _allocate = Component.lib
      .lookupFunction<_AllocateNativeC, _AllocateDart>('fd_allocate');

  final _deallocate = Component.lib
      .lookupFunction<_DeallocateNativeC, _DeallocateDart>('fd_deallocate');

  final _loadModel = Component.lib
      .lookupFunction<_LoadModelNativeC, _LoadModelDart>('fd_load_model');

  final _detectYuv = Component.lib
      .lookupFunction<_DetectYuvNativeC, _DetectYuvDart>('fd_detect_yuv');

  late final double _nativePtr;

  FaceDetector() {
    _nativePtr = _allocate();
  }

  // Load model từ native
  int loadModel() {
    return _loadModel(_nativePtr);
  }

  // Detect khuôn mặt từ dữ liệu YUV
  List<FaceBox> detectYuv(Uint8List yuv, int width, int height, int orientation) {
    final ptr = malloc<ffi.Uint8>(yuv.length);
    final nativeList = ptr.asTypedList(yuv.length)..setAll(0, yuv);

    // Gọi native fd_detect_yuv
    final resultPtr = _detectYuv(_nativePtr, ptr, width, height, orientation);
    malloc.free(ptr);

    if (resultPtr == ffi.nullptr) return [];

    final result = resultPtr.ref;
    final boxes = <FaceBox>[];

    // Chuyển các FaceBox từ result.faces (C struct) sang Dart
    for (int i = 0; i < result.length; i++) {
      final face = result.faces.elementAt(i).ref;
      boxes.add(face);
    }

    return boxes;
  }

  // Giải phóng bộ nhớ
  @override
  void destroy() {
    _deallocate();
  }

  // Tạo instance
  @override
  double createInstance() {
    return allocate();
  }
}
