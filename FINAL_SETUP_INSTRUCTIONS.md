# 🎯 Hướng dẫn cài đặt cuối cùng - Basketball Learning App

## ✅ **Đã hoàn thành:**
- ✅ Ứng dụng Flutter hoàn chỉnh với GetX state management
- ✅ 4 màn hình chính: Home → Lesson List → Lesson Detail → Practice
- ✅ Camera functionality để quay video
- ✅ Video player để xem bài học
- ✅ S3 upload service đã được implement
- ✅ AWS dependencies đã được cài đặt
- ✅ Tất cả lỗi đã được sửa

## 🔧 **Bước cuối cùng - Cấu hình AWS S3:**

### 1. **Cập nhật file `lib/config/aws_config.dart`:**

```dart
class AwsConfig {
  // Thay thế bằng credentials thật của bạn
  static const String accessKey = 'AKIAIOSFODNN7EXAMPLE123';
  static const String secretKey = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY123';
  static const String bucketName = 'basketball-learning-videos';
  static const String region = 'ap-southeast-1'; // Khuyến nghị cho Việt Nam
}
```

### 2. **Lấy AWS Credentials:**
- Đăng nhập AWS Console
- Tạo IAM User với S3 permissions
- Tạo Access Key và Secret Key
- Tạo S3 bucket

### 3. **Cấu hình S3 Bucket:**
- Bucket name: `basketball-learning-videos` (hoặc tên bạn muốn)
- Region: `ap-southeast-1` (Singapore - gần Việt Nam nhất)
- CORS: Cho phép upload từ mobile app
- Bucket Policy: Cho phép public read

## 🚀 **Cách chạy ứng dụng:**

### 1. **Cài đặt dependencies:**
```bash
flutter pub get
```

### 2. **Chạy app:**
```bash
flutter run
```

### 3. **Test flow:**
1. **Home Screen** → Click "Bắt đầu học"
2. **Lesson List** → Chọn bài học
3. **Lesson Detail** → Xem video và click "Bắt đầu thực hành"
4. **Practice Screen** → Quay video và upload lên S3

## 📱 **Test S3 Upload:**

### 1. **Kiểm tra cấu hình:**
```dart
// Trong app, gọi:
final isValid = S3Service.validateCredentials();
print('AWS Credentials valid: $isValid');
```

### 2. **Test upload:**
- Quay video ngắn (5-10 giây)
- Click "Upload Video"
- Kiểm tra console logs
- Kiểm tra S3 bucket

## 🔍 **Kiểm tra kết quả:**

### ✅ **Thành công:**
- Console hiển thị: "S3 upload successful!"
- S3 URL được trả về
- File xuất hiện trong S3 bucket

### ❌ **Lỗi thường gặp:**
- **Access Denied**: Kiểm tra IAM permissions
- **Invalid Credentials**: Kiểm tra Access Key/Secret Key
- **Bucket Not Found**: Kiểm tra tên bucket và region

## 📚 **Files quan trọng:**

- **`lib/config/aws_config.dart`** - Cấu hình AWS credentials
- **`lib/services/s3_service.dart`** - Logic upload S3
- **`lib/utils/s3_test_helper.dart`** - Helper để test S3
- **`AWS_SETUP_GUIDE.md`** - Hướng dẫn chi tiết AWS setup

## 🎉 **Kết quả cuối cùng:**

Sau khi cấu hình xong:
- ✅ App có thể quay video
- ✅ Video được upload lên S3 thành công
- ✅ S3 URL được trả về
- ✅ App hoạt động hoàn chỉnh

## 🚨 **Lưu ý bảo mật:**

- **KHÔNG commit** AWS credentials lên git
- **KHÔNG chia sẻ** credentials với người khác
- Sử dụng IAM User với quyền tối thiểu cần thiết
- Rotate credentials định kỳ

---

## 🎯 **Bước tiếp theo:**

1. **Cập nhật AWS credentials** trong `aws_config.dart`
2. **Chạy app** và test flow hoàn chỉnh
3. **Quay video test** và upload lên S3
4. **Kiểm tra S3 bucket** có file mới không

**App đã sẵn sàng để sử dụng!** 🚀

Nếu cần hỗ trợ thêm, hãy kiểm tra:
- Console logs trong app
- AWS CloudTrail logs
- S3 bucket permissions
- IAM user policies
