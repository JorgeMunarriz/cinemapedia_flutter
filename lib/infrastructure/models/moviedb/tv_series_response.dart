import 'dart:convert';
import 'package:cinemapedia/infrastructure/infrastructure_barrel.dart';

TvSerieDbResponse tvSeriesResponseFromJson(String str) => TvSerieDbResponse.fromJson(json.decode(str));

String tvSeriesResponseToJson(TvSerieDbResponse data) => json.encode(data.toJson());

class TvSerieDbResponse {
  final DatesTvSerie? dates;
  final int page;
  final List<TvSerieDB> results;
  final int totalPages;
  final int totalResults;

  TvSerieDbResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvSerieDbResponse.fromJson(Map<String, dynamic> json) =>
      TvSerieDbResponse(
        dates:
            json["dates"] != null ? DatesTvSerie.fromJson(json["dates"]) : null,
        page: json["page"],
        results: List<TvSerieDB>.from(
            json["results"].map((x) => TvSerieDB.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "dates": dates == null ? {} : dates!.toJson(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class DatesTvSerie {
  final DateTime maximum;
  final DateTime minimum;

  DatesTvSerie({
    required this.maximum,
    required this.minimum,
  });

  factory DatesTvSerie.fromJson(Map<String, dynamic> json) => DatesTvSerie(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toJson() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      };
}
