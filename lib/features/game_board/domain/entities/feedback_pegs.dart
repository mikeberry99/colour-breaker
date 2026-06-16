class FeedbackPegs {
  final int correctPositionAndColor; // Green peg
  final int correctColorOnly; // Yellow peg

  const FeedbackPegs({
    required this.correctPositionAndColor,
    required this.correctColorOnly,
  });

  bool get isWin => correctPositionAndColor == 5;
}
