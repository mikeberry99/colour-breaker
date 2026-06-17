import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game_color.dart';
import '../../domain/entities/guess.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/feedback_pegs.dart';
import '../../domain/entities/security_protocol.dart';
import '../../domain/use_cases/game_engine.dart';
import '../../../level_selection/presentation/providers/level_selection_provider.dart';
import 'dart:math';

final gameStateProvider = NotifierProvider<GameStateNotifier, GameState>(GameStateNotifier.new);

class GameStateNotifier extends Notifier<GameState> {
  late Guess _hiddenSolution;

  @override
  GameState build() {
    final protocol = ref.watch(selectedProtocolProvider);
    _generateSolution(protocol);
    return GameState(
      protocol: protocol,
      maxAttempts: 10,
    );
  }

  void _generateSolution(SecurityProtocol protocol) {
    final random = Random();
    final validColors = GameColor.values.where((c) => c != GameColor.empty).toList();
    List<GameColor> solutionColors = [];
    final slotCount = (protocol == SecurityProtocol.novice || protocol == SecurityProtocol.breacher) ? 4 : 5;

    if (protocol == SecurityProtocol.expert) {
      final shuffledColors = List<GameColor>.from(validColors)..shuffle(random);
      solutionColors = shuffledColors.sublist(0, slotCount);
    } else {
      for (int i = 0; i < slotCount; i++) {
        solutionColors.add(validColors[random.nextInt(validColors.length)]);
      }
    }
    _hiddenSolution = Guess(colors: solutionColors);
  }

  void addColor(GameColor color) {
    if (state.status != GameStatus.playing) return;
    if (state.activeGuess.colors.length < state.slotCount) {
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
    if (!state.activeGuess.isCompleteFor(state.slotCount)) return;

    final feedback = GameEngine.evaluateGuess(state.activeGuess, _hiddenSolution);
    
    final newHistory = List<Guess>.from(state.history)..add(state.activeGuess);
    final newFeedbacks = List<FeedbackPegs>.from(state.feedbacks)..add(feedback);
    
    GameStatus newStatus = GameStatus.playing;
    int newMaxAttempts = state.maxAttempts;

    if (feedback.isWin(state.slotCount)) {
      newStatus = GameStatus.won;
    } else {
      if (newHistory.length >= state.maxAttempts) {
        if (state.maxAttempts < state.absoluteMaxAttempts) {
          newMaxAttempts = state.maxAttempts + 1;
        } else {
          newStatus = GameStatus.lost;
        }
      }
    }

    state = state.copyWith(
      history: newHistory,
      feedbacks: newFeedbacks,
      activeGuess: const Guess(colors: []),
      status: newStatus,
      maxAttempts: newMaxAttempts,
    );
  }

  void restartGame() {
    final protocol = ref.read(selectedProtocolProvider);
    _generateSolution(protocol);
    state = GameState(
      gameId: state.gameId + 1,
      protocol: protocol,
      maxAttempts: 10,
    );
  }

  void restartLevel() {
    state = GameState(
      gameId: state.gameId + 1,
      protocol: state.protocol,
      maxAttempts: 10,
    );
  }
  
  // Expose the solution only when game is over
  Guess? get revealedSolution => state.status != GameStatus.playing ? _hiddenSolution : null;

  // DEBUG ONLY: always exposes the hidden solution for testing
  Guess get debugSolution => _hiddenSolution;
}
