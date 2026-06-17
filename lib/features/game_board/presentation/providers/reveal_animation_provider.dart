import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/security_protocol.dart';
import '../../../level_selection/presentation/providers/level_selection_provider.dart';

/// Holds the animation state for the most recently submitted guess row.
class RevealAnimationState {
  /// The history index of the row currently being animated. Null when idle.
  final int? animatingRowIndex;

  /// How many colour orbs have been revealed so far.
  final int revealedColors;

  /// Whether the feedback pegs are visible yet.
  final bool pegsVisible;

  const RevealAnimationState({
    this.animatingRowIndex,
    this.revealedColors = 0,
    this.pegsVisible = false,
  });

  bool get isAnimating => animatingRowIndex != null;

  RevealAnimationState copyWith({
    int? animatingRowIndex,
    int? revealedColors,
    bool? pegsVisible,
    bool clearAnimatingRow = false,
  }) {
    return RevealAnimationState(
      animatingRowIndex:
          clearAnimatingRow ? null : (animatingRowIndex ?? this.animatingRowIndex),
      revealedColors: revealedColors ?? this.revealedColors,
      pegsVisible: pegsVisible ?? this.pegsVisible,
    );
  }
}

class RevealAnimationNotifier extends Notifier<RevealAnimationState> {
  Timer? _timer;
  static const _stepDuration = Duration(milliseconds: 250);

  @override
  RevealAnimationState build() => const RevealAnimationState();

  /// Call this immediately after a guess is committed to the game state.
  /// [rowIndex] is the 0-based index of the newly added history row.
  void startReveal(int rowIndex) {
    _timer?.cancel();

    final protocol = ref.read(selectedProtocolProvider);
    final slotCount = (protocol == SecurityProtocol.novice || protocol == SecurityProtocol.breacher) ? 4 : 5;

    state = RevealAnimationState(
      animatingRowIndex: rowIndex,
      revealedColors: 0,
      pegsVisible: false,
    );

    _scheduleNext(rowIndex, slotCount: slotCount, step: 0);
  }

  void _scheduleNext(int rowIndex, {required int slotCount, required int step}) {
    _timer = Timer(_stepDuration, () {
      if (step < slotCount) {
        // Reveal next colour orb
        state = state.copyWith(revealedColors: step + 1);
        _scheduleNext(rowIndex, slotCount: slotCount, step: step + 1);
      } else {
        // All colours revealed — now reveal pegs
        state = state.copyWith(pegsVisible: true);
        // Animation fully complete — clear after a short settle
        _timer = Timer(_stepDuration, () {
          state = const RevealAnimationState();
        });
      }
    });
  }
}

final revealAnimationProvider =
    NotifierProvider<RevealAnimationNotifier, RevealAnimationState>(
  RevealAnimationNotifier.new,
);
