import 'package:flutter/material.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/common/app_text_field.dart';

/// Form fields collection for creating a savings plan.
class CreateSavingsFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController targetController;
  final TextEditingController monthlyController;
  final String? selectedProductId;
  final String? selectedDuration;
  final ValueChanged<String?> onProductChanged;
  final ValueChanged<String?> onDurationChanged;

  const CreateSavingsFormFields({
    super.key,
    required this.nameController,
    required this.targetController,
    required this.monthlyController,
    required this.selectedProductId,
    required this.selectedDuration,
    required this.onProductChanged,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Savings Name
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: AppShadows.cardSubtle,
          ),
          child: AppTextField(
            controller: nameController,
            label: 'Savings Name',
            hint: 'Enter savings name',
            standaloneLabel: true,
            prefix: const Icon(Icons.edit_outlined, color: AppColors.primary),
            validator: (v) => Validators.required(v, fieldName: 'Savings Name'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Product Type
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: AppShadows.cardSubtle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                initialValue: selectedProductId,
                decoration: const InputDecoration(
                  hintText: 'Select product type',
                  prefixIcon: Icon(Icons.savings_outlined, color: AppColors.primary),
                  prefixIconColor: AppColors.primary,
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.input,
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.input,
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.input,
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                items: [
                  for (final product in kProducts)
                    DropdownMenuItem(
                      value: product.id,
                      child: Text(
                        '${product.name} (${product.interestRate.toStringAsFixed(0)}%)',
                      ),
                    ),
                ],
                onChanged: onProductChanged,
                validator: (v) => v == null ? 'Product Type is required' : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Target Amount
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: AppShadows.cardSubtle,
          ),
          child: AppTextField(
            controller: targetController,
            label: 'Target Amount',
            hint: 'Enter target amount',
            standaloneLabel: true,
            keyboardType: TextInputType.number,
            prefix: const Text(
              '₦',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.tag,
              ),
              child: const Text(
                'NGN',
                style: TextStyle(
                  color: AppColors.secondaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
            validator: Validators.amount,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Monthly Contribution
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: AppShadows.cardSubtle,
          ),
          child: AppTextField(
            controller: monthlyController,
            label: 'Monthly Contribution',
            hint: 'Enter monthly contribution',
            standaloneLabel: true,
            keyboardType: TextInputType.number,
            prefix: const Text(
              '₦',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.tag,
              ),
              child: const Text(
                'NGN',
                style: TextStyle(
                  color: AppColors.secondaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
            validator: Validators.amount,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Duration
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: AppShadows.cardSubtle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Duration',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                initialValue: selectedDuration,
                decoration: const InputDecoration(
                  hintText: 'Select duration',
                  prefixIcon: Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primary,
                  ),
                  prefixIconColor: AppColors.primary,
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.input,
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.input,
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.input,
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                items: [
                  for (final duration in kDurations)
                    DropdownMenuItem(value: duration, child: Text(duration)),
                ],
                onChanged: onDurationChanged,
                validator: (v) => v == null ? 'Duration is required' : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
