import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colour_breaker/features/game_board/domain/entities/game_color.dart';
import 'package:colour_breaker/features/game_board/domain/entities/game_state.dart';
import 'package:colour_breaker/features/game_board/domain/entities/guess.dart';
import 'package:colour_breaker/features/game_board/domain/entities/number_quotes.dart';
import 'package:colour_breaker/features/game_board/domain/use_cases/game_engine.dart';
import 'package:colour_breaker/features/game_board/presentation/providers/game_provider.dart';
import 'package:colour_breaker/features/level_selection/presentation/providers/level_selection_provider.dart';

void main() {
  group('GameEngine Sequence Evaluation', () {
    test('4-slot evaluation (Novice/Breacher)', () {
      const solution = Guess(colors: [
        GameColor.red,
        GameColor.blue,
        GameColor.green,
        GameColor.yellow,
      ]);

      // All correct position and color
      final guess1 = Guess(colors: [
        GameColor.red,
        GameColor.blue,
        GameColor.green,
        GameColor.yellow,
      ]);
      final fb1 = GameEngine.evaluateGuess(guess1, solution);
      expect(fb1.correctPositionAndColor, 4);
      expect(fb1.correctColorOnly, 0);
      expect(fb1.isWin(4), isTrue);

      // Part correct color, part position
      final guess2 = Guess(colors: [
        GameColor.yellow,
        GameColor.blue,
        GameColor.purple,
        GameColor.red,
      ]);
      final fb2 = GameEngine.evaluateGuess(guess2, solution);
      // Blue at index 1 is exact match (1)
      // Yellow and Red are correct colors but wrong positions (2)
      // Purple is not in solution (0)
      expect(fb2.correctPositionAndColor, 1);
      expect(fb2.correctColorOnly, 2);
      expect(fb2.isWin(4), isFalse);
    });

    test('5-slot evaluation (Expert/Ghost)', () {
      const solution = Guess(colors: [
        GameColor.red,
        GameColor.blue,
        GameColor.green,
        GameColor.yellow,
        GameColor.purple,
      ]);

      final guess = Guess(colors: [
        GameColor.purple,
        GameColor.yellow,
        GameColor.green,
        GameColor.blue,
        GameColor.red,
      ]);
      final fb = GameEngine.evaluateGuess(guess, solution);
      // Green is exact match (1)
      // Red, Blue, Yellow, Purple are wrong positions (4)
      expect(fb.correctPositionAndColor, 1);
      expect(fb.correctColorOnly, 4);
      expect(fb.isWin(5), isFalse);
    });
  });

  group('GameState Level Configurations', () {
    test('Novice protocol parameters', () {
      const state = GameState(protocol: SecurityProtocol.novice);
      expect(state.slotCount, 4);
      expect(state.absoluteMaxAttempts, 100);
    });

    test('Breacher protocol parameters', () {
      const state = GameState(protocol: SecurityProtocol.breacher);
      expect(state.slotCount, 4);
      expect(state.absoluteMaxAttempts, 10);
    });

    test('Expert protocol parameters', () {
      const state = GameState(protocol: SecurityProtocol.expert);
      expect(state.slotCount, 5);
      expect(state.absoluteMaxAttempts, 25);
    });

    test('Ghost protocol parameters', () {
      const state = GameState(protocol: SecurityProtocol.ghost);
      expect(state.slotCount, 5);
      expect(state.absoluteMaxAttempts, 15);
    });
  });

  group('GameStateNotifier Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initializes Novice with 4 slots and initial maxAttempts of 10', () {
      final state = container.read(gameStateProvider);
      expect(state.protocol, SecurityProtocol.novice);
      expect(state.slotCount, 4);
      expect(state.maxAttempts, 10);
      expect(state.history, isEmpty);

      final notifier = container.read(gameStateProvider.notifier);
      expect(notifier.debugSolution.colors.length, 4);
    });

    test('Initializes Expert with 5 slots and initial maxAttempts of 10', () {
      container.read(selectedProtocolProvider.notifier).setProtocol(SecurityProtocol.expert);
      final state = container.read(gameStateProvider);
      expect(state.protocol, SecurityProtocol.expert);
      expect(state.slotCount, 5);
      expect(state.maxAttempts, 10);

      final notifier = container.read(gameStateProvider.notifier);
      expect(notifier.debugSolution.colors.length, 5);

      // Verify colors are unique
      final colorsSet = notifier.debugSolution.colors.toSet();
      expect(colorsSet.length, 5);
    });

    test('Row generation logic on failure', () {
      container.read(selectedProtocolProvider.notifier).setProtocol(SecurityProtocol.breacher);
      var state = container.read(gameStateProvider);
      final notifier = container.read(gameStateProvider.notifier);
      final solution = notifier.debugSolution;

      final incorrectColors = solution.colors.map((c) {
        return GameColor.values.firstWhere((color) => color != c && color != GameColor.empty);
      }).toList();

      final incorrectGuess = Guess(colors: incorrectColors);

      // Make 9 incorrect guesses
      for (int i = 0; i < 9; i++) {
        for (final c in incorrectGuess.colors) {
          notifier.addColor(c);
        }
        notifier.submitGuess();
      }

      state = container.read(gameStateProvider);
      expect(state.history.length, 9);
      expect(state.maxAttempts, 10);
      expect(state.status, GameStatus.playing);

      // Make the 10th incorrect guess
      for (final c in incorrectGuess.colors) {
        notifier.addColor(c);
      }
      notifier.submitGuess();

      state = container.read(gameStateProvider);
      expect(state.history.length, 10);
      // Breacher should NOT generate a new row and should immediately fail
      expect(state.maxAttempts, 10);
      expect(state.status, GameStatus.lost);
    });

    test('Novice generates new row when 10th guess fails', () {
      container.read(selectedProtocolProvider.notifier).setProtocol(SecurityProtocol.novice);
      var state = container.read(gameStateProvider);
      final notifier = container.read(gameStateProvider.notifier);
      final solution = notifier.debugSolution;

      final incorrectColors = solution.colors.map((c) {
        return GameColor.values.firstWhere((color) => color != c && color != GameColor.empty);
      }).toList();
      final incorrectGuess = Guess(colors: incorrectColors);

      // Make 10 incorrect guesses
      for (int i = 0; i < 10; i++) {
        for (final c in incorrectGuess.colors) {
          notifier.addColor(c);
        }
        notifier.submitGuess();
      }

      state = container.read(gameStateProvider);
      expect(state.history.length, 10);
      // Novice should dynamically generate an 11th row!
      expect(state.maxAttempts, 11);
      expect(state.status, GameStatus.playing);
    });
  });

  group('NumberQuotes and SelectedQuote tests', () {
    test('Retrieve random quotes for 1 to 15 attempts', () {
      for (int i = 1; i <= 15; i++) {
        final quote = NumberQuotes.getRandomQuote(i);
        expect(quote, isNotNull);
        expect(quote!.isNotEmpty, isTrue);
      }
    });

    test('Return null for attempts > 15', () {
      final quote = NumberQuotes.getRandomQuote(16);
      expect(quote, isNull);
    });

    test('Selects quote on game won', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      final notifier = container.read(gameStateProvider.notifier);
      final solution = notifier.debugSolution;

      // Make a winning guess
      for (final color in solution.colors) {
        notifier.addColor(color);
      }
      notifier.submitGuess();

      final state = container.read(gameStateProvider);
      expect(state.status, GameStatus.won);
      expect(state.selectedQuote, isNotNull);
    });
  });
}
