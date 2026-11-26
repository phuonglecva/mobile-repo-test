import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MiloCharacter extends StatelessWidget {
  const MiloCharacter({super.key, this.size = 76, this.expression = MiloExpression.happy});

  final double size;
  final MiloExpression expression;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MiloPainter(expression: expression)),
    );
  }
}

enum MiloExpression { happy, excited, thinking, cheering }

class _MiloPainter extends CustomPainter {
  const _MiloPainter({required this.expression});

  final MiloExpression expression;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    canvas.save();
    canvas.scale(scale);

    final orange = Paint()..color = const Color(0xFFFF994F);
    final deepOrange = Paint()..color = const Color(0xFFE97836);
    final cream = Paint()..color = const Color(0xFFFFF5E8);
    final pink = Paint()..color = const Color(0xFFFFB0A9);
    final ink = Paint()..color = AppColors.ink;
    final white = Paint()..color = Colors.white;

    final leftEar = Path()
      ..moveTo(17, 38)
      ..quadraticBezierTo(9, 11, 26, 8)
      ..quadraticBezierTo(43, 11, 43, 36)
      ..close();
    final rightEar = Path()
      ..moveTo(57, 36)
      ..quadraticBezierTo(58, 10, 76, 8)
      ..quadraticBezierTo(94, 13, 83, 40)
      ..close();
    canvas.drawPath(leftEar, deepOrange);
    canvas.drawPath(rightEar, deepOrange);

    final leftInner = Path()
      ..moveTo(22, 29)
      ..quadraticBezierTo(20, 14, 28, 15)
      ..quadraticBezierTo(37, 18, 37, 31)
      ..close();
    final rightInner = Path()
      ..moveTo(64, 30)
      ..quadraticBezierTo(66, 15, 76, 15)
      ..quadraticBezierTo(84, 19, 79, 31)
      ..close();
    canvas.drawPath(leftInner, pink);
    canvas.drawPath(rightInner, pink);

    canvas.drawCircle(const Offset(50, 53), 39, orange);
    canvas.drawOval(const Rect.fromLTWH(23, 47, 27, 31), cream);
    canvas.drawOval(const Rect.fromLTWH(50, 47, 27, 31), cream);
    canvas.drawOval(const Rect.fromLTWH(35, 58, 30, 25), cream);

    canvas.drawCircle(const Offset(33, 54), 5.2, ink);
    canvas.drawCircle(const Offset(67, 54), 5.2, ink);
    canvas.drawCircle(const Offset(34.5, 52), 1.6, white);
    canvas.drawCircle(const Offset(68.5, 52), 1.6, white);
    canvas.drawOval(const Rect.fromLTWH(20, 65, 12, 6), pink);
    canvas.drawOval(const Rect.fromLTWH(68, 65, 12, 6), pink);
    canvas.drawOval(const Rect.fromLTWH(45, 65, 10, 7), deepOrange);

    final smile = Path()
      ..moveTo(42, 74)
      ..quadraticBezierTo(50, 84, 59, 74);
    canvas.drawPath(
      smile,
      Paint()
        ..color = AppColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.3
        ..strokeCap = StrokeCap.round,
    );

    if (expression == MiloExpression.thinking) {
      canvas.drawCircle(const Offset(87, 15), 7, Paint()..color = AppColors.yellow);
      canvas.drawCircle(const Offset(87, 15), 2.2, white);
    } else if (expression == MiloExpression.excited || expression == MiloExpression.cheering) {
      final sparkle = Paint()..color = AppColors.yellow;
      canvas.drawCircle(const Offset(88, 17), 6, sparkle);
      canvas.drawCircle(const Offset(12, 49), 4, sparkle);
      if (expression == MiloExpression.cheering) {
        canvas.drawCircle(const Offset(86, 72), 4, Paint()..color = AppColors.mint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MiloPainter oldDelegate) => oldDelegate.expression != expression;
}
