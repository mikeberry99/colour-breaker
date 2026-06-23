// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colour_breaker/main.dart';

void main() {
  testWidgets('Smoke test - Verify Level Selection and navigation to Game Board', (WidgetTester tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ColourBreakerApp()));

    // Verify that the selection screen title and header are present.
    expect(find.text('CODE HACKER'), findsOneWidget);
    expect(find.text('SYSTEM ACCESS'), findsOneWidget);
    expect(find.text('SELECT SECURITY PROTOCOL'), findsOneWidget);

    // Verify the level options are present
    expect(find.text('NOVICE DECRYPTOR'), findsOneWidget);
    expect(find.text('SYSTEM BREACHER'), findsOneWidget);
    expect(find.text('ENCRYPTION EXPERT'), findsOneWidget);
    expect(find.text('GHOST OPERATOR'), findsOneWidget);

    // Find and tap the ESTABLISH CONNECTION button
    final connectButton = find.text('ESTABLISH CONNECTION');
    expect(connectButton, findsOneWidget);
    await tester.tap(connectButton);
    await tester.pumpAndSettle();

    // Verify that we navigated to the Game Board screen (which contains the protocol label in the hidden solution)
    expect(find.textContaining('Protocol:'), findsOneWidget);
  });
}
