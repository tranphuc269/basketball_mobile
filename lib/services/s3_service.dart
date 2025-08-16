import 'dart:io';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import '../config/aws_config.dart';

class S3Service {
  // Main upload function using aws_s3_upload package
  static Future<String?> uploadVideoToS3({
    required File videoFile,
    required String lessonId,
    required String userId,
  }) async {
    try {
      print('Starting S3 upload...');
      print('Lesson ID: $lessonId');
      print('User ID: $userId');
      print('Video file path: ${videoFile.path}');
      print('File size: ${getVideoFileSizeInMB(videoFile).toStringAsFixed(2)} MB');
      
      // Check if credentials are configured
      if (!AwsConfig.isConfigured) {
        throw Exception('AWS credentials not configured. Please update lib/config/aws_config.dart');
      }
      
      // Validate file
      if (!isValidVideoFile(videoFile)) {
        throw Exception('Invalid video file format');
      }
      
      // Generate unique filename
      final fileName = generateVideoFileName(
        lessonId: lessonId,
        userId: userId,
      );
      
      // Generate S3 key (path in bucket)
      final s3Key = 'videos/$userId/$lessonId/$fileName';
      
      print('S3 Key: $s3Key');
      print('Bucket: ${AwsConfig.bucketName}');
      print('Region: ${AwsConfig.region}');
      
      // Upload using aws_s3_upload package
      final s3Url = await AwsS3.uploadFile(
        accessKey: AwsConfig.accessKey,
        secretKey: AwsConfig.secretKey,
        file: videoFile,
        bucket: AwsConfig.bucketName,
        region: AwsConfig.region,
        key: s3Key,
        contentType: 'video/mp4',
        metadata: {
          'lessonId': lessonId,
          'userId': userId,
          'uploadDate': DateTime.now().toIso8601String(),
          'originalFileName': videoFile.path.split('/').last,
          'fileSize': (await videoFile.length()).toString(),
        },
      );
      
      if (s3Url != null) {
        print('S3 upload successful!');
        print('S3 URL: $s3Url');
        return s3Url;
      } else {
        throw Exception('Upload failed - no URL returned');
      }
      
    } catch (e) {
      print('Error uploading video to S3: $e');
      rethrow;
    }
  }
  
  // Helper method to generate unique filename
  static String generateVideoFileName({
    required String lessonId,
    required String userId,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (1000 + (timestamp % 9000)).toString(); // Random 4-digit number
    return '${userId}_${lessonId}_${timestamp}_$random.mp4';
  }
  
  // Method to check if video file is valid
  static bool isValidVideoFile(File file) {
    final validExtensions = ['.mp4', '.mov', '.avi', '.mkv'];
    final extension = file.path.split('.').last.toLowerCase();
    return validExtensions.contains('.$extension');
  }
  
  // Method to get video file size in MB
  static double getVideoFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }
  
  // Method to get file size in human readable format
  static String getFileSizeHumanReadable(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  // Method to validate AWS credentials
  static bool validateCredentials() {
    return AwsConfig.isConfigured;
  }
  
  // Method to get AWS configuration info
  static Map<String, String> getAwsConfig() {
    return AwsConfig.configSummary;
  }
  
  // Method to test S3 connection (simple validation)
  static Future<bool> testS3Connection() async {
    try {
      // Simple test by checking if credentials are configured
      if (!AwsConfig.isConfigured) {
        print('AWS credentials not configured');
        return false;
      }
      
      print('AWS credentials configured successfully');
      print('Bucket: ${AwsConfig.bucketName}');
      print('Region: ${AwsConfig.region}');
      return true;
    } catch (e) {
      print('S3 connection test failed: $e');
      return false;
    }
  }
}
