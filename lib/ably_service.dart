import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/material.dart';

class Message {
  final String id;
  final String content;
  final String senderId;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
  });
}

class AblyService with ChangeNotifier {
  late ably.Realtime realtime;
  late ably.RealtimeChannel channel;
  final List<Message> _messages = [];

  final String _clientId = 'flutter-user';

  List<Message> get messages => _messages;
  String get clientId => _clientId;

  Future<void> initializeAbly() async {
    // Initialize Realtime
    realtime = ably.Realtime(
      options: ably.ClientOptions.fromKey(
        'Ssz4xQ.p9QNoQ:SAnAD-ncZez1Q-J-9W0Uf1PM7T_r42XS6hAbry1IJWE',
      )..clientId = _clientId,
    );

    channel = realtime.channels.get('gossip');

    // ✅ Step 1: Fetch history messages
    await _loadHistoricalMessages();

    // ✅ Step 2: Listen for real-time messages
    channel.subscribe().listen((ably.Message message) {
      _messages.add(
        Message(
          id: message.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          content: message.data.toString(),
          senderId: message.clientId ?? 'unknown',
        ),
      );
      notifyListeners();
    });
  }

  Future<void> _loadHistoricalMessages() async {
    try {
     final history = await channel.history(
  ably.RealtimeHistoryParams(
    direction: 'backwards',
    limit: 50,
  ),
);
      final reversed = history.items.reversed;
      for (var msg in reversed) {
        _messages.add(
          Message(
            id: msg.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            content: msg.data.toString(),
            senderId: msg.clientId ?? 'unknown',
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error fetching Ably history: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    await channel.publish(name: 'gossip', data: text);
  }
}
