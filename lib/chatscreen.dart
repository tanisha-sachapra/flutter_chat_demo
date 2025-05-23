import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ably_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final ablyService = Provider.of<AblyService>(context, listen: false);
    ablyService.sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ablyService = Provider.of<AblyService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: ablyService.messages.length,
              itemBuilder: (context, index) {
                final message =
                    ablyService.messages[ablyService.messages.length - 1 - index];
                final isMe = message.senderId == ablyService.clientId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Field + Send Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text Field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                // Send Button
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
