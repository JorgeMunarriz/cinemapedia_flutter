import 'package:cinemapedia/domain/domain_barrel.dart';


class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;
  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    return datasource.loadMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return datasource.toggleFavorite(movie);
  }
  @override
  Future<bool> isTvSerieFavorite(int serieId) {
    return datasource.isTvSerieFavorite(serieId);
  }

  @override
  Future<List<TvSerie>> loadTvSeries({int limit = 10, offset = 0}) {
    return datasource.loadTvSeries(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavoriteTvSerie(TvSerie tvSerie) {
    return datasource.toggleFavoriteTvSerie(tvSerie);
  }
}
