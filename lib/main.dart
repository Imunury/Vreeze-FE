import 'package:breeze/screens/delete_account_screen.dart';
import 'package:breeze/screens/profile_screen.dart';
import 'package:breeze/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:breeze/screens/chat_screen.dart';
import 'package:breeze/screens/chat_voice_screen.dart';
import 'package:breeze/screens/make_voice_screen.dart';
import 'package:breeze/screens/my_subscribe_screen.dart';
import 'package:breeze/screens/record_voice_screen.dart';
import 'package:breeze/screens/login_screen.dart';
import 'MainLayout.dart';
import 'package:breeze/cores/dio_client.dart';

void main() async {
  await dotenv.load();
  setupDio();
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
        '/setting': (context) => MainLayout(body: SettingScreen()),
        '/profile': (context) => MainLayout(body: ProfileScreen()),
        '/delete_account': (context) => MainLayout(body: DeleteAccountScreen()),
      },
    );
  }
}
