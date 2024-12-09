import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:isar/isar.dart';
part 'tvserie.g.dart';

@collection
class TvSerie {
  Id? isarId;
  final bool adult;
  final String backdropPath;

  @ignore
  final List<GenreTv> genres; // Ignorado por Isar

  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;

  TvSerie({
    required this.adult,
    required this.backdropPath,
    this.genres =
        const [], // Esto solo es parte del constructor, pero no lo maneja Isar
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });
}

