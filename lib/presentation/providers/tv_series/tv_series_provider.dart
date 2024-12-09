import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final airingTodayProvider =
    StateNotifierProvider<TvSeriesNotifier, List<TvSerie>>((ref) {
  final fetchMoreTvSeries =
      ref.watch(tvSeriesRepositoryProvider).getAiringToday;

  return TvSeriesNotifier(fetchMoreTvSeries: fetchMoreTvSeries);
});

final popularTvSeriesProvider =
    StateNotifierProvider<TvSeriesNotifier, List<TvSerie>>((ref) {
  final fetchMoreTvSeries =
      ref.watch(tvSeriesRepositoryProvider).getPopularTvSeries;

  return TvSeriesNotifier(fetchMoreTvSeries: fetchMoreTvSeries);
});

final ratedTvSeriesProvider =
    StateNotifierProvider<TvSeriesNotifier, List<TvSerie>>(
  (ref) {
    final fetchMoreTvSeries =
        ref.watch(tvSeriesRepositoryProvider).getRatedTvSeries;
    return TvSeriesNotifier(fetchMoreTvSeries: fetchMoreTvSeries);
  },
);
final onTheAirTvSeriesProvider =
    StateNotifierProvider<TvSeriesNotifier, List<TvSerie>>(
  (ref) {
    final fetchMoreTvSeries =
        ref.watch(tvSeriesRepositoryProvider).getOnTheAirTvSerie;
    return TvSeriesNotifier(fetchMoreTvSeries: fetchMoreTvSeries);
  },
);

typedef TvSeriesCallback = Future<List<TvSerie>> Function({int page});

class TvSeriesNotifier extends StateNotifier<List<TvSerie>> {
  int currentPage = 0;
  bool isLoading = false;
  TvSeriesCallback fetchMoreTvSeries;

  TvSeriesNotifier({
    required this.fetchMoreTvSeries,
  }) : super([]) {
    loadNextPage(); // Cargar datos al inicializar
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;

    final List<TvSerie> tvSeries = await fetchMoreTvSeries(page: currentPage);
    state = [...state, ...tvSeries];

    isLoading = false;
  }
}
