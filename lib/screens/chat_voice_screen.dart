import 'package:flutter/material.dart';

class ChatVoiceScreen extends StatefulWidget {
  const ChatVoiceScreen({super.key});

  @override
  ChatVoiceScreenState createState() => ChatVoiceScreenState();
}

class ChatVoiceScreenState extends State<ChatVoiceScreen>
    with TickerProviderStateMixin {
  bool isRecording = false;
  late AnimationController _colorController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(); // 기본적으로 반복
  }

  @override
  void dispose() {
    _colorController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 파형
                if (isRecording)
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(220, 220),
                        painter: WaveCirclePainter(_waveController.value),
                      );
                    },
                  ),
                // 구체
                ClipOval(
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
              ],
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

class WaveCirclePainter extends CustomPainter {
  final double progress;

  WaveCirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width * 0.5;

    final paint = Paint()
      ..color = Colors.greenAccent.withOpacity(1.0 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final currentRadius = maxRadius * progress;
    canvas.drawCircle(center, currentRadius, paint);
  }

  @override
  bool shouldRepaint(covariant WaveCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
