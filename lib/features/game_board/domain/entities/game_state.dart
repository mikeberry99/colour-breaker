import 'guess.dart';
import 'feedback_pegs.dart';
import 'security_protocol.dart';

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
  final SecurityProtocol protocol;
  final String? selectedQuote;

  const GameState({
    this.gameId = 0,
    this.history = const [],
    this.feedbacks = const [],
    this.activeGuess = const Guess(colors: []),
    this.status = GameStatus.playing,
    this.maxAttempts = 10,
    this.protocol = SecurityProtocol.novice,
    this.selectedQuote,
  });

  int get slotCount => (protocol == SecurityProtocol.novice || protocol == SecurityProtocol.breacher) ? 4 : 5;

  int get absoluteMaxAttempts {
    switch (protocol) {
      case SecurityProtocol.novice:
        return 100;
      case SecurityProtocol.breacher:
        return 10;
      case SecurityProtocol.expert:
        return 25;
      case SecurityProtocol.ghost:
        return 15;
    }
  }

  GameState copyWith({
    int? gameId,
    List<Guess>? history,
    List<FeedbackPegs>? feedbacks,
    Guess? activeGuess,
    GameStatus? status,
    int? maxAttempts,
    SecurityProtocol? protocol,
    String? selectedQuote,
    bool clearSelectedQuote = false,
  }) {
    return GameState(
      gameId: gameId ?? this.gameId,
      history: history ?? this.history,
      feedbacks: feedbacks ?? this.feedbacks,
      activeGuess: activeGuess ?? this.activeGuess,
      status: status ?? this.status,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      protocol: protocol ?? this.protocol,
      selectedQuote: clearSelectedQuote ? null : (selectedQuote ?? this.selectedQuote),
    );
  }
}
