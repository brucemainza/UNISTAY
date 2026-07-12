import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:unistay/main.dart';

void main() {
  testWidgets('UniStay launches to splash screen', (tester) async {
    await tester.pumpWidget(
      const UniStayApp(splashMinDisplay: Duration(milliseconds: 100)),
    );

    expect(find.text('UniStay'), findsOneWidget);
    // Allow the splash timer to fire and navigation to complete so no
    // pending timers remain when the widget tree is torn down.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Splash navigates to login', (tester) async {
    await tester.pumpWidget(
      const UniStayApp(splashMinDisplay: Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();

    expect(find.text('Phone Number'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
