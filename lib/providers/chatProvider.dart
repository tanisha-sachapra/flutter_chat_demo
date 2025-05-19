import 'package:flutter/material.dart';
import 'package:gossip/services/chatService.dart';

class ChatProvider extends ChangeNotifier {
  late ChatService _chatService;
  List<String> messages = [];
  final String userId;

  ChatProvider(this.userId);

  Future<void> init() async {
    _chatService = ChatService(userId);
    await _chatService.initialize();
    _chatService.onMessageReceived = (message) {
      messages.add(message);
      notifyListeners();
    };
  }

  void sendMessage(String message) {
    _chatService.sendMessage(message);
    messages.add("$userId: $message"); // show your message too
    notifyListeners();
  }
}
