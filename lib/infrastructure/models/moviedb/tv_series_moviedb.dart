import 'package:cinemapedia/domain/domain_barrel.dart';

class TvSerieDB {
  final bool adult;
  final String? backdropPath;
  final List<GenreTv> genres; // Cambiado de `genreIds` a `List<Genre>`
  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath; // Hacer opcional
  final DateTime? firstAirDate; // Hacer opcional
  final String name;
  final double voteAverage;
  final int voteCount;

  TvSerieDB({
    required this.adult,
    required this.backdropPath,
    required this.genres,
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

  factory TvSerieDB.fromJson(Map<String, dynamic> json) => TvSerieDB(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        genres: (json["genres"] as List<dynamic>?)
                ?.map((genreJson) => GenreTv.fromJson(genreJson))
                .toList() ??
            [],
        id: json["id"],
        originCountry: List<String>.from(json["origin_country"] ?? []),
        originalLanguage: json["original_language"] ?? '',
        originalName: json["original_name"] ?? '',
        overview: json["overview"] ?? '',
        popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
        posterPath: json["poster_path"],
        firstAirDate: json["first_air_date"] != null
            ? DateTime.tryParse(json["first_air_date"])
            : null,
        name: json["name"] ?? '',
        voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genres": genres.map((genre) => genre.toJson()).toList(),
        "id": id,
        "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "first_air_date": firstAirDate != null
            ? "${firstAirDate!.year.toString().padLeft(4, '0')}-${firstAirDate!.month.toString().padLeft(2, '0')}-${firstAirDate!.day.toString().padLeft(2, '0')}"
            : null,
        "name": name,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
