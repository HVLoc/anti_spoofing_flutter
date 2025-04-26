#include "definition.h"
#include "detection/face_detector.h"
#include "img_process.h"
#include <vector>
#include <cstdint>
#include <cstring>
#include <opencv2/core/mat.hpp>

extern "C" {

// Khởi tạo detector, trả về con trỏ
doubleptr_t fd_allocate() {
    return reinterpret_cast<doubleptr_t>(new FaceDetector());
}

// Giải phóng detector
void fd_deallocate(Object handle) {
    if (handle != 0) {
        delete reinterpret_cast<FaceDetector *>(handle);
    }
}

// Load model từ đường dẫn file
int fd_load_model(Object handle, const char* param_path, const char* bin_path) {
    FaceDetector *detector = reinterpret_cast<FaceDetector *>(handle);
    return detector->LoadModel(param_path, bin_path);
}

// Detect từ buffer YUV
FaceBoxArray fd_detect_yuv(Object handle, const uint8_t* yuv, int width, int height, int orientation) {
    FaceDetector* detector = reinterpret_cast<FaceDetector*>(handle);

    // Chuyển đổi dữ liệu YUV sang BGR
    cv::Mat bgr;
    Yuv420sp2bgr(yuv, width, height, orientation, bgr);

    // Phát hiện khuôn mặt
    std::vector<FaceBox> boxes;
    detector->Detect(bgr, boxes);

    // Cấp phát bộ nhớ cho FaceBoxArray
    FaceBoxArray faceArray;
    faceArray.length = boxes.size();
    faceArray.faces = (FaceBox*)malloc(faceArray.length * sizeof(FaceBox));
    if (faceArray.faces == nullptr) {
        faceArray.length = 0;
        return faceArray;
    }

    // Sao chép các FaceBox vào mảng đã cấp phát
    for (int i = 0; i < faceArray.length; ++i) {
        faceArray.faces[i].x1 = boxes[i].x1;
        faceArray.faces[i].y1 = boxes[i].y1;
        faceArray.faces[i].x2 = boxes[i].x2;
        faceArray.faces[i].y2 = boxes[i].y2;
        faceArray.faces[i].confidence = 0.0f;  // Hoặc tính toán điểm của khuôn mặt nếu cần
    }

    return faceArray;
}

// Hàm giải phóng bộ nhớ cho FaceBoxArray
void fd_release_faces(FaceBoxArray faceArray) {
    if (faceArray.faces != nullptr) {
        free(faceArray.faces);
        faceArray.faces = nullptr;
    }
}

} // extern "C"
