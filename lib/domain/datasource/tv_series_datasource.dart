import 'package:cinemapedia/domain/domain_barrel.dart';

abstract class TvSerieDatasource {
  Future<List<TvSerie>> getAiringToday({int page = 1});
  Future<List<TvSerie>> getPopularTvSeries({int page = 1});
  Future<List<TvSerie>> getRatedTvSeries({int page = 1});
  Future<List<TvSerie>> getOnTheAirTvSerie({int page = 1});
  Future<TvSerie> getTvSerieById(String id);
  Future<List<TvSerie>> searchTvSeries(String query);

  // Future<bool> isTvSerieFavorite(int movieId);
}
