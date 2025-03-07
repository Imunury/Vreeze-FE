import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Drawer 위젯을 사이드바로 사용
      child: Container(
        color: Colors.black87, // ListView의 배경색을 black87로 설정
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('구독권 알아보기', style: TextStyle(color: Colors.white)),
              onTap: () {
                // 원하는 기능 추가
                Navigator.pop(context); // 사이드바 닫기
                Navigator.pushNamed(context, '/my_subscribe');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('내 목소리 만들기', style: TextStyle(color: Colors.white)),
              onTap: () {
                // 원하는 기능 추가
                Navigator.pop(context);
                Navigator.pushNamed(context, '/make_voice');
              },
            ),
          ],
        ),
      ),
    );
  }
}
