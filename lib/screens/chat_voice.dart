import 'package:flutter/material.dart';

class ChatVoiceScreen extends StatefulWidget {
  @override
  _ChatVoiceScreenState createState() => _ChatVoiceScreenState();
}

class _ChatVoiceScreenState extends State<ChatVoiceScreen> {
  bool isRecording = false; // 녹음 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 중앙 구체
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 왼쪽 하단 버튼 (녹음 버튼)
          Positioned(
            bottom: 50,
            left: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(30),
                backgroundColor: Colors.white,
              ),
              child: Icon(
                isRecording ? Icons.mic_off : Icons.mic,
                color: Colors.black,
              ),
            ),
          ),
          // 오른쪽 하단 버튼 (예: 뒤로 가기)
          Positioned(
            bottom: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 뒤로 가기
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(30),
                backgroundColor: Colors.white,
              ),
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
