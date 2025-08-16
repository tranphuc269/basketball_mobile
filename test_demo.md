# Demo Test Basketball Learning App

## Cách test ứng dụng

### 1. Chạy ứng dụng
```bash
flutter run
```

### 2. Test các tính năng

#### Màn hình chính (Home Screen)
- ✅ Hiển thị logo bóng rổ
- ✅ Nút "Bắt đầu học" 
- ✅ 3 feature icons (Video HD, Giáo viên chuyên nghiệp, Theo dõi tiến độ)

#### Danh sách bài học (Lesson List Screen)
- ✅ Hiển thị 5 bài học mẫu
- ✅ Thanh tìm kiếm
- ✅ Filter theo độ khó (Tất cả, Cơ bản, Trung cấp)
- ✅ Mỗi bài học có thumbnail, title, description, teacher, duration

#### Chi tiết bài học (Lesson Detail Screen)
- ✅ Video player với play/pause
- ✅ Thông tin bài học đầy đủ
- ✅ Tags và mô tả
- ✅ Nút "Vào học và quay video"

#### Màn hình thực hành (Practice Screen)
- ✅ Camera preview
- ✅ Nút quay video (đỏ)
- ✅ Nút dừng quay
- ✅ Xem lại video đã quay
- ✅ Nút upload lên S3
- ✅ Progress bar khi upload

### 3. Test luồng hoàn chỉnh

1. **Khởi động app** → Home Screen
2. **Nhấn "Bắt đầu học"** → Lesson List Screen
3. **Chọn bài học** → Lesson Detail Screen
4. **Xem video** → Play/Pause video
5. **Nhấn "Vào học và quay video"** → Practice Screen
6. **Quay video** → Start/Stop recording
7. **Upload video** → S3 upload (mock)

### 4. Test tìm kiếm và lọc

- **Tìm kiếm**: Gõ "cơ bản" → hiển thị bài học cơ bản
- **Lọc độ khó**: Chọn "Cơ bản" → chỉ hiển thị bài học cơ bản
- **Xóa filter**: Chọn "Tất cả" → hiển thị tất cả bài học

### 5. Test camera

- **Quyền camera**: App sẽ yêu cầu quyền truy cập camera
- **Switch camera**: Nếu có 2 camera (front/back)
- **Quay video**: Nút đỏ để bắt đầu, nút stop để dừng
- **Xem lại**: Hiển thị video đã quay

### 6. Test upload S3

- **Mock upload**: Hiển thị progress bar
- **Success message**: "Video đã được upload lên S3 thành công!"
- **Error handling**: Nếu không có video để upload

## Lưu ý quan trọng

### 1. S3 Upload Logic
**Bạn cần implement logic upload video lên S3 trong file:**
```
lib/services/s3_service.dart
```

**Vị trí cần implement:**
```dart
static Future<String?> uploadVideoToS3({
  required File videoFile,
  required String lessonId,
  required String userId,
}) async {
  // TODO: Fill in your S3 upload logic here
  // 1. Configure AWS credentials
  // 2. Create S3 client  
  // 3. Upload video file
  // 4. Return the uploaded video URL
}
```

### 2. Quyền cần thiết

#### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần quyền truy cập camera để quay video thực hành</string>
<key>NSMicrophoneUsageDescription</key>
<string>Ứng dụng cần quyền truy cập microphone để ghi âm</string>
```

### 3. Dependencies đã cài đặt
- ✅ get: State management
- ✅ video_player: Phát video
- ✅ camera: Quay video
- ✅ permission_handler: Xử lý quyền
- ✅ path_provider: Quản lý đường dẫn
- ✅ http: API calls
- ✅ shared_preferences: Lưu trữ local

## Kết quả mong đợi

Ứng dụng sẽ hoạt động hoàn chỉnh với:
- ✅ UI đẹp và responsive
- ✅ Navigation mượt mà
- ✅ State management với GetX
- ✅ Camera hoạt động
- ✅ Video player hoạt động
- ✅ Mock data hiển thị đúng
- ✅ S3 upload mock (cần implement thật)

## Bước tiếp theo

1. **Test app** trên thiết bị thật
2. **Implement S3 upload logic** thật
3. **Thay thế mock data** bằng real API
4. **Thêm error handling** và validation
5. **Test trên nhiều thiết bị** khác nhau
