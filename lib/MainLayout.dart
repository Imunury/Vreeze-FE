import 'package:breeze/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/sidebar_widget.dart';

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(), // 공통 상단 바
      drawer: SideBar(), // 사이드바
      backgroundColor: Colors.black,
      body: body, // 개별 화면 적용
    );
  }
}
