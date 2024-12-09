

import 'tv_series_repossitory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/domain_barrel.dart';

final tvSerieInfoProvider =
    StateNotifierProvider<TvSerieMapNotifier, Map<String, TvSerie>>((ref) {
  final tvSerieRepository = ref.watch(tvSeriesRepositoryProvider);
  return TvSerieMapNotifier(getTvSerie: tvSerieRepository.getTvSerieById);
});

typedef GetTvSerieCallback = Future<TvSerie> Function(String tvSerieId);

class TvSerieMapNotifier extends StateNotifier<Map<String, TvSerie>> {
  final GetTvSerieCallback getTvSerie;
  TvSerieMapNotifier({required this.getTvSerie}) : super({});

  Future<void> loadTvSerie(String tvSerieId) async {
    if (state[tvSerieId] != null) {
      return;
    }

    final tvSerie = await getTvSerie(tvSerieId);
    state = {...state, tvSerieId: tvSerie};
  }
}
