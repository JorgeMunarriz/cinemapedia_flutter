import 'package:cinemapedia/domain/domain_barrel.dart';

abstract class LocalStorageDatasource {
  //Métodos para películas
  Future<void> toggleFavorite(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0});

  //Métodos para series
  Future<void> toggleFavoriteTvSerie(TvSerie tvSerie);
  Future<bool> isTvSerieFavorite(int serieId);
  Future<List<TvSerie>> loadTvSeries({int limit = 10, offset = 0});
}
