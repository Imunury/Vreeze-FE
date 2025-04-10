import 'package:flutter/material.dart';

class MakeVoiceScreen extends StatefulWidget {
  const MakeVoiceScreen({super.key});

  @override
  MakeVoiceScreenState createState() => MakeVoiceScreenState();
}

class MakeVoiceScreenState extends State<MakeVoiceScreen> {
  bool showInstructions = false; // 환경 설정 안내를 보여줄지 여부

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // "내 목소리 만들기" 버튼 (오른쪽 상단)
        Positioned(
          top: 20,
          right: 20,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showInstructions = true; // 버튼을 누르면 안내문이 보이도록 변경
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              "'내 목소리 만들기' 하러 가기",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        // 환경 설정 안내문 (오른쪽 버튼을 눌러야 나타남)
        if (showInstructions)
          Positioned(
            top: 80,
            left: 20,
            right: MediaQuery.of(context).size.width * 0.4,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "먼저, 환경 설정을 해주세요.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "- 조용한 환경이어야 해요.\n"
                    "- 화장실같이 울리는 공간은 피해주세요.\n"
                    "- 다른 사람의 목소리가 함께 녹음되지 않도록 주의해주세요.",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/record_voice');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      "내 목소리 녹음하러 가기",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
