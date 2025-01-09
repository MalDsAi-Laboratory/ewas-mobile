import 'package:simple_ui/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Simple Mobile UI Test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verify initial state
    expect(find.text('Enter text'), findsOneWidget); // TextField hint text
    expect(find.text('Submit'), findsOneWidget); // Button text
    expect(find.text('Your text will appear here.'), findsOneWidget); // Placeholder text

    // Enter text into the TextField
    await tester.enterText(find.byType(TextField), 'Hello Flutter!');
    await tester.pump(); // Rebuild the widget tree

    // Tap the Submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget tree after the button press

    // Verify the submitted text appears
    expect(find.text('Hello Flutter!'), findsOneWidget); // Submitted text
    expect(find.text('Your text will appear here.'), findsNothing); // Placeholder text removed
  });
}
