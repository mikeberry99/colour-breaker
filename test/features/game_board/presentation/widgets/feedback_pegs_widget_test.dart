import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex_breaker/features/game_board/domain/entities/security_protocol.dart';
import 'package:hex_breaker/features/game_board/presentation/widgets/feedback_pegs_widget.dart';

void main() {
  testWidgets('FeedbackPegsWidget renders FeedbackSegmentRing when active', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FeedbackPegsWidget(
            protocol: SecurityProtocol.novice, // 4 pegs
            greenPegs: 2,
            yellowPegs: 1,
          ),
        ),
      ),
    );

    expect(find.byType(FeedbackSegmentRing), findsOneWidget);
  });

  testWidgets('FeedbackPegsWidget renders 5-segment FeedbackSegmentRing for expert protocol', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FeedbackPegsWidget(
            protocol: SecurityProtocol.expert, // 5 pegs
            greenPegs: 3,
            yellowPegs: 1,
          ),
        ),
      ),
    );

    expect(find.byType(FeedbackSegmentRing), findsOneWidget);
    final ring = tester.widget<FeedbackSegmentRing>(find.byType(FeedbackSegmentRing));
    expect(ring.pegs.length, equals(5));
  });
}
