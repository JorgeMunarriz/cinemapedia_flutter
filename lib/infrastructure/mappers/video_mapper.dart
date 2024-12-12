import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/infrastructure/infrastructure_barrel.dart';

class VideoMapper {
  static videoMovieDBToEntity(VideoResult videoMovieDB) => Video(
      id: videoMovieDB.id,
      name: videoMovieDB.name,
      youtubeKey: videoMovieDB.key,
      publishedAt: videoMovieDB.publishedAt);
}
