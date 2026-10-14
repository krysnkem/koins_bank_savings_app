import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:koins_savings_app/features/products/presentation/widgets/product_details_hero_section.dart';
import 'package:koins_savings_app/features/products/presentation/widgets/product_details_specs_card.dart';

void main() {
  testWidgets('ProductDetailsScreen renders hero section and specs card for valid product', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailsScreen(productId: '1'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsHeroSection), findsOneWidget);
    expect(find.byType(ProductDetailsSpecsCard), findsOneWidget);
    expect(find.text('Target Savings'), findsNWidgets(2)); // AppBar + Hero
    expect(find.text('Minimum Deposit'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Create Savings'), findsOneWidget);
  });

  testWidgets('ProductDetailsScreen renders error state for invalid product id', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailsScreen(productId: 'invalid_id'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Product not found'), findsOneWidget);
  });
}
