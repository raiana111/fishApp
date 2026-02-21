import 'package:flutter/material.dart';

class HookWidget extends StatelessWidget {
  final double x;
  final double y;
  final bool isActive;

  const HookWidget({
    super.key,
    required this.x,
    required this.y,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - 15,
      top: y - (isActive ? 76 : 57),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 30,
        height: isActive ? 80 : 60,
        child: CustomPaint(
          painter: _HookPainter(isActive: isActive),
        ),
      ),
    );
  }
}

class _HookPainter extends CustomPainter {
  final bool isActive;

  _HookPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    // Леска
    final linePaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height * 0.8),
      linePaint,
    );

    // Крючок
    final hookPaint = Paint()
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final hookPath = Path();
    hookPath.moveTo(size.width / 2, size.height * 0.8);
    hookPath.quadraticBezierTo(
      size.width / 2 + 10,
      size.height * 0.85,
      size.width / 2 - 5,
      size.height * 0.9,
    );
    hookPath.quadraticBezierTo(
      size.width / 2,
      size.height * 0.95,
      size.width / 2,
      size.height * 0.8,
    );

    canvas.drawPath(hookPath, hookPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
