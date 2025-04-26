import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import '../engine/engine.src.dart';


/// Tạo lớp wrapper cho thư viện C++
class FaceDetectorBindings {
  late ffi.DynamicLibrary _lib;

  late final _fdAllocate = _lib
      .lookupFunction<ffi.IntPtr Function(), int Function()>('fd_allocate');

  late final _fdDeallocate = _lib.lookupFunction<
      ffi.Void Function(ffi.IntPtr),
      void Function(int)>('fd_deallocate');

  late final _fdLoadModel = _lib.lookupFunction<
      ffi.Int32 Function(ffi.IntPtr, ffi.Pointer<Utf8>),
      int Function(int, ffi.Pointer<Utf8>)>('fd_load_model');

  late final _fdDetectYUV = _lib.lookupFunction<
      ffi.Int32 Function(
          ffi.IntPtr, // handler
          ffi.Pointer<ffi.Uint8>, // yuv buffer
          ffi.Int32, // width
          ffi.Int32, // height
          ffi.Int32, // orientation
          ffi.Pointer<FaceBox>, // output
          ffi.Int32 // max boxes
          ),
      int Function(
          int,
          ffi.Pointer<ffi.Uint8>,
          int,
          int,
          int,
          ffi.Pointer<FaceBox>,
          int)>('fd_detect_yuv');

  FaceDetectorBindings({String libName = 'libfacedetector.so'}) {
    _lib = Platform.isAndroid
        ? ffi.DynamicLibrary.open('libfacedetector.so')
        : throw UnsupportedError('Only Android supported');
  }

  int allocate() => _fdAllocate();

  void deallocate(int handler) => _fdDeallocate(handler);

  int loadModel(int handler, String modelDir) {
    final pathPtr = modelDir.toNativeUtf8();
    final result = _fdLoadModel(handler, pathPtr);
    calloc.free(pathPtr);
    return result;
  }

  List<FaceBox> detectYUV(
      int handler,
      Uint8List yuv,
      int width,
      int height,
      int orientation,
      int maxFaces,
      ) {
    final ptr = calloc<ffi.Uint8>(yuv.length);
    final output = calloc<FaceBox>(maxFaces);

    ptr.asTypedList(yuv.length).setAll(0, yuv);

    final count = _fdDetectYUV(
        handler, ptr, width, height, orientation, output, maxFaces);

    final results = List<FaceBox>.generate(count, (i) => output[i]);

    calloc.free(ptr);
    calloc.free(output);

    return results;
  }
}
