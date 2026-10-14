import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/widgets/common/app_text_field.dart';

void main() {
  group('AppTextField Widget Tests', () {
    testWidgets('renders and allows typing in standard text field', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              controller: controller,
              label: 'Savings Name',
              hint: 'Enter savings name',
            ),
          ),
        ),
      );

      final finder = find.byType(TextFormField);
      expect(finder, findsOneWidget);

      await tester.enterText(finder, 'Emergency Fund');
      await tester.pumpAndSettle();

      expect(controller.text, 'Emergency Fund');
      expect(find.text('Emergency Fund'), findsOneWidget);
    });

    testWidgets('allows typing and displays text when prefix and suffix are present', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 350,
              child: AppTextField(
                controller: controller,
                label: 'Target Amount',
                standaloneLabel: true,
                keyboardType: TextInputType.number,
                prefix: const Text('₦'),
                suffix: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Text('NGN'),
                ),
              ),
            ),
          ),
        ),
      );

      final finder = find.byType(TextFormField);
      expect(finder, findsOneWidget);

      await tester.enterText(finder, '750000');
      await tester.pumpAndSettle();

      expect(controller.text, '750000');
      expect(find.text('750000'), findsOneWidget);
      expect(find.text('₦'), findsOneWidget);
      expect(find.text('NGN'), findsOneWidget);

      // Verify editable text has positive width and is not collapsed
      final renderBox = tester.renderObject(find.byType(EditableText)) as RenderBox;
      expect(renderBox.size.width, greaterThan(150));
    });

    testWidgets('allows typing in password field with visibility toggle', (tester) async {
      final controller = TextEditingController();
      bool obscure = true;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 350,
                  child: AppTextField(
                    controller: controller,
                    label: 'Password',
                    obscureText: obscure,
                    prefix: const Icon(Icons.lock_outline),
                    suffix: IconButton(
                      icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

      final finder = find.byType(TextFormField);
      await tester.enterText(finder, 'MySecretPass123');
      await tester.pumpAndSettle();

      expect(controller.text, 'MySecretPass123');

      // Toggle visibility
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.text('MySecretPass123'), findsOneWidget);

      // Verify editable text has positive width and is not collapsed
      final renderBox = tester.renderObject(find.byType(EditableText)) as RenderBox;
      expect(renderBox.size.width, greaterThan(150));
    });
  });
}
