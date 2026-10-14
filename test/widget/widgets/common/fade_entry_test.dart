import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/widgets/common/fade_entry.dart';

void main() {
  group('FadeEntry Widget Tests', () {
    testWidgets('animates opacity from 0 to 1 on initial entry', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FadeEntry(
              duration: Duration(milliseconds: 300),
              child: Text('Dynamic Loaded Content'),
            ),
          ),
        ),
      );

      // Verify the child widget exists
      expect(find.text('Dynamic Loaded Content'), findsOneWidget);

      // Initially, opacity is 0.0
      final opacityFinder = find.descendant(
        of: find.byType(FadeEntry),
        matching: find.byType(Opacity),
      );
      expect(opacityFinder, findsOneWidget);
      Opacity opacityWidget = tester.widget(opacityFinder);
      expect(opacityWidget.opacity, 0.0);

      // Advance halfway
      await tester.pump(const Duration(milliseconds: 150));
      opacityWidget = tester.widget(opacityFinder);
      expect(opacityWidget.opacity, greaterThan(0.0));
      expect(opacityWidget.opacity, lessThan(1.0));

      // Settle
      await tester.pumpAndSettle();
      opacityWidget = tester.widget(opacityFinder);
      expect(opacityWidget.opacity, 1.0);
    });

    testWidgets('FadeEntry.staggered respects index delay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                FadeEntry.staggered(
                  key: const ValueKey('item_0'),
                  index: 0,
                  step: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 200),
                  child: const Text('Item 0'),
                ),
                FadeEntry.staggered(
                  key: const ValueKey('item_2'),
                  index: 2,
                  step: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 200),
                  child: const Text('Item 2'),
                ),
              ],
            ),
          ),
        ),
      );

      final item0Finder = find.descendant(
        of: find.byKey(const ValueKey('item_0')),
        matching: find.byType(Opacity),
      );
      final item2Finder = find.descendant(
        of: find.byKey(const ValueKey('item_2')),
        matching: find.byType(Opacity),
      );

      // At start (0ms), Item 0 has delay=0 so it starts, Item 2 has delay=200ms
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.widget<Opacity>(item0Finder).opacity, greaterThan(0.0));
      expect(tester.widget<Opacity>(item2Finder).opacity, 0.0);

      // At 200ms, Item 2 timer fires; pump an additional frame so animation progresses
      await tester.pump(const Duration(milliseconds: 160));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.widget<Opacity>(item0Finder).opacity, 1.0);
      expect(tester.widget<Opacity>(item2Finder).opacity, greaterThan(0.0));

      await tester.pumpAndSettle();
      expect(tester.widget<Opacity>(item0Finder).opacity, 1.0);
      expect(tester.widget<Opacity>(item2Finder).opacity, 1.0);
    });

    testWidgets('FadeEntry.loaded transitions on isLoaded flag change', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeEntry.loaded(
              isLoaded: false,
              duration: const Duration(milliseconds: 200),
              child: const Text('Async Data'),
            ),
          ),
        ),
      );

      final opacityFinder = find.descendant(
        of: find.byType(FadeEntry),
        matching: find.byType(Opacity),
      );
      var opacity = tester.widget<Opacity>(opacityFinder);
      expect(opacity.opacity, 0.0);

      // Rebuild with isLoaded = true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeEntry.loaded(
              isLoaded: true,
              duration: const Duration(milliseconds: 200),
              child: const Text('Async Data'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      opacity = tester.widget<Opacity>(opacityFinder);
      expect(opacity.opacity, greaterThan(0.0));

      await tester.pumpAndSettle();
      opacity = tester.widget<Opacity>(opacityFinder);
      expect(opacity.opacity, 1.0);
    });

    testWidgets('FadeEntry with slideOffset applies FractionalTranslation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FadeEntry(
              key: ValueKey('sliding_entry'),
              slideOffset: Offset(0, 0.1),
              duration: Duration(milliseconds: 200),
              child: Text('Sliding Item'),
            ),
          ),
        ),
      );

      final translationFinder = find.descendant(
        of: find.byKey(const ValueKey('sliding_entry')),
        matching: find.byType(FractionalTranslation),
      );
      expect(translationFinder, findsOneWidget);
      await tester.pumpAndSettle();

      final translation = tester.widget<FractionalTranslation>(translationFinder);
      expect(translation.translation, Offset.zero);
    });
  });
}
