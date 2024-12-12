import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadNextPage(); // Llama a la carga de datos aquí.
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
        await ref.read(favoriteMoviesAndSeriesProvider.notifier).loadNextPage();
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

    final favoritesItems = ref.watch(favoriteMoviesAndSeriesProvider).values;
    final favoritesMovies = favoritesItems
        .where((item) => item.type == 'movie')
        .map((item) => item.data as Movie)
        .toList();
    

    if (favoritesMovies.isEmpty) {
     
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline_sharp,
              color: Colors.primaries.first,
            ),
            Text(
              'Ohh no!!',
              style: TextStyle(fontSize: 30, color: Colors.primaries.last),
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
