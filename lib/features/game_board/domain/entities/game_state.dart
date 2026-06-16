import 'guess.dart';
import 'feedback_pegs.dart';

enum GameStatus {
  playing,
  won,
  lost
}

class GameState {
  final int gameId;
  final List<Guess> history;
  final List<FeedbackPegs> feedbacks;
  final Guess activeGuess;
  final GameStatus status;
  final int maxAttempts;

  const GameState({
    this.gameId = 0,
    this.history = const [],
    this.feedbacks = const [],
    this.activeGuess = const Guess(colors: []),
    this.status = GameStatus.playing,
    this.maxAttempts = 10, // From user approval
  });

  GameState copyWith({
    int? gameId,
    List<Guess>? history,
    List<FeedbackPegs>? feedbacks,
    Guess? activeGuess,
    GameStatus? status,
  }) {
    return GameState(
      gameId: gameId ?? this.gameId,
      history: history ?? this.history,
      feedbacks: feedbacks ?? this.feedbacks,
      activeGuess: activeGuess ?? this.activeGuess,
      status: status ?? this.status,
      maxAttempts: maxAttempts,
    );
  }
}
