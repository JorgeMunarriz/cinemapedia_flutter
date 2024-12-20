import 'package:cinemapedia/presentation/screens/screens_barrel.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        if (pageIndex > viewRoutes.length - 1 || pageIndex < 0) {
          return const HomeScreen(pageIndex: 0);
        }
        return HomeScreen(
          pageIndex: pageIndex,
        );
      },
      routes: [
        GoRoute(
          path: '/movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(
              movieId: movieId,
            );
          },
        ),
        GoRoute(
          path: '/serie/:id',
          name: TvSerieScreen.name,
          builder: (context, state) {
            final tvSerieId = state.pathParameters['id'] ?? 'no-id';
            return TvSerieScreen(
              tvSerieId: tvSerieId,
            );
          },
        ),
        GoRoute(
          path: '/themes',
          name: ThemesScreen.name,
          builder: (context, state) {
            return const ThemesScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    )
  ],
);
