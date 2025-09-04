import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenAIService {
  static const String _apiKeyKey = 'openai_api_key';
  static const String _modelKey = 'openai_model';
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  // Default model
  static const String defaultModel = 'gpt-4o';

  // Available models
  static const List<String> availableModels = [
    'gpt-4o',
    'gpt-4o-mini',
    'gpt-4-turbo',
    'gpt-4',
    'gpt-3.5-turbo',
  ];

  // Get API key from storage
  static String getApiKey() {
    return "";
  }

  // Save API key to storage
  static Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  // Get selected model from storage
  static Future<String> getSelectedModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_modelKey) ?? defaultModel;
  }

  // Save selected model to storage
  static Future<void> setSelectedModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelKey, model);
  }

  // Check if API key is configured
  static Future<bool> isApiKeyConfigured() async {
    final apiKey = getApiKey();
    return apiKey.isNotEmpty;
  }

  // Send message to OpenAI API
  static Future<String> sendMessage({
    required String message,
    required List<Map<String, String>> messageHistory,
    String? customModel,
  }) async {
    final apiKey = getApiKey();
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API key not configured');
    }

    final model = customModel ?? await getSelectedModel();

    // Prepare messages for API
    final List<Map<String, String>> apiMessages = [];

    // Add system message - Basketball Coach
    apiMessages.add({
      'role': 'system',
      'content':
          'Bạn là một huấn luyện viên bóng rổ chuyên nghiệp với hơn 15 năm kinh nghiệm. Bạn có kiến thức sâu rộng về:\n\n• Kỹ thuật cơ bản và nâng cao (dribbling, shooting, passing, defense)\n• Chiến thuật và chiến lược thi đấu\n• Luật bóng rổ FIBA và NBA\n• Phương pháp luyện tập hiệu quả\n• Phát triển thể lực và tâm lý cho cầu thủ\n• Phân tích trận đấu và video\n• Huấn luyện cho mọi lứa tuổi từ trẻ em đến người lớn\n\nHãy trả lời bằng tiếng Việt với phong cách của một huấn luyện viên chuyên nghiệp: nhiệt tình, khuyến khích, và luôn đưa ra lời khuyên thực tế có thể áp dụng ngay. Sử dụng thuật ngữ bóng rổ chính xác và đưa ra các bài tập cụ thể khi cần thiết.'
    });

    // Add message history (last 5 messages if in chat mode)
    if (messageHistory.isNotEmpty) {
      final recentHistory = messageHistory.length > 5
          ? messageHistory.sublist(messageHistory.length - 5)
          : messageHistory;

      for (final msg in recentHistory) {
        apiMessages.add({
          'role': msg['isUser'] == 'true' ? 'user' : 'assistant',
          'content': msg['text'] ?? '',
        });
      }
    }

    // Add current message
    apiMessages.add({
      'role': 'user',
      'content': message,
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        encoding: Encoding.getByName('utf-8'),
        body: jsonEncode({
          'model': model,
          'messages': apiMessages,
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        // Ensure proper UTF-8 decoding
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        final content = data['choices'][0]['message']['content'];
        
        if (content != null && content.isNotEmpty) {
          // Clean up the response text and ensure proper encoding
          return content.trim();
        } else {
          return 'Xin lỗi, tôi không thể tạo phản hồi phù hợp.';
        }
      } else {
        // Ensure proper UTF-8 decoding for error messages too
        final responseBody = utf8.decode(response.bodyBytes);
        final errorData = jsonDecode(responseBody);
        final errorMessage = errorData['error']['message'] ?? 'Unknown error';
        throw Exception('OpenAI API Error: $errorMessage');
      }
    } catch (e) {
      if (e.toString().contains('OpenAI API Error')) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Test API key validity
  static Future<bool> testApiKey(String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        encoding: Encoding.getByName('utf-8'),
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': 'Hello'}
          ],
          'max_tokens': 5,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
