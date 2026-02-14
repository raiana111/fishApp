import 'package:flutter/material.dart';
import '../../models/fish.dart';

class FishWidget extends StatelessWidget {
  final Fish fish;

  const FishWidget({super.key, required this.fish});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 50),
      left: fish.x - fish.radius,
      top: fish.y - fish.radius,
      child: Container(
        width: fish.radius * 2,
        height: fish.radius * 2,
        child: CustomPaint(
          painter: _FishPainter(fish: fish),
        ),
      ),
    );
  }
}

class _FishPainter extends CustomPainter {
  final Fish fish;

  _FishPainter({required this.fish});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fish.color
      ..style = PaintingStyle.fill;

    // Тело рыбки (овал)
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: fish.radius,
    );

    canvas.drawOval(rect, paint);

    // Хвост
    final tailPaint = Paint()
      ..color = fish.color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final tailPath = Path();
    if (fish.dx < 0) {
      // Плывет влево
      tailPath.moveTo(0, size.height * 0.3);
      tailPath.lineTo(-fish.radius * 0.8, size.height * 0.5);
      tailPath.lineTo(0, size.height * 0.7);
    } else {
      // Плывет вправо
      tailPath.moveTo(size.width, size.height * 0.3);
      tailPath.lineTo(size.width + fish.radius * 0.8, size.height * 0.5);
      tailPath.lineTo(size.width, size.height * 0.7);
    }

    canvas.drawPath(tailPath, tailPaint);

    // Глаз
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final eyeOffset = fish.dx < 0
      ? Offset(size.width * 0.7, size.height * 0.4)
      : Offset(size.width * 0.3, size.height * 0.4);

    canvas.drawCircle(eyeOffset, fish.radius * 0.2, eyePaint);

    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(eyeOffset, fish.radius * 0.1, pupilPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}