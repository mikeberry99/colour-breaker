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
        return 'Classic 4-slot sequence, colors can repeat and attempts are limited.';
      case SecurityProtocol.expert:
        return 'Upgraded 5-slot sequences. Each color only appears once. Only for those with high-level clearance.';
      case SecurityProtocol.ghost:
        return "The ultimate test of logic. 5-slot sequence, colors can repeat, 15-attempt limit.";
    }
  }

  int get slotCount {
    switch (this) {
      case SecurityProtocol.novice:
      case SecurityProtocol.breacher:
        return 4;
      case SecurityProtocol.expert:
      case SecurityProtocol.ghost:
        return 5;
    }
  }
}
