import 'package:cinemapedia/presentation/screens/screens_barrel.dart';
import 'package:cinemapedia/presentation/views/views_barrel.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(childView: child);
        },
        routes: [
          GoRoute(
              path: '/',
              builder: (context, state) {
                return const HomeView();
              },
              routes: [
                GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) {
                    final movieId = state.pathParameters['id'] ?? 'no-id';
                    return MovieScreen(
                      movieId: movieId,
                    );
                  },
                ),
                GoRoute(
                  path: 'categories-view',
                  builder: (context, state) {
                    return const CategoriesView();
                  },
                ),
                GoRoute(
                  path: 'favorites-view',
                  builder: (context, state) {
                    return const FavoritesView();
                  },
                ),
              ]),
        ]),

    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   builder: (context, state) => const HomeScreen(
    //     childView: HomeView(),
    //   ),
    //   routes: [
    // GoRoute(
    //   path: 'movie/:id',
    //   name: MovieScreen.name,
    //   builder: (context, state) {
    //     final movieId = state.pathParameters['id'] ?? 'no-id';
    //     return MovieScreen(
    //       movieId: movieId,
    //     );
    //   },
    // ),
    //     GoRoute(
    //       path: 'categories-view',
    //       name: CategoriesView.name,
    //       builder: (context, state) => const CategoriesView(),
    //     )
    //   ],
    // ),
  ],
);
