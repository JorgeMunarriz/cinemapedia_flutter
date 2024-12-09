import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/infrastructure/infrastructure_barrel.dart';

class TvSerieMapper {
  static TvSerie tvSerieDBToEntity(TvSerieDB tvSeriedb) => TvSerie(
        adult: tvSeriedb.adult,
        backdropPath: (tvSeriedb.backdropPath != '')
            ? 'https://image.tmdb.org/t/p/w500${tvSeriedb.backdropPath}'
            : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
        genres: tvSeriedb.genres, // Aquí usamos la lista de `Genre`
        id: tvSeriedb.id,
        originCountry: tvSeriedb.originCountry,
        originalLanguage: tvSeriedb.originalLanguage,
        originalName: tvSeriedb.originalName,
        overview: tvSeriedb.overview,
        popularity: tvSeriedb.popularity,
        posterPath: (tvSeriedb.posterPath != '')
            ? 'https://image.tmdb.org/t/p/w500${tvSeriedb.posterPath}'
            : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
        firstAirDate: tvSeriedb.firstAirDate ??  DateTime(1970),
        name: tvSeriedb.name,
        voteAverage: tvSeriedb.voteAverage,
        voteCount: tvSeriedb.voteCount,
      );

  static TvSerie tvSerieDetailsToEntity(TvSeriesDetails tvSerie) => TvSerie(
    id: tvSerie.id,
        adult: tvSerie.adult,
        backdropPath: (tvSerie.backdropPath != '')
            ? 'https://image.tmdb.org/t/p/w500${tvSerie.backdropPath}'
            : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
        genres: tvSerie.genres
            .map((genre) => GenreTv(id: genre.id, name: genre.name))
            .toList(), // Mapeo a la lista completa de géneros        id: tvSerie.id,
        originCountry: tvSerie.originCountry,
        originalLanguage: tvSerie.originalLanguage,
        originalName: tvSerie.originalName,
        overview: tvSerie.overview,
        popularity: tvSerie.popularity,
        posterPath: (tvSerie.posterPath != '')
            ? 'https://image.tmdb.org/t/p/w500${tvSerie.posterPath}'
            : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
        firstAirDate: tvSerie.firstAirDate,
        name: tvSerie.name,
        voteAverage: tvSerie.voteAverage,
        voteCount: tvSerie.voteCount,
      );
}
