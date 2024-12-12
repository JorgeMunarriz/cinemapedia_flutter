import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationCacheDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [MovieSchema, TvSerieSchema], // Incluye TvSerieSchema
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<bool> isTvSerieFavorite(int serieId) async {
    final isar = await db;

    final TvSerie? isFavoriteTvSerie =
        await isar.tvSeries.filter().idEqualTo(serieId).findFirst();

    return isFavoriteTvSerie != null;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;
    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    await isar.writeTxn(() async {
      if (favoriteMovie != null) {
        // Si la película está en favoritos, la eliminamos
        await isar.movies.delete(favoriteMovie.isarId!);
      } else {
        // Si la película no está en favoritos, la agregamos
        await isar.movies.put(movie);
      }
    });
  }

  @override
  Future<void> toggleFavoriteTvSerie(TvSerie tvSerie) async {
    final isar = await db;
    final favoriteTvSerie =
        await isar.tvSeries.filter().idEqualTo(tvSerie.id).findFirst();

    await isar.writeTxn(() async {
      if (favoriteTvSerie != null) {
        // Si la serie está en favoritos, la eliminamos
        await isar.tvSeries.delete(favoriteTvSerie.isarId!);
      } else {
        // Si la serie no está en favoritos, la agregamos
        await isar.tvSeries.put(tvSerie);
      }
    });
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<List<TvSerie>> loadTvSeries({int limit = 10, offset = 0}) async {
    final isar = await db;
    return isar.tvSeries.where().offset(offset).limit(limit).findAll();
  }
}
