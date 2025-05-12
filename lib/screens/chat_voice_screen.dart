import 'package:flutter/material.dart';

class ChatVoiceScreen extends StatefulWidget {
  const ChatVoiceScreen({super.key});

  @override
  ChatVoiceScreenState createState() => ChatVoiceScreenState();
}

class ChatVoiceScreenState extends State<ChatVoiceScreen>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  late AnimationController _colorController;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: ClipOval(
              child: SizedBox(
                width: 200,
                height: 200,
                child: AnimatedBuilder(
                  animation: _colorController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: DiagonalGreenGradientPainter(
                        offset: _colorController.value,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
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
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(30),
                backgroundColor: Colors.white,
              ),
              child: Icon(
                isRecording ? Icons.mic_off : Icons.mic,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(30),
                backgroundColor: Colors.white,
              ),
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalGreenGradientPainter extends CustomPainter {
  final double offset;

  DiagonalGreenGradientPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1.0 + offset * 2, -1.0 + offset * 2),
        end: Alignment(1.0 + offset * 2, 1.0 + offset * 2),
        colors: [
          Colors.green.shade400,
          Colors.green.shade300,
          Colors.green.shade200,
          Colors.green.shade300,
          Colors.green.shade400,
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        tileMode: TileMode.mirror,
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant DiagonalGreenGradientPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}

