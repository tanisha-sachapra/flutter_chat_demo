import 'package:ably_flutter/ably_flutter.dart' as ably;

class ChatService {
  late ably.Realtime _realtime;
  late ably.RealtimeChannel _channel;

  final String apiKey = 'Ssz4xQ.p9QNoQ:SAnAD-ncZez1Q-J-9W0Uf1PM7T_r42XS6hAbry1IJWE'; // replace this

  final String clientId;

  ChatService(this.clientId); // Accept client ID when creating instance

  Future<void> initialize() async {
    _realtime = ably.Realtime(
      options: ably.ClientOptions.fromKey(apiKey)
        ..clientId = clientId, // Set user identity
    );

    _channel = _realtime.channels.get('flutter-chat');

    await _channel.subscribe().listen((ably.Message message) {
      final sender = message.clientId ?? "Unknown";
      final text = message.data.toString();
      onMessageReceived?.call('$sender: $text');
    });
  }

  Function(String)? onMessageReceived;

  void sendMessage(String message) {
    _channel.publish(name: 'chat', data: message);
  }
}