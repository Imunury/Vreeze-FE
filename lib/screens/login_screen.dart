import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService(Dio(BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL'] ?? 'https://api.example.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )));
  bool _isLoading = false;
  Color backgroundColor = Colors.black;
  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // 3초마다 랜덤하게 배경색 변경 (2초 애니메이션)
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        backgroundColor = colorList[_random.nextInt(colorList.length)];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.yellow,
    Colors.pink,
  ];

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await _authService.login(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인에 실패했습니다.')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  // 하단 패널의 각 버튼 생성 함수 (아이콘 추가)
  Widget _buildBottomButton(
      BuildContext context, String text, double panelHeight, String icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.9, // 버튼 너비: 화면의 90%
      height: panelHeight * 0.18, // 버튼 높이: 패널 높이의 18%
      child: ElevatedButton(
        onPressed: () {
          if (text == "전화번호로 계속하기") {
            Navigator.pushNamed(context, '/phone_auth'); // 바로 이동
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // 버튼 배경: 검은색
          side: const BorderSide(color: Colors.white, width: 1), // 흰색 테두리 (1px)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // 더 큰 border-radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                try {
                  return Image.asset('assets/$icon', width: 24, height: 24);
                } catch (e) {
                  print('이미지 로딩 오류: $e');
                  return const Icon(Icons.error, color: Colors.white, size: 24);
                }
              },
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white, // 버튼 글씨: 흰색
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bottomPanelHeight = screenSize.height * 0.35; // 하단 패널 높이: 화면의 35%

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        color: backgroundColor,
        child: Stack(
          children: [
            // 중앙에 "Vreeze" 텍스트 (약간 위쪽으로 올림)
            const Align(
              alignment: Alignment(0, -0.3),
              child: Text(
                "Vreeze",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // 하단 고정 패널
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: bottomPanelHeight,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomButton(
                      context,
                      "카카오톡으로 계속하기",
                      bottomPanelHeight,
                      "img/login_kakao.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBottomButton(
                      context,
                      "네이버로 계속하기",
                      bottomPanelHeight,
                      "img/login_naver.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBottomButton(
                      context,
                      "Google로 계속하기",
                      bottomPanelHeight,
                      "img/login_google.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBottomButton(
                      context,
                      "전화번호로 계속하기",
                      bottomPanelHeight,
                      "img/login_phone.png",
                    ),
                    if (_isLoading)
                      const CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
