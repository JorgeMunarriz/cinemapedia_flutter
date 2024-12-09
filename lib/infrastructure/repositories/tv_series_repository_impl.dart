import 'package:cinemapedia/domain/domain_barrel.dart';

class TvSeriesRepositoryImpl extends TvSerieRepository {
  final TvSerieDatasource datasource;

  TvSeriesRepositoryImpl(this.datasource);

  @override
  Future<List<TvSerie>> getAiringToday({int page = 1}) {
    return datasource.getAiringToday(page: page);
  }

  @override
  Future<List<TvSerie>> getPopularTvSeries({int page = 1}) {
    return datasource.getPopularTvSeries(page: page);
  }

  @override
  Future<List<TvSerie>> getRatedTvSeries({int page = 1}) {
    return datasource.getRatedTvSeries(page: page);
  }

  @override
  Future<TvSerie> getTvSerieById(String id) {
    return datasource.getTvSerieById(id);
  }

  @override
  Future<List<TvSerie>> getOnTheAirTvSerie({int page = 1}) {
    return datasource.getOnTheAirTvSerie(page: page);
  }

  @override
  Future<List<TvSerie>> searchTvSeries(String query) {
    return datasource.searchTvSeries(query);
  }
}
