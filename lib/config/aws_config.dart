class AwsConfig {
  // AWS S3 Configuration
  // Replace these values with your actual AWS credentials
  
  // Your AWS Access Key ID
  static const String accessKey = 'YOUR_ACCESS_KEY_HERE';
  
  // Your AWS Secret Access Key
  static const String secretKey = 'YOUR_SECRET_KEY_HERE';
  
  // Your S3 Bucket name
  static const String bucketName = 'YOUR_BUCKET_NAME_HERE';
  
  // Your AWS Region (e.g., 'us-east-1', 'ap-southeast-1', 'eu-west-1')
  static const String region = 'YOUR_REGION_HERE';
  
  // S3 URL format
  static String get s3UrlFormat => 'https://$bucketName.s3.$region.amazonaws.com';
  
  // Validate if credentials are properly configured
  static bool get isConfigured {
    return accessKey != 'YOUR_ACCESS_KEY_HERE' &&
           secretKey != 'YOUR_SECRET_KEY_HERE' &&
           bucketName != 'YOUR_BUCKET_NAME_HERE' &&
           region != 'YOUR_REGION_HERE';
  }
  
  // Get configuration summary
  static Map<String, String> get configSummary {
    return {
      'Access Key': '${accessKey.substring(0, 8)}...',
      'Secret Key': '${secretKey.substring(0, 8)}...',
      'Bucket': bucketName,
      'Region': region,
      'Configured': isConfigured.toString(),
    };
  }
  
  // Common AWS regions for reference
  static const Map<String, String> commonRegions = {
    'us-east-1': 'US East (N. Virginia)',
    'us-west-2': 'US West (Oregon)',
    'eu-west-1': 'Europe (Ireland)',
    'ap-southeast-1': 'Asia Pacific (Singapore)',
    'ap-northeast-1': 'Asia Pacific (Tokyo)',
    'sa-east-1': 'South America (São Paulo)',
  };
}
