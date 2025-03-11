import 'package:flutter/material.dart';
import 'package:breeze/screens/chat_screen.dart';
import 'package:breeze/screens/chat_voice_screen.dart';
import 'package:breeze/screens/make_voice_screen.dart';
import 'package:breeze/screens/my_subscribe_screen.dart';
import 'package:breeze/screens/record_voice_screen.dart';
import 'package:breeze/screens/login_screen.dart';

import 'MainLayout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/chat': (context) => MainLayout(body: ChatScreen()),
        '/chat_voice': (context) => MainLayout(body: ChatVoiceScreen()),
        '/my_subscribe': (context) => MainLayout(body: MySubscribeScreen()),
        '/make_voice': (context) => MainLayout(body: MakeVoiceScreen()),
        '/record_voice': (context) => MainLayout(body: RecordVoiceScreen()),
      },
    );
  }
}
