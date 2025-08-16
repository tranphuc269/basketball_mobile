# Basketball Learning Mobile App

Ứng dụng học bóng rổ di động được xây dựng bằng Flutter và sử dụng GetX làm state management.

## Tính năng chính

- 🏀 **Trang chủ**: Giao diện đẹp với nút "Bắt đầu học"
- 📚 **Danh sách bài học**: Hiển thị các bài học từ giáo viên với tìm kiếm và lọc theo độ khó
- 🎥 **Xem video**: Xem video bài học với player tích hợp
- 📱 **Quay video thực hành**: Sử dụng camera để quay video thực hành
- ☁️ **Upload lên S3**: Lưu video thực hành lên AWS S3 (cần implement logic)

## Cấu trúc dự án

```
lib/
├── controllers/          # GetX Controllers
│   ├── lesson_controller.dart
│   └── camera_controller.dart
├── models/              # Data Models
│   ├── lesson.dart
│   └── user_progress.dart
├── services/            # Business Logic Services
│   ├── lesson_service.dart
│   └── s3_service.dart
├── views/               # UI Screens
│   ├── home_screen.dart
│   ├── lesson_list_screen.dart
│   ├── lesson_detail_screen.dart
│   └── practice_screen.dart
├── utils/               # Utility Functions
└── main.dart            # App Entry Point
```

## Cài đặt và chạy

### 1. Cài đặt dependencies

```bash
flutter pub get
```

### 2. Cấu hình quyền

#### Android
Thêm vào `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### iOS
Thêm vào `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần quyền truy cập camera để quay video thực hành</string>
<key>NSMicrophoneUsageDescription</key>
<string>Ứng dụng cần quyền truy cập microphone để ghi âm</string>
```

### 3. Chạy ứng dụng

```bash
flutter run
```

## Cách sử dụng

### 1. Khởi động ứng dụng
- Màn hình chính hiển thị logo và nút "Bắt đầu học"
- Nhấn nút để vào danh sách bài học

### 2. Xem danh sách bài học
- Danh sách các bài học từ giáo viên
- Tìm kiếm bài học theo từ khóa
- Lọc theo độ khó (Cơ bản, Trung cấp, Nâng cao)

### 3. Xem chi tiết bài học
- Xem video bài học
- Đọc mô tả và thông tin giáo viên
- Nhấn nút "Vào học và quay video"

### 4. Thực hành và quay video
- Sử dụng camera để quay video thực hành
- Xem lại video đã quay
- Upload video lên S3 (cần implement logic)

## Implement S3 Upload Logic

**Quan trọng**: Bạn cần implement logic upload video lên S3 trong file `lib/services/s3_service.dart`.

### Vị trí cần implement:

```dart
// Trong file: lib/services/s3_service.dart
static Future<String?> uploadVideoToS3({
  required File videoFile,
  required String lessonId,
  required String userId,
}) async {
  try {
    // TODO: Fill in your S3 upload logic here
    // Example implementation:
    // 1. Configure AWS credentials
    // 2. Create S3 client
    // 3. Upload video file
    // 4. Return the uploaded video URL
    
    // Placeholder code - replace with actual implementation
    await Future.delayed(Duration(seconds: 2));
    String mockS3Url = 'https://your-s3-bucket.s3.amazonaws.com/videos/$userId/$lessonId/${DateTime.now().millisecondsSinceEpoch}.mp4';
    return mockS3Url;
    
  } catch (e) {
    print('Error uploading video to S3: $e');
    return null;
  }
}
```

### Các bước implement:

1. **Cài đặt AWS SDK**:
   ```yaml
   dependencies:
     aws_s3_upload: ^1.0.0  # hoặc package tương tự
   ```

2. **Cấu hình AWS credentials**:
   ```dart
   // Thêm AWS credentials
   final credentials = AwsCredentials(
     'YOUR_ACCESS_KEY',
     'YOUR_SECRET_KEY',
   );
   ```

3. **Tạo S3 client và upload**:
   ```dart
   final s3Client = S3Client(
     region: Region('YOUR_REGION'),
     credentials: credentials,
   );
   
   final result = await s3Client.putObject(
     PutObjectRequest(
       bucket: 'YOUR_BUCKET_NAME',
       key: 'videos/$userId/$lessonId/$fileName',
       body: videoFile.readAsBytesSync(),
       contentType: 'video/mp4',
     ),
   );
   ```

## Dependencies

- **get**: State management
- **video_player**: Phát video
- **camera**: Quay video
- **permission_handler**: Xử lý quyền
- **path_provider**: Quản lý đường dẫn file
- **http**: API calls
- **shared_preferences**: Lưu trữ local

## Tính năng nâng cao có thể thêm

- [ ] User authentication
- [ ] Progress tracking
- [ ] Video quality settings
- [ ] Offline mode
- [ ] Push notifications
- [ ] Social sharing
- [ ] Video compression
- [ ] Multiple language support

## Troubleshooting

### Camera không hoạt động
- Kiểm tra quyền camera trong settings
- Đảm bảo đã cấu hình đúng trong AndroidManifest.xml và Info.plist

### Video không phát được
- Kiểm tra URL video có hợp lệ không
- Đảm bảo format video được hỗ trợ (MP4, MOV, AVI)

### Upload S3 thất bại
- Kiểm tra AWS credentials
- Đảm bảo bucket S3 có quyền write
- Kiểm tra network connection

## Liên hệ

Nếu có vấn đề hoặc cần hỗ trợ, vui lòng tạo issue hoặc liên hệ trực tiếp.

---

**Lưu ý**: Đây là ứng dụng demo với mock data. Để sử dụng trong production, bạn cần:
1. Implement S3 upload logic
2. Thay thế mock data bằng real API
3. Thêm error handling và validation
4. Test trên nhiều thiết bị khác nhau
