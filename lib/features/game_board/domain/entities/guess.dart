import 'game_color.dart';

class Guess {
  final List<GameColor> colors;

  const Guess({required this.colors});

  bool get isComplete => colors.length == 5 && !colors.contains(GameColor.empty);
}
