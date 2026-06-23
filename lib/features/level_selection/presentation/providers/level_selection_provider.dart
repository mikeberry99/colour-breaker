import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../game_board/domain/entities/security_protocol.dart';
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
