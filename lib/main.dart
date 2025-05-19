import 'package:flutter/material.dart';
import 'package:gossip/providers/chatProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GetUserIdScreen(),
  ));
}

class GetUserIdScreen extends StatefulWidget {
  const GetUserIdScreen({super.key});

  @override
  State<GetUserIdScreen> createState() => _GetUserIdScreenState();
}

class _GetUserIdScreenState extends State<GetUserIdScreen> {
  final TextEditingController _controller = TextEditingController();

  void _startChat() {
    final userId = _controller.text.trim();
    if (userId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ChatProvider(userId)..init(),
            child: const ChatPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter User ID')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enter your name or ID to join the chat"),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "User ID"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startChat,
              child: const Text("Join Chat"),
            )
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Gossip')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.messages.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(chatProvider.messages[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      chatProvider.sendMessage(text);
                      _controller.clear();
                    }
                  },
                  child: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

