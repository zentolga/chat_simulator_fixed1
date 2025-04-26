import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}

class Profile {
  final String name;
  final int age;
  final String description;

  Profile({required this.name, required this.age, required this.description});
}

final List<Profile> profiles = [
  Profile(name: "Emily", age: 24, description: "Kitap kurdu, kahve tutkunu."),
  Profile(name: "Mia", age: 22, description: "Seyahat etmeyi seviyor."),
  Profile(name: "Sophia", age: 25, description: "Kedilere bayılıyor."),
  Profile(name: "Olivia", age: 23, description: "Film gecelerine bayılır."),
];

int userTokens = 10;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> unlockedProfiles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jetonlar: $userTokens"),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Stack(
          children: profiles.map((profile) {
            final isUnlocked = unlockedProfiles.contains(profile.name);
            return Swipable(
              onSwipeRight: (finalPosition) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Beğendin: ${profile.name}")),
                );
              },
              onSwipeLeft: (finalPosition) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Beğenmedin: ${profile.name}")),
                );
              },
              child: ProfileCard(
                profile: profile,
                isUnlocked: isUnlocked,
                onChatPressed: () {
                  if (userTokens > 0) {
                    setState(() {
                      userTokens--;
                      unlockedProfiles.add(profile.name);
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(name: profile.name),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Yeterli jeton yok!")),
                    );
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback onChatPressed;
  final bool isUnlocked;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onChatPressed,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: isUnlocked
                  ? const Icon(Icons.person, size: 100, color: Colors.grey)
                  : ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const Icon(Icons.person, size: 100, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              "${profile.name}, ${profile.age}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              profile.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onChatPressed,
              child: const Text("Sohbete Başla"),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String name;

  const ChatPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name ile Sohbet"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ChatBubble(message: "Merhaba!", isMe: false),
          ChatBubble(message: "Nasılsın?", isMe: false),
          ChatBubble(message: "İyiyim, sen?", isMe: true),
          ChatBubble(message: "Ben de iyiyim.", isMe: false),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.pink[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message),
      ),
    );
  }
}
