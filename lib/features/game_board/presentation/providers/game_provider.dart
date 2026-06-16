import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game_color.dart';
import '../../domain/entities/guess.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/feedback_pegs.dart';
import '../../domain/use_cases/game_engine.dart';
import 'dart:math';

final gameStateProvider = NotifierProvider<GameStateNotifier, GameState>(GameStateNotifier.new);

class GameStateNotifier extends Notifier<GameState> {
  late Guess _hiddenSolution;

  @override
  GameState build() {
    _generateSolution();
    return const GameState();
  }

  void _generateSolution() {
    final random = Random();
    final validColors = GameColor.values.where((c) => c != GameColor.empty).toList();
    List<GameColor> solutionColors = [];
    for (int i = 0; i < 5; i++) {
      solutionColors.add(validColors[random.nextInt(validColors.length)]);
    }
    _hiddenSolution = Guess(colors: solutionColors);
  }

  void addColor(GameColor color) {
    if (state.status != GameStatus.playing) return;
    if (state.activeGuess.colors.length < 5) {
      final newColors = List<GameColor>.from(state.activeGuess.colors)..add(color);
      state = state.copyWith(activeGuess: Guess(colors: newColors));
    }
  }

  void removeColor() {
    if (state.status != GameStatus.playing) return;
    if (state.activeGuess.colors.isNotEmpty) {
      final newColors = List<GameColor>.from(state.activeGuess.colors)..removeLast();
      state = state.copyWith(activeGuess: Guess(colors: newColors));
    }
  }

  void submitGuess() {
    if (state.status != GameStatus.playing) return;
    if (!state.activeGuess.isComplete) return;

    final feedback = GameEngine.evaluateGuess(state.activeGuess, _hiddenSolution);
    
    final newHistory = List<Guess>.from(state.history)..add(state.activeGuess);
    final newFeedbacks = List<FeedbackPegs>.from(state.feedbacks)..add(feedback);
    
    GameStatus newStatus = GameStatus.playing;
    if (feedback.isWin) {
      newStatus = GameStatus.won;
    } else if (newHistory.length >= state.maxAttempts) {
      newStatus = GameStatus.lost;
    }

    state = state.copyWith(
      history: newHistory,
      feedbacks: newFeedbacks,
      activeGuess: const Guess(colors: []),
      status: newStatus,
    );
  }

  void restartGame() {
    _generateSolution();
    state = GameState(gameId: state.gameId + 1);
  }

  void restartLevel() {
    state = GameState(gameId: state.gameId + 1);
  }
  
  // Expose the solution only when game is over
  Guess? get revealedSolution => state.status != GameStatus.playing ? _hiddenSolution : null;

  // DEBUG ONLY: always exposes the hidden solution for testing
  Guess get debugSolution => _hiddenSolution;
}
