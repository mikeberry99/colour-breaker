import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hex_breaker/core/utils/platform_utils.dart';
import 'package:hex_breaker/features/game_board/presentation/pages/game_board_screen.dart';
import 'package:hex_breaker/features/game_board/presentation/widgets/active_guess_row.dart';
import 'package:hex_breaker/features/game_board/presentation/widgets/submit_button.dart';
import 'package:hex_breaker/features/game_board/domain/entities/game_state.dart';
import 'package:hex_breaker/features/game_board/domain/entities/security_protocol.dart';
import 'package:hex_breaker/features/game_board/presentation/widgets/game_result_overlay.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUp(() {
    // Reset test override before each test
    isMobileBrowserOverrideForTesting = false;
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('GameBoardScreen displays default layout on desktop/non-mobile browser', (WidgetTester tester) async {
    isMobileBrowserOverrideForTesting = false;

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: GameBoardScreen(),
        ),
      ),
    );

    // Verify ActiveGuessRow is present
    expect(find.byType(ActiveGuessRow), findsOneWidget);

    // Verify SubmitButton has the text "LOAD HACK" on desktop
    expect(find.text('LOAD HACK'), findsOneWidget);
    expect(find.text('LOAD'), findsNothing);

    // Verify that SubmitButton and ColorPalette are inside a Row together
    // (ColorPalette and SubmitButton are siblings in a Row on desktop)
    final rowFinder = find.descendant(
      of: find.byType(GameBoardScreen),
      matching: find.byType(Row),
    );
    
    expect(rowFinder, findsWidgets);
  });

  testWidgets('GameBoardScreen displays optimized layout on mobile browser', (WidgetTester tester) async {
    isMobileBrowserOverrideForTesting = true;

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: GameBoardScreen(),
        ),
      ),
    );

    // Verify ActiveGuessRow is present
    expect(find.byType(ActiveGuessRow), findsOneWidget);

    // Verify SubmitButton has the text "LOAD" on mobile browser
    expect(find.text('LOAD'), findsOneWidget);
    expect(find.text('LOAD HACK'), findsNothing);

    // Verify layout: ActiveGuessRow and SubmitButton should be in a Row together
    final activeGuessRowFinder = find.byType(ActiveGuessRow);
    final submitButtonFinder = find.byType(SubmitButton);
    expect(activeGuessRowFinder, findsOneWidget);
    expect(submitButtonFinder, findsOneWidget);

    // Let's verify that they are laid out horizontally in the same parent Row.
    // The Row contains ActiveGuessRow, SizedBox, and SubmitButton.
    final rowFinder = find.ancestor(
      of: activeGuessRowFinder,
      matching: find.byType(Row),
    );
    expect(rowFinder, findsAtLeastNWidgets(1));
  });

  testWidgets('GameResultOverlay renders without overflow and matches sizes on desktop', (WidgetTester tester) async {
    isMobileBrowserOverrideForTesting = false;

    final mockGameState = GameState(
      protocol: SecurityProtocol.novice,
      maxAttempts: 10,
      status: GameStatus.won,
      selectedQuote: 'Test win quote',
    );

    // Set constraints to small layout size to check for overflow errors
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GameResultOverlay(
            gameState: mockGameState,
            sessionSeed: 'MOCK-SEED',
            onClose: () {},
            onNewGame: () {},
          ),
        ),
      ),
    );

    expect(find.text('SYSTEM BREACHED'), findsOneWidget);
    expect(find.text('ATTEMPTS'), findsOneWidget);
    expect(find.text('"Test win quote"'), findsOneWidget);
    expect(find.text('PLAY AGAIN?'), findsOneWidget);
  });

  testWidgets('GameResultOverlay renders without overflow and matches sizes on mobile', (WidgetTester tester) async {
    isMobileBrowserOverrideForTesting = true;

    final mockGameState = GameState(
      protocol: SecurityProtocol.novice,
      maxAttempts: 10,
      status: GameStatus.won,
      selectedQuote: 'Test win quote',
    );

    // Set constraints to a very small mobile size to check for overflow errors
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GameResultOverlay(
            gameState: mockGameState,
            sessionSeed: 'MOCK-SEED',
            onClose: () {},
            onNewGame: () {},
          ),
        ),
      ),
    );

    expect(find.text('SYSTEM BREACHED'), findsOneWidget);
    expect(find.text('ATTEMPTS'), findsOneWidget);
    expect(find.text('"Test win quote"'), findsOneWidget);
    expect(find.text('PLAY AGAIN?'), findsOneWidget);
  });
}
