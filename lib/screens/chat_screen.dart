import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  final FocusNode _focusNode = FocusNode();
  final record = AudioRecorder();
  final audioPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _currentlyPlayingPath;

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

  Future<void> _toggleRecording() async {
    if (await record.hasPermission()) {
      if (_isRecording) {
        final path = await record.stop();
        setState(() {
          messages.add({
            "type": "voice",
            "path": path,
            "filename": path?.split('/').last
          });
        });
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final filePath =
            '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await record.start(const RecordConfig(), path: filePath);
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

  Future<void> _playVoiceMessage(String path) async {
    if (_currentlyPlayingPath == path) {
      await audioPlayer.stop();
      setState(() {
        _currentlyPlayingPath = null;
      });
    } else {
      try {
        await audioPlayer.setFilePath(path);
        await audioPlayer.play();
        setState(() {
          _currentlyPlayingPath = path;
        });

        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              _currentlyPlayingPath = null;
            });
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오디오 재생 중 오류가 발생했습니다.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    record.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isUser = message.containsKey("user");

              if (message["type"] == "voice") {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _currentlyPlayingPath == message["path"]
                                ? Icons.stop
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () => _playVoiceMessage(message["path"]),
                        ),
                        Text(
                          message["filename"] ?? "음성 메시지",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }

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
                onPressed: _toggleRecording,
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
                onPressed: () async {
                  await _toggleRecording(); // 녹음 토글 수행
                  Navigator.pushNamed(context, '/chat_voice'); // 화면 이동
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
