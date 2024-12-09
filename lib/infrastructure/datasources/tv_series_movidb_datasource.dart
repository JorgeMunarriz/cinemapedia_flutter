import 'package:cinemapedia/infrastructure/infrastructure_barrel.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/domain_barrel.dart';

class TvSerieMovidbDatasource extends TvSerieDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-Es',
    },
  ));

  List<TvSerie> _jsonToTvSerie(Map<String, dynamic> json) {
    final tvSerieDbResponse = TvSerieDbResponse.fromJson(json);
    final List<TvSerie> tvSeries = tvSerieDbResponse.results
        .where((tvSerieDb) => tvSerieDb.posterPath != 'no-poster')
        .map((tvSerieDb) => TvSerieMapper.tvSerieDBToEntity(tvSerieDb))
        .toList();
    return tvSeries;
  }

  @override
  Future<List<TvSerie>> getAiringToday({int page = 1}) async {
    final respose =
        await dio.get('/tv/airing_today', queryParameters: {'page': page});

    return _jsonToTvSerie(respose.data);
  }

  @override
  Future<List<TvSerie>> getPopularTvSeries({int page = 1}) async {
    try {
      final response =
          await dio.get('/tv/popular', queryParameters: {'page': page});

      return _jsonToTvSerie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TvSerie>> getRatedTvSeries({int page = 1}) async {
    final respose =
        await dio.get('/tv/top_rated', queryParameters: {'page': page});

    return _jsonToTvSerie(respose.data);
  }

  @override
  Future<TvSerie> getTvSerieById(String id) async {
    final response = await dio.get('/tv/$id');
    
    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id not found');
    }

    final tvSerieDetails = TvSeriesDetails.fromJson(response.data);

    final TvSerie tvSerie =
        TvSerieMapper.tvSerieDetailsToEntity(tvSerieDetails);

    return tvSerie;
  }

  @override
  Future<List<TvSerie>> getOnTheAirTvSerie({int page = 1}) async {
    final respose =
        await dio.get('/tv/on_the_air', queryParameters: {'page': page});

    return _jsonToTvSerie(respose.data);
  }

  @override
  Future<List<TvSerie>> searchTvSeries(String query) async {
    if (query.isEmpty) return [];
    final response =
        await dio.get('/search/serie', queryParameters: {'query': query});
    return _jsonToTvSerie(response.data);
  }

  // @override
  // Future<bool> isTvSerieFavorite(int movieId) {
  //   throw UnimplementedError();
  // }
}
