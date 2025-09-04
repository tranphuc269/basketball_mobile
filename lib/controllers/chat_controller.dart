import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/openai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isNewSession = true.obs;
  final RxBool isApiKeyConfigured = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkApiKeyStatus();
  }

  Future<void> _checkApiKeyStatus() async {
    isApiKeyConfigured.value = await OpenAIService.isApiKeyConfigured();
  }

  List<ChatMessage> get recentMessages {
    if (messages.length <= 5) {
      return messages.toList();
    }
    return messages.sublist(messages.length - 5);
  }

  // Convert messages to format for OpenAI API
  List<Map<String, String>> get messageHistoryForAPI {
    return messages.map((msg) => {
      'text': msg.text,
      'isUser': msg.isUser.toString(),
    }).toList();
  }

  void addMessage(String text, bool isUser) {
    // Clean and format the text
    final cleanText = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    messages.add(ChatMessage(
      text: cleanText,
      isUser: isUser,
      timestamp: DateTime.now(),
    ));
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Check if API key is configured
    if (!isApiKeyConfigured.value) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng cấu hình OpenAI API key trong Settings',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    addMessage(text, true);
    messageController.clear();

    await _getOpenAIResponse(text);
  }

  Future<void> _getOpenAIResponse(String userMessage) async {
    isLoading.value = true;
    
    try {
      // Prepare message history based on session mode
      List<Map<String, String>> history = [];
      if (!isNewSession.value) {
        history = messageHistoryForAPI;
      }
      
      final response = await OpenAIService.sendMessage(
        message: userMessage,
        messageHistory: history,
      );
      
      // Debug: Print response to console
      print('Response length: ${response.length}');
      
      addMessage(response, false);
    } catch (e) {
      String errorMessage = 'Xin lỗi, có lỗi xảy ra khi gọi AI. ';
      if (e.toString().contains('API key not configured')) {
        errorMessage += 'Vui lòng cấu hình API key trong Settings.';
      } else if (e.toString().contains('OpenAI API Error')) {
        errorMessage += 'Lỗi từ OpenAI API.';
      } else {
        errorMessage += 'Vui lòng kiểm tra kết nối mạng.';
      }
      
      // Debug: Print error to console
      print('OpenAI Error: $e');
      
      addMessage(errorMessage, false);
      
      Get.snackbar(
        'Lỗi',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startNewSession() {
    messages.clear();
    isNewSession.value = true;
    addMessage('Xin chào! Tôi là trợ lý AI của ứng dụng học bóng rổ. Tôi có thể giúp bạn gì?', false);
  }

  void continueChat() {
    isNewSession.value = false;
    if (messages.isEmpty) {
      addMessage('Chào mừng bạn quay lại! Tôi có thể giúp bạn gì?', false);
    }
  }

  // Refresh API key status (called when returning from settings)
  void refreshApiKeyStatus() {
    _checkApiKeyStatus();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
