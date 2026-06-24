import 'dart:math';
import 'game_color.dart';
import 'security_protocol.dart';

class GameSeed {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Encodes the chosen [protocol] and color [sequence] into a 5-letter seed.
  static String encode(SecurityProtocol protocol, List<GameColor> sequence) {
    int colorVal = 0;
    
    // We treat the sequence as a 5-digit base-6 number.
    // If the sequence is only 4 colors (novice, breacher), the 5th digit is implicitly 0 (red).
    for (int i = 0; i < 5; i++) {
      int cIndex = 0;
      if (i < sequence.length) {
        cIndex = sequence[i].index; 
      }
      colorVal += cIndex * pow(6, 4 - i).toInt();
    }

    int difficultyVal = protocol.index;
    int stateVal = (difficultyVal * 7776) + colorVal;

    // Convert to 4 character base-26 string, zero-padded with 'A'
    String base26 = _toBase26(stateVal).padLeft(4, 'A');

    // Calculate checksum
    int sum = 0;
    for (int i = 0; i < 4; i++) {
      sum += _alphabet.indexOf(base26[i]);
    }
    String checksumChar = _alphabet[sum % 26];

    return '$base26$checksumChar';
  }

  /// Decodes a 5-letter [seed] back into a protocol and color sequence.
  /// Returns null if the seed is invalid (wrong length, invalid chars, or bad checksum).
  static ({SecurityProtocol protocol, List<GameColor> sequence})? decode(String seed) {
    seed = seed.toUpperCase().trim();
    if (seed.length != 5) return null;

    String base26 = seed.substring(0, 4);
    String checksumChar = seed.substring(4, 5);

    // Validate characters and compute checksum sum
    int sum = 0;
    for (int i = 0; i < 4; i++) {
      int val = _alphabet.indexOf(base26[i]);
      if (val == -1) return null; // Invalid character
      sum += val;
    }
    
    // Check checksum
    if (_alphabet[sum % 26] != checksumChar) return null; 

    // Decode stateVal
    int stateVal = 0;
    for (int i = 0; i < 4; i++) {
      stateVal += _alphabet.indexOf(base26[i]) * pow(26, 3 - i).toInt();
    }

    if (stateVal >= 31104) return null; // Max possible value is 31103 (3 * 7776 + 7775)

    int difficultyVal = stateVal ~/ 7776;
    int colorVal = stateVal % 7776;

    if (difficultyVal >= SecurityProtocol.values.length) return null;
    SecurityProtocol protocol = SecurityProtocol.values[difficultyVal];

    List<GameColor> sequence = [];
    int remainingColorVal = colorVal;
    
    for (int i = 0; i < 5; i++) {
      int power = pow(6, 4 - i).toInt();
      int cIndex = remainingColorVal ~/ power;
      remainingColorVal = remainingColorVal % power;

      if (cIndex >= 6) return null; // Only colors 0-5 are valid
      GameColor color = GameColor.values[cIndex];
      sequence.add(color);
    }

    // Trim sequence based on protocol slot count
    if (protocol == SecurityProtocol.novice || protocol == SecurityProtocol.breacher) {
      sequence = sequence.sublist(0, 4);
    }

    return (protocol: protocol, sequence: sequence);
  }

  static String _toBase26(int value) {
    if (value == 0) return 'A';
    String result = '';
    while (value > 0) {
      result = _alphabet[value % 26] + result;
      value = value ~/ 26;
    }
    return result;
  }
}
