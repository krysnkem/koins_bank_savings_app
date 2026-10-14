import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/common/app_text_field.dart';
import '../../../../widgets/common/primary_button.dart';
import '../providers/create_savings_provider.dart';

class CreateSavingsScreen extends ConsumerStatefulWidget {
  final String? productId;

  const CreateSavingsScreen({super.key, this.productId});

  @override
  ConsumerState<CreateSavingsScreen> createState() =>
      _CreateSavingsScreenState();
}

class _CreateSavingsScreenState extends ConsumerState<CreateSavingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _target = TextEditingController();
  final _monthly = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _monthly.dispose();
    super.dispose();
  }

  void _submit() {
    ref
        .read(createSavingsNotifierProvider(widget.productId).notifier)
        .submit(
          formKey: _formKey,
          name: _name.text,
          targetText: _target.text,
          monthlyText: _monthly.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createSavingsNotifierProvider(widget.productId));

    ref.listen<CreateSavingsState>(
      createSavingsNotifierProvider(widget.productId),
      (prev, next) {
        if (next is CreateSavingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (next is CreateSavingsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Savings Created Successfully')),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            try {
              GoRouter.of(context).go('/dashboard');
            } catch (_) {
              // Fallback for tests or standard navigator
            }
          }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Create Savings Plan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Savings Plan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Set your savings goal and start building towards your future.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: AppShadows.cardSubtle,
                ),
                child: AppTextField(
                  controller: _name,
                  label: 'Savings Name',
                  hint: 'Enter savings name',
                  standaloneLabel: true,
                  prefix: const Icon(Icons.edit_outlined, color: AppColors.primary),
                  validator: (v) => Validators.required(v, fieldName: 'Savings Name'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
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
                      initialValue: state.productId,
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
                            child: Text('${product.name} (${product.interestRate.toStringAsFixed(0)}%)'),
                          ),
                      ],
                      onChanged: (value) => ref
                          .read(createSavingsNotifierProvider(widget.productId).notifier)
                          .selectProduct(value),
                      validator: (v) => v == null ? 'Product Type is required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: AppShadows.cardSubtle,
                ),
                child: AppTextField(
                  controller: _target,
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
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: AppShadows.cardSubtle,
                ),
                child: AppTextField(
                  controller: _monthly,
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
                      initialValue: state.duration,
                      decoration: const InputDecoration(
                        hintText: 'Select duration',
                        prefixIcon: Icon(Icons.calendar_month_outlined, color: AppColors.primary),
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
                      onChanged: (value) => ref
                          .read(createSavingsNotifierProvider(widget.productId).notifier)
                          .selectDuration(value),
                      validator: (v) => v == null ? 'Duration is required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.55),
                  borderRadius: AppRadius.card,
                  border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.35)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.white,
                      child: Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 18),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Your savings plan helps you stay consistent and achieve your financial goals.',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Create', loading: state.isLoading, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
