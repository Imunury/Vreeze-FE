import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/delete_account_screen.dart';
import 'screens/phone_auth_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_voice_screen.dart';
import 'screens/make_voice_screen.dart';
import 'screens/my_subscribe_screen.dart';
import 'screens/record_voice_screen.dart';
import 'screens/login_screen.dart';
import 'MainLayout.dart';
import 'cores/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDkXqXqXqXqXqXqXqXqXqXqXqXqXqXqXqXq",
      authDomain: "your-project.firebaseapp.com",
      projectId: "vreeze-c0f10",
      storageBucket: "your-project.appspot.com",
      messagingSenderId: "1234567890",
      appId: "1:1234567890:web:abcdef1234567890",
    ),
  );
  await dotenv.load(fileName: ".env");
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
        '/': (context) => const LoginScreen(),
        '/phone_auth': (context) => const PhoneAuthScreen(),
        '/chat': (context) => MainLayout(body: const ChatScreen()),
        '/chat_voice': (context) => MainLayout(body: const ChatVoiceScreen()),
        '/my_subscribe': (context) =>
            MainLayout(body: const MySubscribeScreen()),
        '/make_voice': (context) => MainLayout(body: const MakeVoiceScreen()),
        '/record_voice': (context) =>
            MainLayout(body: const RecordVoiceScreen()),
        '/setting': (context) => MainLayout(body: const SettingScreen()),
        '/profile': (context) => MainLayout(body: const ProfileScreen()),
        '/delete_account': (context) =>
            MainLayout(body: const DeleteAccountScreen()),
      },
    );
  }
}
