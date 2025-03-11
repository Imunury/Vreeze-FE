import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/sidebar_widget.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가

  // 텍스트 메시지 전송 함수
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({"user": _messageController.text});
        messages.add({"bot": "Hello world"});
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose(); // FocusNode도 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 채팅 메시지 리스트
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isUser = message.containsKey("user");
              final messageText = message.values.first;
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.green.shade400 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    messageText,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // 하단 입력창과 전송 버튼 (녹음 기능 제거)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black45,
            border: Border(
              top: BorderSide(
                color: Colors.white, // 위쪽 border 색상
                width: 0.5, // 1px 두께
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), // 상단 왼쪽만 둥글게
              topRight: Radius.circular(10), // 상단 오른쪽만 둥글게
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode, // FocusNode 연결
                  decoration: const InputDecoration(
                    hintText: "메시지",
                    border: InputBorder.none,
                  ),
                  onTap: () {
                    // TextField 터치 시 키보드 자동으로 표시됨
                    FocusScope.of(context).requestFocus(_focusNode);
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Colors.green.shade400,
                  size: 18,
                ),
                onPressed: _sendMessage,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8), // 버튼 크기 줄이기
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.graphic_eq,
                  color: Colors.green.shade400,
                  size: 18,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/chat_voice'); // '/chat_voice' 화면으로 이동
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white, // 아이콘 버튼 배경을 흰색으로 설정
                  shape: CircleBorder(), // 원형 버튼 유지
                  padding: EdgeInsets.all(8), // 버튼 크기 줄이기
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
