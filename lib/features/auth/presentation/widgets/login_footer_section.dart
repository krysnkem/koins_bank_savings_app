import 'package:flutter/material.dart';

/// Footer section on Login screen with registration link.
class LoginFooterSection extends StatelessWidget {
  const LoginFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            // EXPECTATION: non-functional in v1. Snackbar "Coming soon".
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon')),
            );
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}
