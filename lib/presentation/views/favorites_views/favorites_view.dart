import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';

class FavoritesView extends ConsumerStatefulWidget {
  static const name = 'favorites-views';
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView>
    with AutomaticKeepAliveClientMixin {
  bool isLastPage = false;
  bool isLoading = false;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void loadNextPage() async {
    // Asegúrate de que el widget esté montado antes de realizar cualquier acción.
    if (isLoading || isLastPage || _isDisposed) return;

    isLoading = true;

    // Verificar si el widget sigue montado antes de llamar a setState.
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    if (_isDisposed) return;

    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }

    if (mounted) {
      setState(() {}); // Puedes hacer un setState aquí si es necesario.
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Llamar a super.build para que funcione el mixin

    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();
    final colors = Theme.of(context).colorScheme;

    if (favoritesMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline_sharp,
              color: colors.primary,
            ),
            Text(
              'Ohh no!!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            const Text(
              'No tienes películas favoritas',
              style: TextStyle(fontSize: 20, color: Colors.black45),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.tonal(
              onPressed: () {
                final pageControllerContext = context
                    .findAncestorStateOfType<HomeScreenState>()
                    ?.pageController;
                pageControllerContext?.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Empieza a buscar'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas favoritas'),
      ),
      body: MoviesMasonry(
        loadNextPage: loadNextPage,
        movies: favoritesMovies,
      ),
    );
  }
}
