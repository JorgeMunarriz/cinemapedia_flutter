import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class FavoriteItem {
  final int id;
  final String type; // "movie" o "tvSerie"
  final dynamic data; // Instancia de Movie o TvSerie

  FavoriteItem({required this.id, required this.type, required this.data});
}

final favoriteMoviesAndSeriesProvider = StateNotifierProvider<
    StorageMoviesAndSeriesNotifier, Map<int, FavoriteItem>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesAndSeriesNotifier(
      localStorageRepository: localStorageRepository);
});

class StorageMoviesAndSeriesNotifier
    extends StateNotifier<Map<int, FavoriteItem>> {
  int moviePage = 0;
  int tvSeriesPage = 0;

  final LocalStorageRepository localStorageRepository;
  StorageMoviesAndSeriesNotifier({required this.localStorageRepository})
      : super({}) {
    _loadInitialFavorites();
  }
   final Logger logger = Logger();

  Future<void> _loadInitialFavorites() async {
    try {
      await loadNextPage();
      await loadNextPageTvSeries();
    } catch (e) {
      logger.e('Error al cargar favoritos iniciales: $e');
    }
  }

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(
        offset: moviePage * 10, limit: 20);
    moviePage++;
    final tempMoviesMap = <int, FavoriteItem>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] =
          FavoriteItem(id: movie.id, type: "movie", data: movie);
    }
    state = {...state, ...tempMoviesMap};
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id]?.type == 'movie';
    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {
        ...state,
        movie.id: FavoriteItem(id: movie.id, type: "movie", data: movie)
      };
    }
  }

  Future<List<TvSerie>> loadNextPageTvSeries() async {
    final tvSeries = await localStorageRepository.loadTvSeries(
        offset: tvSeriesPage * 10, limit: 20);
    tvSeriesPage++;
    final tempTvSeriesMap = <int, FavoriteItem>{};
    for (final tvSeries in tvSeries) {
      tempTvSeriesMap[tvSeries.id] =
          FavoriteItem(id: tvSeries.id, type: 'serie', data: tvSeries);
    }
    state = {...state, ...tempTvSeriesMap};
    return tvSeries;
  }

  Future<void> toggleFavoriteTvSerie(TvSerie tvSeries) async {
    await localStorageRepository.toggleFavoriteTvSerie(tvSeries);
    final bool isMovieInFavorites = state[tvSeries.id] != null;
    if (isMovieInFavorites) {
      state.remove(tvSeries.id);
      state = {...state};
    } else {
      state = {
        ...state,
        tvSeries.id:
            FavoriteItem(id: tvSeries.id, type: 'serie', data: tvSeries)
      };
    }
  }
}
