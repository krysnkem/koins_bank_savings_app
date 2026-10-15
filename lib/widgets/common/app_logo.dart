import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Official Koins MFB logo widget featuring the origami geometric 'K' brandmark
class AppLogo extends StatelessWidget {
  final double height;
  final bool showText;

  const AppLogo({
    super.key,
    this.height = 40,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final emblemSize = showText ? height * 0.65 : height;

    if (!showText) {
      return SizedBox(
        width: emblemSize,
        height: emblemSize,
        child: const CustomPaint(painter: OrigamiKPainter()),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: emblemSize,
          height: emblemSize,
          child: const CustomPaint(painter: OrigamiKPainter()),
        ),
        SizedBox(height: height * 0.12),
        Text(
          'Koins',
          style: TextStyle(
            fontSize: height * 0.32,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: height * 0.04),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 1.2, color: AppColors.textPrimary.withValues(alpha: 0.7)),
            const SizedBox(width: 6),
            Text(
              'MFB',
              style: TextStyle(
                fontSize: height * 0.13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary.withValues(alpha: 0.9),
                letterSpacing: 3.5,
              ),
            ),
            const SizedBox(width: 6),
            Container(width: 14, height: 1.2, color: AppColors.textPrimary.withValues(alpha: 0.7)),
          ],
        ),
      ],
    );
  }
}

/// Custom painter for the multi-faceted emerald origami 'K'
class OrigamiKPainter extends CustomPainter {
  const OrigamiKPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Left Vertical Ribbon (Emerald gradient)
    final leftPath = Path()
      ..moveTo(w * 0.20, h * 0.22)
      ..lineTo(w * 0.44, h * 0.08)
      ..lineTo(w * 0.44, h * 0.74)
      ..lineTo(w * 0.20, h * 0.62)
      ..close();

    final leftPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.logoEmeraldLight,
          AppColors.logoEmerald,
          AppColors.logoEmeraldDark,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(leftPath, leftPaint);

    // 2. Upper Diagonal Wing (Vibrant Mint to Spring Green)
    final upperPath = Path()
      ..moveTo(w * 0.44, h * 0.40)
      ..lineTo(w * 0.80, h * 0.16)
      ..lineTo(w * 0.82, h * 0.52)
      ..lineTo(w * 0.52, h * 0.62)
      ..close();

    final upperPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.logoMintLight,
          AppColors.logoMint,
          AppColors.logoMintDark,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(upperPath, upperPaint);

    // 3. Lower Diagonal Wing (Rich Forest to Deep Emerald)
    final lowerPath = Path()
      ..moveTo(w * 0.52, h * 0.62)
      ..lineTo(w * 0.82, h * 0.72)
      ..lineTo(w * 0.68, h * 0.94)
      ..lineTo(w * 0.44, h * 0.74)
      ..close();

    final lowerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.logoMint,
          AppColors.logoDeepGreen,
          AppColors.logoDarkest,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(lowerPath, lowerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
