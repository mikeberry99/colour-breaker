import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../game_board/domain/entities/security_protocol.dart';
export '../../../game_board/domain/entities/security_protocol.dart';

extension SecurityProtocolExtension on SecurityProtocol {
  String get title {
    switch (this) {
      case SecurityProtocol.novice:
        return 'NOVICE DECRYPTOR';
      case SecurityProtocol.breacher:
        return 'SYSTEM BREACHER';
      case SecurityProtocol.expert:
        return 'ENCRYPTION EXPERT';
      case SecurityProtocol.ghost:
        return 'GHOST OPERATOR';
    }
  }

  String get description {
    switch (this) {
      case SecurityProtocol.novice:
        return '4-slot sequences with unlimited attempts. Perfect for learning the basic protocols.';
      case SecurityProtocol.breacher:
        return 'Classic 4-slot sequence, attempts limited. Requires logical precision to bypass the firewall.';
      case SecurityProtocol.expert:
        return 'Upgraded 5-slot sequences. Each color only appears once. Only for those with high-level clearance.';
      case SecurityProtocol.ghost:
        return "The ultimate test of logic. 5-slot sequence, colors can repeat, 15-attempt limit.";
    }
  }
}

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
        SelectedProtocolNotifier.new);
