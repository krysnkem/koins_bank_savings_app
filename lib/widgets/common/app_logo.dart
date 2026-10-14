import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

/// Official Koins MFB logo widget
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
    return Image.asset(
      'assets/images/koins_logo.png',
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if image fails to load
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: height,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
              ),
            ),
            if (showText) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Koins',
                style: TextStyle(
                  fontSize: height * 0.6,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF064E3B),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
