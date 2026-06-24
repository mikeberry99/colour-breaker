import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../game_board/domain/entities/security_protocol.dart';
import '../../../game_board/domain/entities/game_color.dart';
export '../../../game_board/domain/entities/security_protocol.dart';

class SelectedProtocolNotifier extends Notifier<SecurityProtocol> {
  @override
  SecurityProtocol build() {
    return SecurityProtocol.novice;
  }

  void setProtocol(SecurityProtocol protocol) {
    state = protocol;
  }
}

final selectedProtocolProvider =
    NotifierProvider<SelectedProtocolNotifier, SecurityProtocol>(
  SelectedProtocolNotifier.new,
);

class SessionSeedNotifier extends Notifier<({SecurityProtocol protocol, List<GameColor> sequence})?> {
  @override
  ({SecurityProtocol protocol, List<GameColor> sequence})? build() {
    return null;
  }

  void setSeed(({SecurityProtocol protocol, List<GameColor> sequence})? seed) {
    state = seed;
  }
}

final sessionSeedProvider =
    NotifierProvider<SessionSeedNotifier, ({SecurityProtocol protocol, List<GameColor> sequence})?>(
  SessionSeedNotifier.new,
);
