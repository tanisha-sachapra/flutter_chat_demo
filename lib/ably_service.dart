import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/material.dart';

class Message {
  final String id;
  final String content;
  final String senderId;

  Message({required this.id, required this.content, required this.senderId});
}

class AblyService with ChangeNotifier {
  late ably.Realtime realtime;
  late ably.RealtimeChannel channel;
  final List<Message> _messages = [];

  final String _clientId = 'flutter-user'; // ✅ Add this

  List<Message> get messages => _messages;

  String get clientId => _clientId; // ✅ Add this getter

  Future<void> initializeAbly() async {
    realtime = ably.Realtime(
      options: ably.ClientOptions.fromKey('Ssz4xQ.p9QNoQ:SAnAD-ncZez1Q-J-9W0Uf1PM7T_r42XS6hAbry1IJWE')
        ..clientId = _clientId,
    );

    channel = realtime.channels.get('gossip');

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

  Future<void> sendMessage(String text) async {
    await channel.publish(name: 'gossip', data: text);
  }
}
