import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/common/primary_button.dart';
import '../providers/create_savings_provider.dart';
import '../widgets/create_savings_form_fields.dart';
import '../widgets/create_savings_header_section.dart';
import '../widgets/create_savings_security_banner.dart';

/// Screen for configuring and creating a new user savings plan.
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
              const CreateSavingsHeaderSection(),
              const SizedBox(height: AppSpacing.lg),
              CreateSavingsFormFields(
                nameController: _name,
                targetController: _target,
                monthlyController: _monthly,
                selectedProductId: state.productId,
                selectedDuration: state.duration,
                onProductChanged: (value) => ref
                    .read(createSavingsNotifierProvider(widget.productId).notifier)
                    .selectProduct(value),
                onDurationChanged: (value) => ref
                    .read(createSavingsNotifierProvider(widget.productId).notifier)
                    .selectDuration(value),
              ),
              const SizedBox(height: AppSpacing.lg),
              const CreateSavingsSecurityBanner(),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Create',
                loading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
