import 'package:flutter_test/flutter_test.dart';
import 'package:hex_breaker/features/game_board/domain/entities/game_color.dart';
import 'package:hex_breaker/features/game_board/domain/entities/game_seed.dart';
import 'package:hex_breaker/features/game_board/domain/entities/security_protocol.dart';

void main() {
  group('GameSeed', () {
    test('encodes and decodes novice protocol correctly', () {
      final protocol = SecurityProtocol.novice;
      final sequence = [GameColor.red, GameColor.blue, GameColor.green, GameColor.yellow];
      
      final seed = GameSeed.encode(protocol, sequence);
      expect(seed.length, 5);
      
      final decoded = GameSeed.decode(seed);
      expect(decoded, isNotNull);
      expect(decoded!.protocol, protocol);
      expect(decoded.sequence, sequence);
    });

    test('encodes and decodes ghost protocol correctly', () {
      final protocol = SecurityProtocol.ghost;
      final sequence = [GameColor.orange, GameColor.purple, GameColor.red, GameColor.blue, GameColor.green];
      
      final seed = GameSeed.encode(protocol, sequence);
      expect(seed.length, 5);
      
      final decoded = GameSeed.decode(seed);
      expect(decoded, isNotNull);
      expect(decoded!.protocol, protocol);
      expect(decoded.sequence, sequence);
    });

    test('fails on invalid length', () {
      expect(GameSeed.decode('ABCD'), isNull);
      expect(GameSeed.decode('ABCDEF'), isNull);
    });

    test('fails on invalid characters', () {
      expect(GameSeed.decode('ABC1A'), isNull);
      expect(GameSeed.decode('A-BCA'), isNull);
    });

    test('fails on bad checksum', () {
      final protocol = SecurityProtocol.novice;
      final sequence = [GameColor.red, GameColor.red, GameColor.red, GameColor.red];
      final seed = GameSeed.encode(protocol, sequence);
      
      // Change the checksum char to something else
      final badChecksumSeed = seed.substring(0, 4) + (seed[4] == 'A' ? 'B' : 'A');
      expect(GameSeed.decode(badChecksumSeed), isNull);
    });
  });
}
