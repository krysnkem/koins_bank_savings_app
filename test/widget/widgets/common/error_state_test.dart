import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/widgets/common/error_state.dart';

void main() {
  group('ErrorState Widget Tests', () {
    testWidgets('renders sanitized user-friendly message for raw socket error',
        (tester) async {
      const rawError =
          "Failed to fetch posts from DummyJSON: ClientException with SocketException: Failed host lookup: 'dummyjson.com' (OS Error: No address associated with hostname, errno = 7), uri=https://dummyjson.com/posts?limit=3";

      bool retryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: rawError,
              onRetry: () => retryTapped = true,
            ),
          ),
        ),
      );

      // Verify that raw technical terms are NOT on the screen
      expect(find.text(rawError), findsNothing);
      expect(find.textContaining('errno = 7'), findsNothing);
      expect(find.textContaining('SocketException'), findsNothing);
      expect(find.textContaining('dummyjson.com'), findsNothing);

      // Verify that user-friendly text is shown
      expect(
        find.text(
          'Unable to connect to the internet. Please check your network connection and try again.',
        ),
        findsOneWidget,
      );

      // Verify retry button is rendered and functional
      expect(find.byType(ElevatedButton), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(retryTapped, isTrue);
    });
  });
}
