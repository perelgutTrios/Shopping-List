// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_flutter_app/main.dart';

void main() {
  testWidgets('Shopping list displays initial items',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    // Verify that the initial items are displayed.
    expect(find.text('Eggs'), findsOneWidget);
    expect(find.text('Flour'), findsOneWidget);
    expect(find.text('Chocolate chips'), findsOneWidget);

    // Verify the cart counter starts at 0.
    expect(find.text('In Cart: 0'), findsOneWidget);

    // Verify the floating action button exists.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Adding item to cart updates counter',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    // Verify cart starts empty.
    expect(find.text('In Cart: 0'), findsOneWidget);

    // Tap on the first item (Eggs).
    await tester.tap(find.text('Eggs'));
    await tester.pump();

    // Verify the cart counter incremented.
    expect(find.text('In Cart: 1'), findsOneWidget);

    // Verify check icon appears (item is in cart).
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('Removing item from cart updates counter',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    // Add an item to cart.
    await tester.tap(find.text('Eggs'));
    await tester.pump();
    expect(find.text('In Cart: 1'), findsOneWidget);

    // Tap the same item again to remove it.
    await tester.tap(find.text('Eggs'));
    await tester.pump();

    // Verify the cart counter went back to 0.
    expect(find.text('In Cart: 0'), findsOneWidget);
  });

  testWidgets('Add item dialog appears when FAB is tapped',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    // Tap the floating action button.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify the dialog appears.
    expect(find.text('Add Item'), findsOneWidget);
    expect(find.text('Enter item name'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('Can add new item to shopping list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    // Tap the floating action button to open dialog.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Enter text in the text field.
    await tester.enterText(find.byType(TextField), 'Milk');

    // Tap the Add button.
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Verify the new item appears in the list.
    expect(find.text('Milk'), findsOneWidget);
  });
}
