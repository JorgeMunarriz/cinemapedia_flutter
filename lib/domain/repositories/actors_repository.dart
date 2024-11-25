import 'package:cinemapedia/domain/domain_barrel.dart';

abstract class ActorsRepository {
  Future<List<Actor>> getActorsByMovie(String movieId);
}
