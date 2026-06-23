import 'game_color.dart';

class Guess {
  final List<GameColor> colors;

  const Guess({required this.colors});

  bool isCompleteFor(int slotCount) => colors.length == slotCount && !colors.contains(GameColor.empty);
}
