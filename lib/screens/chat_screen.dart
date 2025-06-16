import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, dynamic>> _messages = [];
  final record = AudioRecorder();
  bool _isRecording = false;

  // 텍스트 메시지 전송 함수
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isUser': true,
          'timestamp': DateTime.now(),
        });
        _messages.add({"bot": "Hello world"});
        _messageController.clear();
      });
    }
  }

  Future<void> _toggleRecording() async {
    if (await record.hasPermission()) {
      if (_isRecording) {
        final path = await record.stop();
        setState(() {
          _messages.add({"user": "🎤 녹음 저장됨: $path"});
        });
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final filePath =
            '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await record.start(const RecordConfig(), path: filePath); // ← 여기 수정
      }

      setState(() {
        _isRecording = !_isRecording;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("마이크 권한이 필요합니다.")),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose(); // FocusNode도 해제
    record.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isUser'] == true
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: message['isUser'] == true
                          ? Color(0xFF21A900)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: TextStyle(
                        color: message['isUser'] == true
                            ? Colors.white
                            : Color(0xFF21A900),
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: "메시지",
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusNode);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Color(0xFF21A900),
                    size: 18,
                  ),
                  onPressed: _sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(2),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: Color(0xFF21A900),
                    size: 18,
                  ),
                  onPressed: _toggleRecording,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(2),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.graphic_eq,
                    color: Color(0xFF21A900),
                    size: 18,
                  ),
                  onPressed: () async {
                    await _toggleRecording();
                    Navigator.pushNamed(context, '/chat_voice');
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
