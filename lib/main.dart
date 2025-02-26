import 'package:breeze/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 앱 시작 시 보여줄 화면
      routes: {
        '/': (context) => LoginScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
