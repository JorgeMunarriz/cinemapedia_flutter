// import 'package:cinemapedia/domain/domain_barrel.dart';
// import 'package:cinemapedia/presentation/presentation_barrel.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final favoriteTvSeriesProvider =
//     StateNotifierProvider<StorageTvSeriesNotifier, Map<int, TvSerie>>((ref) {
//   final tvSerielocalStorageRepository = ref.watch(tvSerieLocalStorageRepositoryProvider);
//   return StorageTvSeriesNotifier(tvSerielocalStorageRepository: tvSerielocalStorageRepository);
// });

// class StorageTvSeriesNotifier extends StateNotifier<Map<int, TvSerie>> {
//   int page = 0;
//   final TvSeriesLocalStorageRepository tvSerielocalStorageRepository;
//   StorageTvSeriesNotifier({required this.tvSerielocalStorageRepository}) : super({});

//   Future<List<TvSerie>> loadNextPage() async {
//     final tvSeries =
//         await tvSerielocalStorageRepository.loadTvSerie(offset: page * 10, limit: 20);
//     page++;
//     final tempTvSeriesMap = <int, TvSerie>{};
//     for (final tvSeries in tvSeries) {
//       tempTvSeriesMap[tvSeries.id] = tvSeries;
//     }
//     state = {...state, ...tempTvSeriesMap};
//     return tvSeries;
//   }

//   Future<void> toggleFavorite(TvSerie tvSeries) async {
//     await tvSerielocalStorageRepository.toggleFavoriteTvSerie(tvSeries);
//     final bool isMovieInFavorites = state[tvSeries.id] != null;
//     if (isMovieInFavorites) {
//       state.remove(tvSeries.id);
//       state = {...state};
//     } else {
//       state = {...state, tvSeries.id: tvSeries};
//     }
//   }
// }
