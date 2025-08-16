# 🚀 AWS S3 Setup Guide for Basketball Learning App

## 📋 Bước 1: Cấu hình AWS Credentials

### 1.1 Cập nhật file `lib/config/aws_config.dart`

Thay thế các giá trị placeholder bằng thông tin thật của bạn:

```dart
class AwsConfig {
  // Your AWS Access Key ID
  static const String accessKey = 'AKIAIOSFODNN7EXAMPLE'; // ← Thay bằng Access Key thật
  
  // Your AWS Secret Access Key  
  static const String secretKey = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'; // ← Thay bằng Secret Key thật
  
  // Your S3 Bucket name
  static const String bucketName = 'my-basketball-videos'; // ← Thay bằng tên bucket thật
  
  // Your AWS Region
  static const String region = 'us-east-1'; // ← Thay bằng region thật
}
```

### 1.2 Ví dụ cấu hình hoàn chỉnh:

```dart
class AwsConfig {
  static const String accessKey = 'AKIAIOSFODNN7EXAMPLE123';
  static const String secretKey = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY123';
  static const String bucketName = 'basketball-learning-videos';
  static const String region = 'ap-southeast-1';
}
```

## 🔑 Bước 2: Lấy AWS Credentials

### 2.1 Tạo IAM User (nếu chưa có):

1. **Đăng nhập AWS Console** → IAM → Users → Create User
2. **Tên user**: `basketball-app-uploader`
3. **Access type**: Programmatic access
4. **Permissions**: Attach policies

### 2.2 Tạo IAM Policy cho S3:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::YOUR-BUCKET-NAME",
                "arn:aws:s3:::YOUR-BUCKET-NAME/*"
            ]
        }
    ]
}
```

### 2.3 Lấy Access Key và Secret Key:

1. **Create Access Key** → Download CSV file
2. **Lưu ý**: Secret Key chỉ hiển thị 1 lần!

## 🪣 Bước 3: Tạo S3 Bucket

### 3.1 Tạo bucket mới:

1. **S3 Console** → Create bucket
2. **Bucket name**: `basketball-learning-videos` (hoặc tên bạn muốn)
3. **Region**: Chọn region gần nhất (ví dụ: `ap-southeast-1`)

### 3.2 Cấu hình bucket:

```json
// Bucket policy để cho phép upload
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}
```

### 3.3 CORS Configuration:

```json
[
    {
        "AllowedHeaders": ["*"],
        "AllowedMethods": ["GET", "PUT", "POST"],
        "AllowedOrigins": ["*"],
        "ExposeHeaders": []
    }
]
```

## 🌍 Bước 4: Chọn AWS Region

### 4.1 Các region phổ biến:

| Region | Tên | Vị trí |
|--------|-----|---------|
| `us-east-1` | US East (N. Virginia) | Bắc Mỹ |
| `us-west-2` | US West (Oregon) | Bắc Mỹ |
| `eu-west-1` | Europe (Ireland) | Châu Âu |
| `ap-southeast-1` | Asia Pacific (Singapore) | Đông Nam Á |
| `ap-northeast-1` | Asia Pacific (Tokyo) | Đông Á |
| `sa-east-1` | South America (São Paulo) | Nam Mỹ |

### 4.2 Khuyến nghị:
- **Việt Nam**: Sử dụng `ap-southeast-1` (Singapore) - độ trễ thấp nhất
- **Châu Âu**: Sử dụng `eu-west-1` (Ireland)
- **Bắc Mỹ**: Sử dụng `us-east-1` (Virginia)

## ✅ Bước 5: Test cấu hình

### 5.1 Kiểm tra credentials:

```dart
// Trong app, gọi:
final isValid = S3Service.validateCredentials();
print('AWS Credentials valid: $isValid');

final config = S3Service.getAwsConfig();
print('AWS Config: $config');
```

### 5.2 Test connection:

```dart
final isConnected = await S3Service.testS3Connection();
print('S3 Connection: $isConnected');
```

## 🔒 Bước 6: Bảo mật

### 6.1 Không commit credentials:

```gitignore
# Thêm vào .gitignore
lib/config/aws_config.dart
```

### 6.2 Sử dụng environment variables (khuyến nghị):

```dart
// Thay vì hardcode, sử dụng:
import 'dart:io';

class AwsConfig {
  static String get accessKey => Platform.environment['AWS_ACCESS_KEY'] ?? 'YOUR_ACCESS_KEY';
  static String get secretKey => Platform.environment['AWS_SECRET_KEY'] ?? 'YOUR_SECRET_KEY';
  static String get bucketName => Platform.environment['AWS_BUCKET'] ?? 'YOUR_BUCKET';
  static String get region => Platform.environment['AWS_REGION'] ?? 'YOUR_REGION';
}
```

## 🚨 Troubleshooting

### Lỗi thường gặp:

1. **Access Denied**:
   - Kiểm tra IAM permissions
   - Kiểm tra bucket policy
   - Kiểm tra CORS configuration

2. **Invalid Credentials**:
   - Kiểm tra Access Key và Secret Key
   - Kiểm tra region có đúng không

3. **Bucket Not Found**:
   - Kiểm tra tên bucket
   - Kiểm tra region

4. **Network Error**:
   - Kiểm tra internet connection
   - Kiểm tra firewall settings

## 📱 Test trong App

### 1. Cập nhật credentials trong `aws_config.dart`
### 2. Chạy app: `flutter run`
### 3. Quay video và test upload
### 4. Kiểm tra console logs
### 5. Kiểm tra S3 bucket có file mới không

## 🎯 Kết quả mong đợi

Sau khi cấu hình đúng:
- ✅ Video được upload lên S3 thành công
- ✅ Console hiển thị: "S3 upload successful!"
- ✅ S3 URL được trả về
- ✅ File xuất hiện trong S3 bucket

## 📞 Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra AWS Console logs
2. Kiểm tra app console logs
3. Verify IAM permissions
4. Test S3 access từ AWS CLI

---

**Lưu ý quan trọng**: Không bao giờ chia sẻ AWS credentials với người khác hoặc commit lên git repository!
