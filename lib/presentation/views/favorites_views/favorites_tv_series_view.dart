import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';

class FavoritesTvSeriesView extends ConsumerStatefulWidget {
  static const name = 'favorites-tv-series-views';
  const FavoritesTvSeriesView({super.key});

  @override
  FavoritesTvSeriesViewState createState() => FavoritesTvSeriesViewState();
}

class FavoritesTvSeriesViewState extends ConsumerState<FavoritesTvSeriesView>
    with AutomaticKeepAliveClientMixin {
  bool isLastPage = false;
  bool isLoading = false;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadNextPageTvSeries();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void loadNextPageTvSeries() async {
    // Asegúrate de que el widget esté montado antes de realizar cualquier acción.
    if (isLoading || isLastPage || _isDisposed) return;

    isLoading = true;

    // Verificar si el widget sigue montado antes de llamar a setState.
    final tvSeries = await ref
        .read(favoriteMoviesAndSeriesProvider.notifier)
        .loadNextPageTvSeries();
    if (_isDisposed) return;

    isLoading = false;
    if (tvSeries.isEmpty) {
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
    final favoritesTvSeries = favoritesItems
        .where((item) => item.type == 'serie')
        .map((item) => item.data as TvSerie)
        .toList();
    final colors = Theme.of(context).colorScheme;

    if (favoritesTvSeries.isEmpty) {
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
              'No tienes series favoritas',
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
                  1,
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
        title: const Text('Series favoritas'),
      ),
      body: TvSeriesMasonry(
        loadNextPage: loadNextPageTvSeries,
        tvSeries: favoritesTvSeries,
      ),
    );
  }
}
