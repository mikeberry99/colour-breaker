import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:colour_breaker/features/game_board/domain/entities/game_color.dart';
import 'package:colour_breaker/features/game_board/domain/entities/game_seed.dart';
import 'package:colour_breaker/features/level_selection/presentation/widgets/seed_entry_dialog.dart';
import 'package:colour_breaker/features/level_selection/presentation/providers/level_selection_provider.dart';

void main() {
  testWidgets('SeedEntryDialog extracts seed from pasted share messages', (WidgetTester tester) async {
    final seed = GameSeed.encode(SecurityProtocol.novice, [
      GameColor.red,
      GameColor.blue,
      GameColor.green,
      GameColor.yellow,
    ]);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SeedEntryDialog(),
          ),
        ),
      ),
    );

    // Locate the TextField
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    String getControllerText() {
      final TextField textField = tester.widget(textFieldFinder);
      return textField.controller!.text;
    }

    // 1. Test victory share message
    final victoryMessage = 'I cracked the Code Hacker sequence in 5 attempts! Seed: $seed. Can you beat my score?';
    await tester.enterText(textFieldFinder, victoryMessage);
    await tester.pump();

    // The text field should show only the 5-letter seed
    expect(getControllerText(), seed);

    // Clear text field for next test
    await tester.enterText(textFieldFinder, '');
    await tester.pump();

    // 2. Test defeat share message
    final defeatMessage = 'Code Hacker proved too tough this time. Seed: $seed. Give it a try!';
    await tester.enterText(textFieldFinder, defeatMessage);
    await tester.pump();

    // The text field should show only the 5-letter seed
    expect(getControllerText(), seed);

    // Clear text field for next test
    await tester.enterText(textFieldFinder, '');
    await tester.pump();

    // 3. Test pasting only the seed
    await tester.enterText(textFieldFinder, seed.toLowerCase());
    await tester.pump();

    // The text field should show the uppercase seed
    expect(getControllerText(), seed);

    // Clear text field for next test
    await tester.enterText(textFieldFinder, '');
    await tester.pump();

    // 4. Test normal typing (longer text should be truncated to 5 chars if not a share message)
    await tester.enterText(textFieldFinder, 'ABCDEF');
    await tester.pump();

    // The text field should show truncated text 'ABCDE'
    expect(getControllerText(), 'ABCDE');
  });

  testWidgets('submits seed, sets providers, and navigates directly to game board', (WidgetTester tester) async {
    final seed = GameSeed.encode(SecurityProtocol.novice, [
      GameColor.red,
      GameColor.blue,
      GameColor.green,
      GameColor.yellow,
    ]);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Builder(
              builder: (innerContext) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: innerContext,
                    builder: (context) => const SeedEntryDialog(),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/game',
          builder: (context, state) => const Scaffold(body: Text('Game Screen')),
        ),
      ],
    );

    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(
              routerConfig: router,
            );
          },
        ),
      ),
    );

    // Open the dialog
    final openButtonFinder = find.text('Open Dialog');
    expect(openButtonFinder, findsOneWidget);
    await tester.tap(openButtonFinder);
    await tester.pumpAndSettle();

    // Enter a valid seed
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    await tester.enterText(textFieldFinder, seed);
    await tester.pump();

    // Tap LOAD SEED button
    final loadButtonFinder = find.text('LOAD SEED');
    expect(loadButtonFinder, findsOneWidget);
    await tester.tap(loadButtonFinder);
    await tester.pumpAndSettle();

    // Verify dialog is closed and navigation to game screen occurred
    expect(find.text('Game Screen'), findsOneWidget);

    // Verify providers were set correctly
    final sessionSeed = container.read(sessionSeedProvider);
    expect(sessionSeed, isNotNull);
    expect(sessionSeed!.protocol, SecurityProtocol.novice);
    expect(sessionSeed.sequence, [
      GameColor.red,
      GameColor.blue,
      GameColor.green,
      GameColor.yellow,
    ]);

    final selectedProtocol = container.read(selectedProtocolProvider);
    expect(selectedProtocol, SecurityProtocol.novice);
  });
}
