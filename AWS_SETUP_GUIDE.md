# 🚀 AWS S3 Setup Guide for Basketball Learning App

## 📋 Cấu hình AWS Credentials

### 1.1 Cập nhật file `lib/config/aws_config.dart`

```dart
class AwsConfig {
  // Your AWS Access Key ID
  static const String accessKey = '';
  
  // Your AWS Secret Access Key  
  static const String secretKey = '';
  
  // Your S3 Bucket name
  static const String bucketName = 'my-basketball-videos';
  
  // Your AWS Region
  static const String region = 'us-east-1';
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