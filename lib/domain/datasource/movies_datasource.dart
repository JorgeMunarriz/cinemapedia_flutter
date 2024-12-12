import 'package:cinemapedia/domain/domain_barrel.dart';


abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getRatedMovies({int page = 1});
  Future<List<Movie>> getUpcomingMovies({int page = 1});
  Future<Movie> getMovieById(String id);
  Future<List<Movie>> searchMovies(String query);
  Future<List<Movie>> getSimilarMovies( int movieId );
  Future<List<Video>> getYoutubeVideosById( int movieId );
}
