import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/common/app_text_field.dart';
import '../../../../widgets/common/primary_button.dart';

class CreateSavingsScreen extends ConsumerStatefulWidget {
  final String? productId;

  const CreateSavingsScreen({super.key, this.productId});

  @override
  ConsumerState<CreateSavingsScreen> createState() => _CreateSavingsScreenState();
}

class _CreateSavingsScreenState extends ConsumerState<CreateSavingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _target = TextEditingController();
  final _monthly = TextEditingController();
  late String? _productId = widget.productId;
  String? _duration;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _monthly.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_productId == null || _duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a product and duration')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // EXPECTATION: savingsProvider.createPlan(...) then snackbar
    // "Savings Created Successfully" and return to Dashboard.
    final product = productById(_productId!)!;
    ref.read(uiSessionProvider.notifier).addPlan(
          UiPlan(
            id: 'plan-${DateTime.now().millisecondsSinceEpoch}',
            name: _name.text.trim(),
            productId: product.id,
            productName: product.name,
            amount: 0,
            targetAmount: double.parse(_target.text.replaceAll(',', '')),
            monthlyContribution: double.parse(_monthly.text.replaceAll(',', '')),
            frequency: 'Monthly',
            duration: _duration!,
          ),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Savings Created Successfully')),
    );
    Navigator.of(context).popUntil((route) => route.settings.name == '/dashboard' || route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Savings Plan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Set your savings goal and start building towards your future.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _name,
                label: 'Savings Name',
                hint: 'e.g. Emergency Fund',
                validator: (v) => Validators.required(v, fieldName: 'Savings Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _productId,
                decoration: const InputDecoration(labelText: 'Product Type'),
                items: [
                  for (final product in kProducts)
                    DropdownMenuItem(
                      value: product.id,
                      child: Text('${product.name} (${product.interestRate.toStringAsFixed(0)}%)'),
                    ),
                ],
                onChanged: (value) => setState(() => _productId = value),
                validator: (v) => v == null ? 'Product Type is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _target,
                label: 'Target Amount',
                hint: 'Enter target amount',
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.currency_exchange),
                validator: Validators.amount,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _monthly,
                label: 'Monthly Contribution',
                keyboardType: TextInputType.number,
                validator: Validators.amount,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _duration,
                decoration: const InputDecoration(labelText: 'Duration'),
                items: [
                  for (final duration in kDurations)
                    DropdownMenuItem(value: duration, child: Text(duration)),
                ],
                onChanged: (value) => setState(() => _duration = value),
                validator: (v) => v == null ? 'Duration is required' : null,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Create', loading: _loading, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
