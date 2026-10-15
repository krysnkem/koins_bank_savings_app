import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.message = AppStrings.somethingWentWrong,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final displayMessage = ErrorHandler.getUserMessage(message);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              displayMessage,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
