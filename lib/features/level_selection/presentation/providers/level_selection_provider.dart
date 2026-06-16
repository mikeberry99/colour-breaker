import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SecurityProtocol {
  novice,
  breacher,
  expert,
  ghost,
}

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
        return 'The standard 5-slot challenge. Requires logical precision to bypass the firewall.';
      case SecurityProtocol.expert:
        return '6-slot sequences with a limited attempt window. Only for those with high-level clearance.';
      case SecurityProtocol.ghost:
        return "6-slot sequences with 'invisible' feedback and a strict 10-attempt limit. The ultimate test of logic.";
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

final selectedProtocolProvider = NotifierProvider<SelectedProtocolNotifier, SecurityProtocol>(SelectedProtocolNotifier.new);
