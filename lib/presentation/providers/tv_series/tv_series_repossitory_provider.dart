import 'package:cinemapedia/infrastructure/infrastructure_barrel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvSeriesRepositoryProvider = Provider((ref) {
  return TvSeriesRepositoryImpl(TvSerieMovidbDatasource()) ;
});
