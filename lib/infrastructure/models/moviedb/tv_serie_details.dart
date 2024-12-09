import 'dart:convert';

import 'package:cinemapedia/domain/domain_barrel.dart';

TvSeriesDetails tvSeriesDetailsFromJson(String str) =>
    TvSeriesDetails.fromJson(json.decode(str));

String tvSeriesDetailsToJson(TvSeriesDetails data) =>
    json.encode(data.toJson());

GenreTv genreTvFromJson(String str) => GenreTv.fromJson(json.decode(str));

String genreTvToJson(GenreTv data) => json.encode(data.toJson());


class TvSeriesDetails {
  final bool adult;
  final String? backdropPath;
  final List<GenreTv> genres; // Cambié de List<int> a List<Genre>
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

  TvSeriesDetails({
    required this.adult,
    required this.backdropPath,
    required this.genres,  // Asegúrate de pasar una lista de objetos Genre
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

  factory TvSeriesDetails.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetails(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        // Aquí mapeamos correctamente a una lista de objetos Genre
        genres: List<GenreTv>.from(
          json["genres"].map((x) => GenreTv.fromJson(x)),
        ),
        id: json["id"],
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        firstAirDate: DateTime.parse(json["first_air_date"]),
        name: json["name"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        // Aquí convertimos la lista de objetos Genre a su formato JSON
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "id": id,
        "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "first_air_date":
            "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
        "name": name,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

