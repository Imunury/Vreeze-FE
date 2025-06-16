import 'widgets/header_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/sidebar_widget.dart';

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 20) {
          // 오른쪽에서 왼쪽으로 드래그하면 뒤로가기
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: HeaderWidget(), // 공통 상단 바
        drawer: SideBar(), // 사이드바
        backgroundColor: Colors.black,
        body: body, // 개별 화면 적용
      ),
    );
  }
}
