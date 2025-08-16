import 'dart:io';
import '../services/s3_service.dart';
import '../config/aws_config.dart';

class S3TestHelper {
  // Test AWS configuration
  static void testAwsConfig() {
    print('🔧 Testing AWS Configuration...');
    print('Access Key: ${AwsConfig.accessKey.substring(0, 8)}...');
    print('Secret Key: ${AwsConfig.secretKey.substring(0, 8)}...');
    print('Bucket: ${AwsConfig.bucketName}');
    print('Region: ${AwsConfig.region}');
    print('Configured: ${AwsConfig.isConfigured}');
    print('S3 URL Format: ${AwsConfig.s3UrlFormat}');
    print('');
  }
  
  // Test S3 service
  static void testS3Service() {
    print('🚀 Testing S3 Service...');
    
    final isValid = S3Service.validateCredentials();
    print('Credentials Valid: $isValid');
    
    final config = S3Service.getAwsConfig();
    print('Config Summary: $config');
    print('');
  }
  
  // Test S3 connection
  static Future<void> testS3Connection() async {
    print('🔌 Testing S3 Connection...');
    
    try {
      final isConnected = await S3Service.testS3Connection();
      print('Connection Test: ${isConnected ? "✅ SUCCESS" : "❌ FAILED"}');
    } catch (e) {
      print('Connection Test: ❌ ERROR - $e');
    }
    print('');
  }
  
  // Test file validation
  static void testFileValidation() {
    print('📁 Testing File Validation...');
    
    // Test with mock file path
    final mockFile = File('/path/to/test.mp4');
    
    final isValid = S3Service.isValidVideoFile(mockFile);
    print('File Validation: $isValid');
    
    final size = S3Service.getVideoFileSizeInMB(mockFile);
    print('File Size (MB): $size');
    
    final humanReadable = S3Service.getFileSizeHumanReadable(mockFile);
    print('File Size (Human): $humanReadable');
    print('');
  }
  
  // Test filename generation
  static void testFilenameGeneration() {
    print('📝 Testing Filename Generation...');
    
    final fileName = S3Service.generateVideoFileName(
      lessonId: 'lesson_123',
      userId: 'user_456',
    );
    
    print('Generated Filename: $fileName');
    print('');
  }
  
  // Run all tests
  static Future<void> runAllTests() async {
    print('🧪 Running S3 Tests...\n');
    
    testAwsConfig();
    testS3Service();
    await testS3Connection();
    testFileValidation();
    testFilenameGeneration();
    
    print('✅ All tests completed!');
  }
  
  // Test with actual file (if exists)
  static Future<void> testWithActualFile(String filePath) async {
    print('🎬 Testing with Actual File...');
    
    final file = File(filePath);
    if (!await file.exists()) {
      print('❌ File not found: $filePath');
      return;
    }
    
    print('File exists: ${await file.exists()}');
    print('File size: ${S3Service.getFileSizeHumanReadable(file)}');
    print('Valid video: ${S3Service.isValidVideoFile(file)}');
    
    // Test upload (this will actually try to upload)
    try {
      print('Attempting upload test...');
      final s3Url = await S3Service.uploadVideoToS3(
        videoFile: file,
        lessonId: 'test_lesson',
        userId: 'test_user',
      );
      
      if (s3Url != null) {
        print('✅ Upload test successful!');
        print('S3 URL: $s3Url');
      } else {
        print('❌ Upload test failed - no URL returned');
      }
    } catch (e) {
      print('❌ Upload test failed with error: $e');
    }
    print('');
  }
}
