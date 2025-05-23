import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ably_service.dart';
import 'chatscreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AblyService()..initializeAbly(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ably Chat App',
      home: ChatScreen(),
    );
  }
}
