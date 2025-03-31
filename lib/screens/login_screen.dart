import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/sidebar_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color backgroundColor = Colors.black;
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
    super.dispose();
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
            Navigator.pushNamed(context, '/chat'); // "로그인" 버튼 클릭 시 /chat으로 이동
          }
          // 다른 버튼은 추후 기능 추가 가능
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
            Image.asset(icon, width: 24, height: 24), // 아이콘 추가
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
      drawer: const SideBar(),
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        color: backgroundColor,
        child: Stack(
          children: [
            // 중앙에 "Vreeze" 텍스트 (약간 위쪽으로 올림)
            Align(
              alignment: const Alignment(0, -0.3),
              child: const Text(
                "Vreeze",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                      "/img/login_kakao.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBottomButton(
                      context,
                      "네이버로 계속하기",
                      bottomPanelHeight,
                      "/img/login_naver.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBottomButton(
                      context,
                      "Google로 계속하기",
                      bottomPanelHeight,
                      "/img/login_google.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBottomButton(
                      context,
                      "전화번호로 계속하기",
                      bottomPanelHeight,
                      "/img/login_phone.png",
                    ),
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
