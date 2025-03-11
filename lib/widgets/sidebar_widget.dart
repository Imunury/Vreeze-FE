import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Drawer 위젯을 사이드바로 사용
      child: Container(
        color: Colors.black87, // ListView의 배경색을 black87로 설정
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.subscriptions,
                        color: Colors.white, size: 20),
                    title: const Text('구독권 알아보기',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/my_subscribe');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.voice_chat,
                        color: Colors.white, size: 20),
                    title: const Text('내 목소리 만들기',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/make_voice');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 18, color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/setting');
                    },
                    child: Icon(Icons.more_vert, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
