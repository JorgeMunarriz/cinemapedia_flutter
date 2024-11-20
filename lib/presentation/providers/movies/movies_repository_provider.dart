
import 'package:cinemapedia/infrastructure/infrastructure_barrel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Este repositorio es inmutable
final moviesRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});


