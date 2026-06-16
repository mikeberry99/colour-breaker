import 'package:go_router/go_router.dart';
import '../../features/game_board/presentation/pages/game_board_screen.dart';
import '../../features/level_selection/presentation/pages/level_selection_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LevelSelectionScreen(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameBoardScreen(),
    ),
  ],
);
