import 'package:cinemapedia/domain/domain_barrel.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleFavorite(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0});
}
