import '../entities/guess.dart';
import '../entities/feedback_pegs.dart';

class GameEngine {
  /// Evaluates a guess against the hidden solution and returns feedback pegs.
  static FeedbackPegs evaluateGuess(Guess guess, Guess solution) {
    int correctPositionAndColor = 0;
    int correctColorOnly = 0;

    List<bool> guessUsed = List.filled(5, false);
    List<bool> solutionUsed = List.filled(5, false);

    // First pass: Find exact matches (Green)
    for (int i = 0; i < 5; i++) {
      if (guess.colors[i] == solution.colors[i]) {
        correctPositionAndColor++;
        guessUsed[i] = true;
        solutionUsed[i] = true;
      }
    }

    // Second pass: Find partial matches (Yellow)
    for (int i = 0; i < 5; i++) {
      if (!guessUsed[i]) {
        for (int j = 0; j < 5; j++) {
          if (!solutionUsed[j] && guess.colors[i] == solution.colors[j]) {
            correctColorOnly++;
            solutionUsed[j] = true;
            break;
          }
        }
      }
    }

    return FeedbackPegs(
      correctPositionAndColor: correctPositionAndColor,
      correctColorOnly: correctColorOnly,
    );
  }
}
