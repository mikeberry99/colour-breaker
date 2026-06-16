import 'package:go_router/go_router.dart';
import '../../features/game_board/presentation/pages/game_board_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const GameBoardScreen(),
    ),
  ],
);
