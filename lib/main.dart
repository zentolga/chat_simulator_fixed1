import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Simulator'),
      ),
      body: const Center(
        child: Text('Merhaba Chat!'),
      ),
    );
  }
}

